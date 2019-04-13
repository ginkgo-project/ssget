#!/usr/bin/env bash


# Test if required commands are present on the system:
command -v awk &> /dev/null
if [ ${?} -ne 0 ]; then
    echo 'The command `awk` is required for this script to work, but not supported by your system.' 1>&2
    exit 1
fi


OPT=""
VAL=""
# `get_opt_and_val` seperate a string to OPT and VAL
# Usage: get_opt_and_val string
get_opt_and_val() {
    local line=$1
    IFS=":" read -ra TEMP <<< "${line}"
    OPT="${TEMP[0]}"
    VAL="${TEMP[1]}"
}


COMMANDS=""
# `get_min_and_max` to generate the command for min <= OPT <= max integer version
# Usage: get_min_and_max placeholder val
# placeholder: @property for ssget.
# val: min,max
get_min_and_max() {
    local placeholder="$1"
    local val="$2"
    IFS="," read -ra TEMP <<< "${val}"
    local min="${TEMP[0]/ /}"
    local max="${TEMP[1]/ /}"
    if [ "${min}" != "" ]; then
        COMMANDS="${COMMANDS} && [ ${placeholder} -ge ${min} ]"
    fi
    if [ "${max}" != "" ]; then
        COMMANDS="${COMMANDS} && [ ${placeholder} -le ${max} ]"
    fi
}


# `get_min_and_max_float` to generate the command for min <= OPT <= max floating version
# Usage: get_min_and_max_float placeholder val
# placeholder: @property for ssget.
# val: min,max
get_min_and_max_float() {
    local placeholder="$1"
    local val="$2"
    IFS="," read -ra TEMP <<< "${val}"
    local min="${TEMP[0]/ /}"
    local max="${TEMP[1]/ /}"
    if [ "${min}" != "" ]; then
        COMMANDS="${COMMANDS} && [ \$(awk \"BEGIN{print(${placeholder} >= ${min})}\") -eq 1 ]"
    fi
    if [ "${max}" != "" ]; then
        COMMANDS="${COMMANDS} && [ \$(awk \"BEGIN{print(${placeholder} <= ${max})}\") -eq 1 ]"
    fi
}


# `process_rbtype_command` to generate the command for selecting a rbtype
# Usage: process_rbtype_command Rutherford-BoeingType
# Rutherford-BoeingType: Real, Complex, Bool, Any
process_rbtype_command() {
    local val="$1"
    case ${val} in
        Real)
            COMMANDS="${COMMANDS} && [[ @real == \"true\" ]] && [[ @binary == \"false\" ]]"
            ;;
        Complex)
            COMMANDS="${COMMANDS} && [[ @real == \"false\" ]]"
            ;;
        Bool)
            COMMANDS="${COMMANDS} && [[ @binary == \"true\" ]]"
            ;;
        Any)
            ;;
        *) 
            >&2 echo "Not support ${val} in Rutherford-Boeing Type"
            exit 3
            ;;
    esac
}


# `process_structure_command` to generate the command for selecting a structure
# Usage: process_structure_command SpecialStructure
# SpecialStructure: Square, Rectangle, Symmetric, Unsymmetric, Hermitian, Any
process_structure_command() {
    local val="$1"
    case ${val} in
        Square)
            COMMANDS="${COMMANDS} && [[ @rows == @cols ]]"
            ;;
        Rectangle)
            COMMANDS="${COMMANDS} && [[ @rows != @cols ]]"
            ;;
        Symmetric)
            COMMANDS="${COMMANDS} && [[ @real == true ]] && [[ @rows == @cols ]] && [[ @nsym == 1 ]]"
            ;;
        Unsymmetric)
            COMMANDS="${COMMANDS} && [[ @rows == @cols ]] && [[ @nsym != 1 ]]"
            ;;
        Hermitian)
            COMMANDS="${COMMANDS} && [[ @real == false ]] && [[ @rows == @cols ]] && [[ @nsym == 1 ]]"
            ;;
        Any)
            ;;
        *)
            >&2 echo "Not support ${val} in Special Structure"
            exit 4
            ;;
    esac
}


# Main script
# Usage: ./build_from_config.sh configfile
while IFS='' read -r LINE; do
    # Ignore the line containing // at the beginning  or only spaces.
    if [[ ! "$LINE" =~ ^\/\/.*$ ]] && [ ${LINE} ]; then
        get_opt_and_val "${LINE}"
        case ${OPT} in
            Rows)
                get_min_and_max "@rows" "${VAL}"
                ;;
            Columns)
                get_min_and_max "@cols" "${VAL}"
                ;;
            Nonzeros)
                get_min_and_max "@nonzeros" "${VAL}"
                ;;
            PatternSymmetry)
                get_min_and_max_float "@psym" "${VAL}"
                ;;
            NumericalSymmetry)
                get_min_and_max_float "@nsym" "${VAL}"
                ;;
            MatrixName)
                TEMP="[[ \$(echo \"@name\" | grep -i \"${VAL}\") != \"\" ]]"
                COMMANDS="${COMMANDS} && ${TEMP}"
                ;;
            GroupName)
                TEMP="[[ \$(echo \"@group\" | grep -i \"${VAL}\") != \"\" ]]"
                COMMANDS="${COMMANDS} && ${TEMP}"
                ;;
            Kind)
                TEMP="[[ \$(echo \"@kind\" | grep -i \"${VAL}\") != \"\" ]]"
                COMMANDS="${COMMANDS} && ${TEMP}"
                ;;
            Keyword)
                TEMP="[[ \$(echo \"@name\" | grep -i \"${VAL}\") != \"\" ]]"
                TEMP+=" || "
                TEMP+="[[ \$(echo \"@group\" | grep -i \"${VAL}\") != \"\" ]]"
                TEMP+=" || "
                TEMP+="[[ \$(echo \"@kind\" | grep -i \"${VAL}\") != \"\" ]]"
                COMMANDS="${COMMANDS} && (${TEMP})"
                ;;
            PositiveDefinite)
                COMMANDS="${COMMANDS} && [[ @posdef == ${VAL} ]]"
                ;;
            Rutherford-BoeingType) 
                process_rbtype_command "${VAL}"
                ;;
            SpecialStructure)
                process_structure_command "${VAL}"
                ;;
            *)
                >&2 echo "Not support the unknown option ${OPT}"
                exit 2
                ;;
        esac
    fi
done < "$1"
echo ${COMMANDS:3}
