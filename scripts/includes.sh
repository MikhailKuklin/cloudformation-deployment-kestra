#!/usr/bin/env bash
setup() {
    check_args $@
    set_vars $@
}

check_args() {
    if [[ $# -lt 1 ]]; then
        usage
    fi

    if [[ ! "$1" =~ ^(dev|stag|prod)$ ]]; then
        usage
    fi
}

set_vars() {
    env=$1
    stack_name=infra-kestra
    cloudformation_s3_prefix=data-onboarding/${stack_name}

    template_path=./infrastructure/cloudformation/resources.yaml
    template_output_path=./infrastructure/cloudformation/dist/resources.yaml
    parameter_values_path=./infrastructure/cloudformation/parameters/dev.yaml

    aws_account_id=$(aws sts get-caller-identity --output text --query Account)
    aws_region=eu-west-1

    case "${env}" in
        dev ) environment="development" ;;
        stag ) environment="staging" ;;
        prod ) environment="production" ;;
    esac
}

usage() {
    echo "Usage: $0 <ENV>"
    echo "Where ENV must be one of (dev|stag|prod)"
    exit 1
}

cloudformation_package() {
    mkdir -p ./infrastructure/cloudformation/dist
    aws cloudformation package \
        --template-file "$1" \
        --output-template-file "$2" \
        --s3-bucket "${env}-configuration" \
        --s3-prefix "${cloudformation_s3_prefix}"
}

cleanup() {
    rm -rf ./infrastructure/cloudformation/dist/
}
