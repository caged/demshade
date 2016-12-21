.SECONDARY:

data/shp/states.shp: data/gz/census/cb_2015_us_state_500k.zip
data/shp/ua.shp: data/gz/census/cb_2015_us_state_500k.zip

data/shp/oregon.png: data/json/oregon.json
	
#############################################################################################
# Wildcard																																									#
# ###########################################################################################

# High Resolution USGS National Elevation Dataset at 1/3 arc-second.
data/gz/usgs/dem/third/%.zip:
	mkdir -p $(dir $@)
	curl --remote-time 'https://prd-tnm.s3.amazonaws.com/StagedProducts/Elevation/13/IMG/$(notdir $@)' -o $@.download
	mv $@.download $@

# Standard Resolution USGS National Elevation Dataset at 1 arc-second
data/gz/usgs/dem/one/%.zip:
	mkdir -p $(dir $@)
	curl --remote-time 'https://prd-tnm.s3.amazonaws.com/StagedProducts/Elevation/1/IMG/$(notdir $@)' -o $@.download
	mv $@.download $@

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
