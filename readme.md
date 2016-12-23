![](/static/preview.png)

``` shell
# Boostrap
./script/setup
```

``` shell
make data/png/states/oregon.png

# Set the SRS for the output PNG
SRS='EPSG:2913' make data/png/states/oregon.png

# Set the WIDTH of the output image.  Height is dynamic.
WIDTH=5000 make data/png/states/oregon.png

# Set the HEIGHT of the output image and allow width to be dynamic
WIDTH=0 HEIGHT=5000 make data/png/states/oregon.png

# Cut the resulting png around the state borders and crop the image to those boundaries
# e.g. make a state cutout of oregon
SRS='EPSG:2913' CROP_AND_CUT=yes make data/png/states/oregon.png
```

If you want to regenerate a PNG in a different projection or size, you will need to clean the related tif file beforehand.
