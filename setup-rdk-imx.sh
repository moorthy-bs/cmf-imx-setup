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

    repo init -u https://code.rdkcentral.com/r/manifests -b thud -m rdkv-nosrc.xml
    if [ $? != 0 ]; then
        echo ""
        echo " *** repo init failure *** "
        echo ""
    else
        echo "RDK CMF manifest initialized"
    fi
fi

cd $BASEDIR

#to switch oe layers to thud add local manifests
local_manifests=".repo/local_manifests"
mkdir -p $build_dir/$local_manifests
echo "copying cmf-thud-freescale manifest to local manifests dir"
cp $BASEDIR/$manifest_dir/cmf-thud-freescale.xml $build_dir/$local_manifests
cp $BASEDIR/$manifest_dir/imx8-rdk-revisions.conf $build_dir/revisions.conf
cd $build_dir

repo sync -j `nproc` -c --no-clone-bundle
if [ $? != 0 ]; then
    echo ""
    echo " *** repo sync failure *** "
    echo ""
else
    echo "repo sync done"
fi

################################
####### apply patches ##########
################################
echo "applying patches..."

cd meta-cmf-freescale
git fetch "https://code.rdkcentral.com/r/components/generic/rdk-oe/meta-cmf-freescale" refs/changes/17/26517/23 && git cherry-pick FETCH_HEAD
if [ $? -eq 0 ]; then
    ./apply-patches.sh $PWD/patches $build_dir
fi
cd ..

####################################
cd $build_dir
echo "RDK-CMF Yocto source is ready for the build"

# unset variables
unset build_dir
unset BASEDIR
