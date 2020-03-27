#!/bin/bash -e

ROOT=$PWD
PATCHES=$ROOT/patches

if [ $# -lt 1 ]; then
    cat <<EOF
usage:  $0

        This scripts applies patches in appropriate folders

        $0 [patches dir] [root dir]

        [root dir] - if root directory not given, default to current directory

EOF
    exit 0
fi

if [ $# -gt 0 ]; then
    PATCHES=$1
    if [ $# -gt 1 ]; then
        ROOT=$2
    else
        echo ""
        echo "ROOT directory is default to current directory."
        echo ""
    fi
fi

for name in `find $PATCHES -name \*.patch | sort`; do
        DIR=$(dirname ${name#$PATCHES})
        echo ""
        echo "applying patches on $DIR"
        echo ""
        git -C "$ROOT"/"$DIR" am $name
done

for dir in `find $ROOT -name meta-* -type d -maxdepth 1`;
do
  find $dir -type f -exec sed -i 's/base_contains/bb.utils.contains/g' {} +
  find $dir -type f -exec sed -i 's/base_conditional/oe.utils.conditional/g' {} +
  find $dir -type f -exec sed -i 's/oe_filter_out/oe.utils.str_filter_out/g' {} +
done
