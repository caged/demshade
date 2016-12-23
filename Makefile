# If you want to reproject output PNG images, you can specify SRS in the environment.
# SRS='EPSG:2913' make data/png/states/oregon.png
SRS ?= "EPSG:4326"
WIDTH ?= 2500
HEIGHT ?= 0
# Buffer area in miles around the state boundaries.  This is used to determine which grid files to
# feetch and draw.  Sometimes you want to draw the surrounding area around the state.
BUFFER ?= 10

STATE_FIPS = \
	01|al|alabama \
	02|ak|alaska \
	04|az|arizona \
	05|ar|arkansas \
	06|ca|california \
	08|co|colorado \
	09|ct|connecticut \
	10|de|delaware \
	11|dc|district_of_columbia \
	12|fl|florida \
	13|ga|georgia \
	15|hi|hawaii \
	16|id|idaho \
	17|il|illinois \
	18|in|indiana \
	19|ia|iowa \
	20|ks|kansas \
	21|ky|kentucky \
	22|la|louisiana \
	23|me|maine \
	24|md|maryland \
	25|ma|massachusetts \
	26|mi|michigan \
	27|mn|minnesota \
	28|ms|mississippi \
	29|mo|missouri \
	30|mt|montana \
	31|ne|nebraska \
	32|nv|nevada \
	33|nh|new_hampshire \
	34|nj|new_jersey \
	35|nm|new_mexico \
	36|ny|new_york \
	37|nc|north_carolina \
	38|nd|north_dakota \
	39|oh|ohio \
	40|ok|oklahoma \
	41|or|oregon \
	42|pa|pennsylvania \
	44|ri|rhode_island \
	45|sc|south_carolina \
	46|sd|south_dakota \
	47|tn|tennessee \
	48|tx|texas \
	49|ut|utah \
	50|vt|vermont \
	51|va|virginia \
	53|wa|washington \
	54|wv|west_virginia \
	55|wi|wisconsin \
	56|wy|wyoming

################################################################################
# MAKE TARGET GENERATION
################################################################################
# Produces multiple targets for each state.
# data/json/states/oregon.json - geojson of state outlines
# data/shp/places
define STATE_TARGETS_TEMPLATE
data/json/states/$(word 3,$(subst |, ,$(state))).json: data/shp/states.shp
	mkdir -p data/json/states
	shp2json -n data/shp/states.shp | ndjson-filter "d.properties.STATEFP == $(word 1,$(subst |, ,$(state)))" \
		> data/json/states/$(word 3,$(subst |, ,$(state))).json

data/shp/$(word 3,$(subst |, ,$(state)))_places.shp: data/gz/census/cb_2015_$(word 1,$(subst |, ,$(state)))_place_500k.zip
endef

$(foreach state,$(STATE_FIPS),$(eval $(STATE_TARGETS_TEMPLATE)))

################################################################################
# Final products
################################################################################
data/png/states/%.png: data/tif/states/%.tif
	mkdir -p $(dir $@)
	gdaldem hillshade $< $@ \
		-z 10.0 -s 1.0 -az 315.0 -alt 45.0 \
		-compute_edges \
		-combined \
		-of PNG

	pngquant --strip --verbose --force --quality 25 $@

################################################################################
# Intermediate products
################################################################################
.SECONDARY:
data/shp/states.shp: data/gz/census/cb_2015_us_state_500k.zip

data/img/states/%.img: data/json/states/%.json
	mkdir -p $(dir $@)
	bash script/generate-seamless-img $@ $< low $(BUFFER)

data/tif/states/%.tif: data/json/states/%.json data/img/states/%.img
	mkdir -p $(dir $@)
	gdalwarp \
	  -t_srs $(SRS) \
		-of GTiff \
		-co COMPRESS=DEFLATE \
		-dstalpha \
		-srcnodata -99999 \
		-dstnodata -99999 \
		-wo NUM_THREADS=ALL_CPUS \
		-multi \
		-ts $(WIDTH) $(HEIGHT) \
		-cutline $(word 1,$^) \
		-crop_to_cutline \
		-r lanczos \
		$(word 2,$^) \
		$@

#############################################################################################
# Wildcard																																									#
# ###########################################################################################

# High Resolution USGS National Elevation Dataset at 1/3 arc-second.
data/gz/usgs/dem/high/%.zip:
	mkdir -p $(dir $@)
	curl --remote-time 'https://prd-tnm.s3.amazonaws.com/StagedProducts/Elevation/13/IMG/$(notdir $@)' -o $@.download
	mv $@.download $@

# Standard Resolution USGS National Elevation Dataset at 1 arc-second
data/gz/usgs/dem/low/%.zip:
	mkdir -p $(dir $@)
	curl --remote-time 'https://prd-tnm.s3.amazonaws.com/StagedProducts/Elevation/1/IMG/$(notdir $@)' -o $@.download
	mv $@.download $@

# Extract standard resolution (1 arc-second) DEM grid tile
data/img/usgs/dem/low/%.img: data/gz/usgs/dem/low/%.zip
	mkdir -p $(basename $<)
	tar -xzm -C $(basename $<) -f $<
	mv $(basename $<)/img$(notdir $(basename $@))_1.img $@
	rm -rf $(basename $<)

# USGS small-scale data catalog
data/gz/census/%.zip:
	mkdir -p $(dir $@)
	curl --remote-time 'http://www2.census.gov/geo/tiger/GENZ2015/shp/$(notdir $@)' -o $@.download
	mv $@.download $@

data/shp/%.shp:
	rm -rf $(basename $@)
	mkdir -p $(basename $@)
	tar --exclude="._*" -xzm -C $(basename $@) -f $<

	for file in `find $(basename $@) -name '*.shp'`; do \
		ogr2ogr -t_srs 'EPSG:4326' $(basename $@).$${file##*.} $$file; \
	done
	rm -rf $(basename $@)

#############################################################################################
# Utility																																									#
# ###########################################################################################
.PHONY:
clean/state/%:
	rm data/png/states/$(notdir $@).png
	rm data/tif/states/$(notdir $@).tif
