# CDB Testbed 13 Script

Reads a CDB for coverages, mosaics them into temporary files, imports them into GeoServer, and sets up a WCS.

I recommend using [QGIS](http://qgis.org/en/site/) as a testing client to preview rasters generated with `cdb-mosaic`, and to preview rasters from the GeoServer WCS.

## Usage

### cdb-addo

Uses GDAL to add overviews to GeoTIFFs in given directory. Run this after `cdb-mosaic`.

    $ ruby -Ilib bin/cdb-addo path/to/CDB_temp/final

Overviews will make the GeoTIFFs load faster in GeoServer WCS.

### cdb-list-components

    $ ruby -Ilib bin/cdb-list-components path/to/CDB

List datasets in a CDB, grouped by component selectors. Counts the files found for each component selector.

### cdb-list-datasets

    $ ruby -Ilib bin/cdb-list-datasets path/to/CDB

List datasets in a CDB, grouped by geocells. Counts the GeoTIFFs and JP2s found.

### cdb-list-geocells

    $ ruby -Ilib bin/cdb-list-geocells path/to/CDB

List geocells in a CDB, and the sub-collections for each geocell.

### cdb-mosaic

    $ ruby -Ilib bin/cdb-mosaic path/to/CDB

Creates a new directory at `path/to/CDB_temp` and scans the coverages in the CDB and merges them using `gdal_merge.py`. First merges in UREFs under the highest LODs, then merges UREFs, then merges GeoCells to leave datasets. Different component selectors are merged separately. All output files are GeoTIFFs.

Output GeoTIFFs will have overviews added using GDAL. Lossy rasters will have JPEG overviews, lossless rasters will have LZW compressed overviews.

### cdb-mosaic-vrt (Experimental)

    $ ruby -Ilib bin/cdb-mosaic-vrt path/to/CDB

Creates a new directory at `path/to/CDB_temp` and scans the coverages in the CDB and merges them using virtual datasets (VRTs). Files are selected from `001_Elevation` and `004_Imagery` under the highest LODs, then grouped by Component Selectors, GeoCells, and then UREFs. They are then combined into VRTs in the reverse order.

All output files are VRTs. Very fast, but compatibility may be limited.

### cdb-verify

    $ ruby -Ilib bin/cdb-verify path/to/CDB

Checks that the CDB has a Tiles directory.

### geoserver-setup

    $ ruby -Ilib bin/geoserver-setup path/to/CDB_temp/final http://user:password@geoserver:port/geoserver

Logs into GeoServer, creates a new workspace, creates a coverage store for every raster in the final directory, then creates coverage layers for each raster. If there is an error, it quits and prints an error message. Will delete the workspace if import fails.

Set the environment variable `HTTPS` to `false` to disable HTTPS connections to GeoServer during configuration.

### geoserver-setup-vrts (Experimental)

    $ ruby -Ilib bin/geoserver-setup-vrts path/to/CDB_temp/final http://user:password@geoserver:port/geoserver

Logs into GeoServer, creates a new workspace, creates a coverage store for every VRT in the "final" directory, then creates coverage layers for each raster. If there is an error, it quits and prints an error message. Will delete the workspace if import fails.

Set the environment variable `HTTPS` to `false` to disable HTTPS connections to GeoServer during configuration.

GeoServer **requires** the [GDAL plugin](http://geoserver.org/release/stable/) for VRTs to work! For installation instructions on Linux and Windows, see the [GeoServer Docs](http://docs.geoserver.org/latest/en/user/data/raster/gdal.html). For MacOS installation, see [this GeoServer mailing list post](https://sourceforge.net/p/geoserver/mailman/message/35747192/). (I put a copy of that post in the `docs` directory if sourceforge is unavailable.)

For Mac it is also important to edit `/usr/local/bin/geoserver` that was installed by Mac Homebrew, and change to:

```shell
#!/bin/sh
export PATH="/usr/local/opt/gdal2/bin:$PATH"
export GDAL_DATA=/usr/local/Cellar/gdal2/2.2.0/share/gdal
export DYLD_LIBRARY_PATH="/usr/local/lib"
export LD_LIBRARY_PATH="/usr/local/lib"

if [ -z "$1" ]; then
  echo "Usage: $ geoserver path/to/data/dir"
else
  cd "/usr/local/Cellar/geoserver/2.11.1/libexec" && java -Djava.library.path=/usr/local/lib/ -DGEOSERVER_DATA_DIR=$1 -jar start.jar
fi
```

This makes sure the GDAL libraries are loaded by GeoServer. The log output from GeoServer _will_ specify if GDAL loaded properly or not.

## License

Copyright GeoServerWeb Lab 2017, All Rights Reserved.

## Authors

James Badger
