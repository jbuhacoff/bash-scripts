#!/bin/bash

# usage: insert <path-var-name> <item> ...
# example: insert PATH /path/to/scripts
# output depends on initial value of the PATH variable, but if it was empty the output would 
# be just "/path/to/scripts", and if it had a value "/opt/scripts" the output would
# be "/opt/scripts:/path/to/scripts"
# description:
# we pass the path variable by name instead of by value because path variable values
# (especially when adding paths to script directories that are in user home directory
# hierarchies) can be long and easily exceed the allowed command line length.

edited_path=
path_name=
option_print=printvalue

# TODO: if the item is already in the list, remove it from the middle and insert it
# so the postcondition can be the item is always at the beginning of the list
insert_item() {
    local item="$1"
    if [ -z "$edited_path" ]; then
        edited_path="$item"
    else
        grep -q ":${item}:" <(echo ":${edited_path}:")
        if [ $? -ne 0 ]; then
            # TODO: if the item is already in the list, remove all instances before inserting
            # insert: new item at beginning of path
            edited_path="${item}:${edited_path}"
        fi
    fi
}

until [ $# -eq 0 ]
do
    case "$1" in
        --printenv)
            option_print="printenv"
            ;;
        *)
            if [ -z "$path_name" ]; then
                path_name="$1"
                edited_path="${!path_name}"
            else
                insert_item "$1"
            fi
            ;;
    esac
    shift
done

case "$option_print" in
    printvalue)
        echo "$edited_path"
        ;;
    printenv)
        echo "${path_name}=${edited_path}"
        ;;
    *)
        echo "error: invalid print option" >&2
        echo "$edited_path"
        ;;
esac
