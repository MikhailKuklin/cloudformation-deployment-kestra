#!/usr/bin/env bash

set -eux
cd $(dirname $0)/..
source ./scripts/includes.sh
setup $@

cloudformation_package ${template_path} ${template_output_path}

aws cloudformation deploy \
    --stack-name ${stack_name} \
    --template-file ${template_output_path} \
    --parameter-overrides $(yq -r 'to_entries | .[] | "\(.key)=\(.value)"' ${parameter_values_path}) \
    --no-fail-on-empty-changeset \
    --capabilities CAPABILITY_NAMED_IAM \
    --tags \
    environment="${environment}" \
    component="${stack_name}" \