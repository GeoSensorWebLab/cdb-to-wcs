# CDB Testbed 13 Script

Reads a CDB for coverages, mosaics them into temporary files, imports them into GeoServer, and sets up a WCS.

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

### cdb-verify

    $ ruby -Ilib bin/cdb-verify path/to/CDB

Checks that the CDB has a Tiles directory.

### geoserver-setup

    $ ruby -Ilib bin/geoserver-setup path/to/CDB_temp/final http://user:password@geoserver:port/geoserver

Logs into GeoServer, creates a new workspace, creates a coverage store for every raster in the final directory, then creates coverage layers for each raster. If there is an error, it quits and prints an error message. Will delete the workspace if import fails.

## License

Copyright GeoServerWeb Lab 2017, All Rights Reserved.

## Authors

James Badger
