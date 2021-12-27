#!/usr/bin/env bash

function parse_ini() {

    # parse_ini < bin/dnb.ini                    # Show Sections
    # parse_ini 'default' < bin/dnb.ini          # Show Options with values
    # parse_ini 'default' 'option' < bin/dnb.ini # Show Option Value
    # parse_ini 'two' 'iam' < bin/dnb.ini        # Same as last but from another section

    # var=$(parse_ini 'two' 'iam' < bin/dnb.ini)
    # echo "${var}"

    # see https://stackoverflow.com/a/68960697/512174 for details

    # cat /dev/stdin | awk -v section="$1" -v key="$2" '
    < /dev/stdin awk -v section="$1" -v key="$2" '
    BEGIN {
    if (length(key) > 0) { params=2 }
    else if (length(section) > 0) { params=1 }
    else { params=0 }
    }
    match($0,/;/) { next }
    match($0,/#/) { next }
    match($0,/^\[(.+)\]$/){
    current=substr($0, RSTART+1, RLENGTH-2)
    found=current==section
    if (params==0) { print current }
    }
    match($0,/(.+)=(.+)/) {
    if (found) {
        if (params==2 && key==substr($1, 0, length(key))) { print substr($0, length(key)+2) }
        if (params==1) { printf "%s\n",$1,$3 }
    }
    }'
}
