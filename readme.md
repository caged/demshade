![](/static/preview.png)

``` shell
# Boostrap
./script/bootstrap
```

``` shell
make data/tif/states/oregon.tif

# Set the SRS for the output TIF
SRS='EPSG:2913' make data/tif/states/oregon.tif

# Set the WIDTH of the output image.  Height is dynamic.
WIDTH=5000 make data/tif/states/oregon.tif

# Set the HEIGHT of the output image and allow width to be dynamic
WIDTH=0 HEIGHT=5000 make data/tif/states/oregon.tif

# Cut the resulting tif around the state borders and crop the image to those boundaries
# e.g. make a state cutout of Oregon
SRS='EPSG:2913' CROP_AND_CUT=yes make data/tif/states/oregon.tif
```

If you want to regenerate a TIF in a different projection or size, you will need to delete the related tif file beforehand.
