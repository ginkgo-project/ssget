BuildFromConfig
---------------

It try to allow the same options as the filters on
([sparse.tamu.edu](sparse.tamu.edu)).


Usage
-----

`./build_from_config.md configfile`

The output is the searching command. `./ssget -s 'output'`

In `configfile`, it allows use the `//` to mark the comments
`OPT_NAME:VAL` for setting the option value

`No` means `Not_Implement`

- Keyword:string
- Rows:min,max
- Columns:min,max
- Nonzeros:min,max
- PatternSymmetry:min,max
- NumericalSymmetry:min,max
- `NO`|Strongly Connected Components
- Rutherford-BoeingType:OPTION
    - Real : is real but not binary
    - Complex : is not real
    - `NO`|Integer
    - Binary : is binary
- SpecialStructure:OPTION
    - Square : rows == cols
    - Rectangle : rows != cols
    - Symmetric : Square, RealValue (including binary), nsym == 1
    - Unsymmetric : Square, nsym != 1
    - Hermitian : Square, ComplexValue, nsym ==1
    - `NO`|Skew-Symmetric
- PositiveDefinite:true or false
- MatrixName:string
- GroupName:string
- Kind:string
- `NO`|Matrix ID
- `NO`|Year


Detail
------

For the `OPT:min,max`, it allows only `min` or `max` with keeping `,`
`OPT:,max` means the condition `OPT<=max`

For the `OPT:OPTION`, it only allows one option now.


Difference from ([sparse.tamu.edu](sparse.tamu.edu))
----------------------------------------------------

- Some Not_Implement options or settings
- Keyword: verify whether `kind`, `groupname`, `matrixname` contain the
    `keyword` (it is case insensitive)
- Symmetric:
    [sparse.tamu.edu](sparse.tamu.edu) can verify the complex symmetric
    (A == A.T), but this program can not.


Example
-------
example in ssget: `400 <= #rows <= 450 and numerical symmertry >= 0.99`
```
// Filename config
Rows:400,450
NumericalSymmetry:,0.99
```
the output of `./build_from_config config` is
`[ @rows -ge 400 ] && [ @rows -le 450 ] && [ $(echo "@nsym <= 0.99" | bc) -eq 1 ]`


```
// Filename config
Rows:200,
Columns:,300
Nonzeros:1000,
SpecialStructure:Symmetric
PositiveDefinite:true
```
output is `[ @rows -ge 200 ] && [ @cols -le 300 ] && [ @nonzeros -ge 1000 ] && [[ @real == true ]] && [[ @rows == @cols ]] && [[ @nsym == 1 ]] && [[ @posdef == true ]]`



