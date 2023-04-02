#!/bin/bash

echo "###################################"
echo "# Start post-build.sh"
echo "###################################"

set -x
set -e
cp ${BR2_EXTERNAL_DE10_NANO_PATH}/fabric_rbf/de10-nano.rbf ${BR2_EXTERNAL_DE10_NANO_PATH}/images/de10-nano.rbf