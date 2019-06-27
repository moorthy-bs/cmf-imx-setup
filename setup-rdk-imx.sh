#!/bin/bash -e

echo "Setting up workspace for RDK CMF i.MX8MQ build"
echo ""

if [ -z "$build_dir" ];then
    build_dir=$PWD/rdkcmf
    echo "Set build directory to $build_dir"
fi

if [ -z "$BASEDIR" ];then
    BASEDIR=`readlink -f $BASH_SOURCE | xargs dirname`
    echo "Set BASEDIR to $BASEDIR"
fi
echo ""

manifest_dir="thud-local-manifest"
if [ ! -d $BASEDIR/$manifest_dir ]; then
    mkdir -p $BASEDIR/$manifest_dir
    git clone https://github.com/moorthy-bs/rdkcmf-manifests $manifest_dir
else
    cd $manifest_dir
    git pull
fi

cd $BASEDIR

if [ ! -d "$build_dir" ]; then
    # Create a build directory if not exist.
    mkdir $build_dir
    cd $build_dir

    repo init -u https://code.rdkcentral.com/r/manifests -b rdk-next -m rdkv-asp-nosrc.xml
    if [ $? != 0 ]; then
        echo ""
        echo " *** repo init failure *** "
        echo ""
    fi

    #to switch oe layers to thud add local manifests
    local_manifests=".repo/local_manifests"
    mkdir -p $build_dir/$local_manifests
    echo "copying cmf-thud-freescale manifest to local manifests dir"
    cp $BASEDIR/$manifest_dir/cmf-thud-freescale.xml $build_dir/$local_manifests
fi

cd $build_dir

repo sync -j `nproc` -c --no-clone-bundle
if [ $? != 0 ]; then
    echo ""
    echo " *** repo sync failure *** "
    echo ""
fi

#$BASEDIR/apply-patches.sh $build_dir/meta-cmf-freescale/patches $build_dir

# unset variables
unset build_dir
unset BASEDIR

echo "RDK-CMF Yocto source is ready for the build"
