#!bin/bash

if [[ $# -ne 2 ]] ; then
    echo 'Invalid arguments. cf.sh <vpc|db> <up|down>'
    exit 1
fi

PWD="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
SCRIPT=`echo $1 | tr '[:upper:]' '[:lower:]'`
STATE=`echo $2 | tr '[:upper:]' '[:lower:]'`


if [[ $SCRIPT == 'vpc' ]]; then
    if [[ $STATE == 'up' ]]; then
        aws cloudformation deploy \
        --template-file $PWD/network/vpc.yaml \
        --stack-name leroy-vpc-stack \
        --parameter-overrides \
        Environment="Dev" \
        ResourcePrefix="leroy" \
        NATKeyName="LeroyEC2Key" \
        CreateBastion="False" \
        --capabilities CAPABILITY_NAMED_IAM \
        --tags \
        Environment="Dev" \
        Region="sg" \
        Owner="Leroy"
    elif [[ $STATE == 'down' ]]; then
        aws cloudformation delete-stack \
        --stack-name leroy-vpc-stack
    else
        echo "<$2> is not supported. Please enter either <up|down>"
        exit 1
    fi
else
    echo "<$1> is not supported. Please enter a valid argument"
    exit 1
fi