BuildFromConfig
---------------

The tool BuildFromConfig builds from a configuration file the searching command 
to be passed to the command ssget -s.
This tries to allow the same options as the filters on 
([sparse.tamu.edu](sparse.tamu.edu)).


Usage
-----

`./build_from_config.sh configfile`


### Syntax
This section describes the syntax of the input file `configfile`.

- `OPT_NAME:VAL` for setting the option value
- `//` can be used to mark comments.


### Accepted Configuration
This section describes the detail of the accepted configuration options and 
values.

- Keyword:string
- Rows:min,max
- Columns:min,max
- Nonzeros:min,max
- PatternSymmetry:min,max
- NumericalSymmetry:min,max
- `Not_Implemented` - Strongly Connected Components
- Rutherford-BoeingType:OPTION
    - Real : is real but not binary
    - Complex : is not real
    - `Not_Implemented` - Integer
    - Binary : is binary
    - Any
- SpecialStructure:OPTION
    - Square : rows == cols
    - Rectangle : rows != cols
    - Symmetric : Square, RealValue (including binary), nsym == 1
    - Unsymmetric : Square, nsym != 1
    - Hermitian : Square, ComplexValue, nsym == 1
    - `Not_Implemented` - Skew-Symmetric
    - Any
- PositiveDefinite:true or false
- MatrixName:string
- GroupName:string
- Kind:string
- `Not_Implemented` - Matrix ID
- `Not_Implemented` - Year

For the `OPT:min,max`, it allows only `min` or `max` with keeping `,`
`OPT:,max` means the condition `OPT <= max`

For options of the form `OPT:OPTION`, only one option can be specified for now.

For string of the form `OPT:string`, this runs a case-insensitive case search 
for `string` inside the `OPT`


### Difference from ([sparse.tamu.edu](sparse.tamu.edu))

- The options or settings marked as `Not_Implemented` block this script.
- Keyword: run a case-insensitive case search inside kind, group and name, but 
[sparse.tamu.edu](sparse.tamu.edu) runs a search inside group, name, kind, 
author, editor and notes.
- Symmetric:
    [sparse.tamu.edu](sparse.tamu.edu) can verify the complex symmetric
    (A == A.'), but this script can not.


Examples
-------

This section shows some configuration files and outputs.


### Example 1
example in ssget: `400 <= #rows <= 450 and numerical symmertry >= 0.99`
```
// Filename example1
Rows:400,450
NumericalSymmetry:,0.99
```
the output of `./build_from_config example1` is
`[ @rows -ge 400 ] && [ @rows -le 450 ] && [ $(awk "BEGIN{print(@nsym <= 0.99)}") -eq 1 ]`


### Example 2
```
// Filename example2
Rows:200,
Columns:,300
Nonzeros:1000,
SpecialStructure:Symmetric
PositiveDefinite:true
```
output is `[ @rows -ge 200 ] && [ @cols -le 300 ] && [ @nonzeros -ge 1000 ] && [[ @real == true ]] && [[ @rows == @cols ]] && [[ @nsym == 1 ]] && [[ @posdef == true ]]`
