.SECONDARY:

# http://www.naturalearthdata.com/http//www.naturalearthdata.com/download/10m/raster/HYP_HR_SR_OB_DR.zip

# https://prd-tnm.s3.amazonaws.com/StagedProducts/Elevation/1/IMG/n46w124.zip

data/shp/states.shp: data/gz/usgs/ss/statesp010g.shp_nt00938.tar.gz
data/shp/oregon.shp: data/shp/states.shp
	ogr2ogr $@ $< -where 'NAME="Oregon"'

# USGS National Elevation Dataset 1/3 arc-second
data/gz/usgs/13/%.zip:
	mkdir -p $(dir $@)
	curl --remote-time 'https://prd-tnm.s3.amazonaws.com/StagedProducts/Elevation/13/IMG/$(notdir $@)' -o $@.download
	mv $@.download $@

# USGS National Elevation Dataset 1 arc-second
data/gz/usgs/1/%.zip:
	mkdir -p $(dir $@)
	curl --remote-time 'https://prd-tnm.s3.amazonaws.com/StagedProducts/Elevation/1/IMG/$(notdir $@)' -o $@.download
	mv $@.download $@

data/gz/usgs/ss/%.gz:
	mkdir -p $(dir $@)
	curl --remote-time 'https://prd-tnm.s3.amazonaws.com/StagedProducts/Small-scale/data/Boundaries/$(notdir $@)' -o $@.download
	mv $@.download $@


data/png/1/n46w124-debug.png: data/gz/usgs/1/n46w124.zip script/hillshade
	rm -rf $(basename $@)
	mkdir -p $(basename $@)

	tar -xzm -C $(basename $@) -f $<
	script/hillshade $< $@

data/png/1/n46w124.png: data/gz/usgs/1/n46w124.zip
	rm -rf $(basename $@)
	mkdir -p $(basename $@)

	tar -xzm -C $(basename $@) -f $<

	gdalwarp \
		-overwrite \
		-s_srs EPSG:4269 \
		-t_srs EPSG:2913 \
		-of GTiff \
		$(basename $@)/imgn46w124_1.img \
		$@.tif

	gdaldem hillshade \
		$@.tif $@ \
		-z 10.0 -s 1.0 -az 315.0 -alt 45.0 \
		-compute_edges \
		-of PNG

	# pngnq -f -n 256 -s 10 -Q f -e ".png" $@
	# pngquant --quality 25
	rm $@.tif
	rm $@.aux.xml
	rm -rf $(basename $@)

data/shp/%.shp:
	rm -rf $(basename $@)
	mkdir -p $(basename $@)
	tar --exclude="._*" -xzm -C $(basename $@) -f $<

	for file in `find $(basename $@) -name '*.shp'`; do \
		ogr2ogr $(basename $@).$${file##*.} $$file; \
	done
	rm -rf $(basename $@)
