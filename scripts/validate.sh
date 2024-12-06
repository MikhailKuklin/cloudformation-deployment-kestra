#!/usr/bin/env bash

set -eux
cd $(dirname $0)/..
source ./scripts/includes.sh
setup $@

cfn-lint -t $template_path --ignore-checks W E1021