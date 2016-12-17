.SECONDARY:

# http://www.naturalearthdata.com/http//www.naturalearthdata.com/download/10m/raster/HYP_HR_SR_OB_DR.zip

https://prd-tnm.s3.amazonaws.com/StagedProducts/Elevation/1/IMG/n46w124.zip

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

data/png/1/n46w124.png: data/gz/usgs/1/n46w124.zip script/hillshade
	rm -rf $(basename $@)
	mkdir -p $(basename $@)
	script/hillshade $@ $(word 3,$^)	

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

	pngnq -f -n 256 -s 10 -Q f -e ".png" $@
	rm $@.tif
	rm $@.aux.xml
	rm -rf $(basename $@)

# https://prd-tnm.s3.amazonaws.com/StagedProducts/Elevation/13/IMG/n46w124.zip
# data/gdb/ogdc_v6.gdb: data/gz/oregon-ogdc6.zip
# 	mkdir -p $(dir $@)
# 	tar -xzm -C $(dir $@) -f $<
# 	rm -rf gdb/__MACOSX
# 	mv data/gdb/OGDC_v6.gdb $@
#
# data/gz/oregon-ogdc6.zip:
# 	mkdir -p $(dir $@)
# 	curl --remote-time 'http://www.oregongeology.org/pubs/dds/ogdc/OGDC-6.zip' -o $@.download
# 	mv $@.download $@
