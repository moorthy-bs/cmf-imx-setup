
# Setup RDK CMF build for i.MX platform

## Prerequisite setup

If prerequisite setup required, run below setup
~~~~
./setup-prerequisite.sh
~~~~

## Setup RDK-M CMF repositories

Setup RDK CMF repositories.
Follow below sequences to setup build environment. If required, patches also can be applied
~~~~
./setup-rdk-imx.sh
./apply-patches.sh $PWD/rdkcmf/meta-cmf-freescale/patches rdkcmf
~~~~

### RDK Media Client on i.MX8M

Select 'imx8mq-rdk-mc' MACHINE while setting up environment from meta-cmf-freescale
~~~~
source meta-cmf-freescale/setup-environment
bitbake rdk-generic-mediaclient-wpe-image
~~~~
