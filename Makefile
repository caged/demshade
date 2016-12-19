.SECONDARY:

data/shp/states.shp: data/gz/usgs/ss/statesp010g.shp_nt00938.tar.gz

# Can't find this individual file, but it is embedded with every IMG file
data/shp/arc_reference.shp: data/gz/usgs/1/n46w124.zip
	rm -rf $(basename $@)
	mkdir -p $(basename $@)
	tar -xzm -C $(basename $@) -f $<
	ogr2ogr $@ data/shp/arc_reference/ned_1arcsec_g.shp

#############################################################################################
# Wildcard																																									#
# ###########################################################################################
data/png/%.png: script/generate
	# script/generate output.png state-name
	script/generate $@ $(notdir $(basename $@))

# # USGS National Elevation Dataset 1 arc-second
data/gz/usgs/%.zip:
	mkdir -p $(dir $@)
	curl --remote-time 'https://prd-tnm.s3.amazonaws.com/StagedProducts/Elevation/1/IMG/$(notdir $@)' -o $@.download
	mv $@.download $@

data/gz/usgs/ss/%.gz:
	mkdir -p $(dir $@)
	curl --remote-time 'https://prd-tnm.s3.amazonaws.com/StagedProducts/Small-scale/data/Boundaries/$(notdir $@)' -o $@.download
	mv $@.download $@

data/shp/%.shp:
	rm -rf $(basename $@)
	mkdir -p $(basename $@)
	tar --exclude="._*" -xzm -C $(basename $@) -f $<

	for file in `find $(basename $@) -name '*.shp'`; do \
		ogr2ogr -t_srs 'EPSG:4326' $(basename $@).$${file##*.} $$file; \
	done
	rm -rf $(basename $@)
