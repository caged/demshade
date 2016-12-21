.SECONDARY:

data/shp/states.shp: data/gz/usgs/ss/statesp010g.shp_nt00938.tar.gz


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
