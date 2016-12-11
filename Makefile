.SECONDARY:

data/gdb/ogdc_v6.gdb: data/gz/oregon-ogdc6.zip
	mkdir -p $(dir $@)
	tar -xzm -C $(dir $@) -f $<
	rm -rf gdb/__MACOSX
	mv data/gdb/OGDC_v6.gdb $@

data/gz/oregon-ogdc6.zip:
	mkdir -p $(dir $@)
	curl --remote-time 'http://www.oregongeology.org/pubs/dds/ogdc/OGDC-6.zip' -o $@.download
	mv $@.download $@
