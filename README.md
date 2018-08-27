SSGet
-----

This is a command line version of the SSGet tool for working with matrices from
the Suite Sparse collection ([sparse.tamu.edu](sparse.tamu.edu)).

Dependencies
------------

*   bash
*   curl
*   tar (for `-e` option with `-t MM` or `-t RB`)


Installation
------------

Copy the `ssget` script to your path.


Usage
-----

Run `ssget -h` to get a list of available options:

```
Usage: ssget [options]

Available options:
    -c           clean files extracted from archive
    -d           (re)download matrix info file
    -e           download matrix and extract archive
    -f           download matrix and get path to archive
    -h           show this help
    -i ID        matrix id
    -j           print information about the matrix in JSON format
    -n           get number of matrices in collection
    -p PROPERTY  print information about the matrix, PROPERTY is the propery to
                 print, one of group, name, rows, cols, nonzeros, real, binary,
                 2d3d, posdef, psym, nsym, kind
    -r           remove archive
    -t TYPE      matrix type, TYPE is one of: MM (matrix market, '.mtx'), RB
                 (Rutherford Boeing, '.rb'), mat (MATLAB, '.mat')
    -v           get database version

Calling ssget without arguments is equivalent to: ssget -i 0 -t MM -v
```

License
-------
BSD 3-clause
