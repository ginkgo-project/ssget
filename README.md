SSGet
-----

This is a command line version of the SSGet tool for working with matrices from
the Suite Sparse collection ([sparse.tamu.edu](sparse.tamu.edu)).

Dependencies
------------

Standard UNIX tools:

*   bash
*   curl
*   tar (only for `-e` option with `-t MM` or `-t RB`)
*   make (only for installation)


Installation
------------

```sh
git clone https://github.com/ginkgo-project/ssget.git
cd ssget
sudo make install
```

Or a one-liner that doesn't create a local copy of the repository:

```sh
sudo curl -Lo /usr/local/bin/ssget https://raw.githubusercontent.com/ginkgo-project/ssget/master/ssget
```

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
    -s           search database with conditions. It uses @PROPERTY as the
                 placeholder

Calling ssget without arguments is equivalent to: ssget -i 0 -t MM -v
```

Examples
--------


### Example 1

Return properties of all matrices as a JSON array:

```sh
NUM_PROBLEMS=$(ssget -n)

echo "["
for (( i=1; i <= ${NUM_PROBLEMS}; ++i )); do
    ssget -i $i -j
    echo ","
done
echo "]"
```


### Example 2

Download matrix arhives for the entire collection, and print the size:

```sh
NUM_PROBLEMS=$(ssget -n)

TOTAL_SIZE=0

for (( i=1; i <= ${NUM_PROBLEMS}; ++i )); do
    # ssget -i $i -j
    ARCHIVE=$(ssget -i $i -f)
    SIZE=($(du -k ${ARCHIVE}))
    echo "${ARCHIVE}: ${SIZE}KB"
    TOTAL_SIZE=$((${TOTAL_SIZE} + ${SIZE}))
done

echo "Total: ${TOTAL_SIZE}KB"
```

__NOTE:__ This will transfer and store a huge amount of data!


### Example 3
Extract (and download if needed) the matrix with ID=10, pass its location to
the program `foo` and delete the extracted files (but keep the archive)
afterwards:

```sh
foo $(ssget -ei10)
ssget -ci10
```

### Example 4
Delete the archive for matrix with ID=10

```sh
ssget -ri10
```

### Example 5
Search the database with `400 <= #rows <= 450` and
`numerical symmertry >= 0.99`

```sh
./ssget -s '[ @rows -ge 400 ] && [ @rows -le 450 ] && [ $(awk "BEGIN{print(@nsym <= 0.99)}") -eq 1 ]'
```

License
-------
BSD 3-clause

