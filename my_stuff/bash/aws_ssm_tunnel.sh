#!/bin/bash
if [[ "$AWS_ACCESS_KEY_ID" == "" ]]; then
	echo "Set up your AWS_ACCESS_KEY_ID variable and try again"
	exit 1
fi

if [[ "$AWS_SECRET_ACCESS_KEY" == "" ]]; then
	echo "Set up your AWS_SECRET_ACCESS_KEY variable and try again"
	exit 1
fi

type jq
if [[ $? != 0 ]]; then
	echo Error: JQ required
	exit 1
fi

if [[ -f "$1" ]]; then
	jq -Mr "." < $1
	if [[ $? != 0 ]]; then
		echo Error: JSON config file broken
		exit 1
	fi
else
	echo Error: json configuration file as parameter required
	exit 1
fi

REGION=$( jq -Mr ".region" < $1 )
REMOTE_PORT=$( jq -Mr ".remoteport" <$1 )
BASTION_TAG=$( jq -Mr ".bastion_tag" < $1 )
BASTION_INSTANCE_ID=$( jq -Mr ".bastion_instance_id" < $1 )
DB_TAG=$( jq -Mr ".db_tag" < $1 )
DB_HOST=$( jq -Mr ".db_host" < $1 )

echo "TODO"
exit 0



read json file with config
region mandatory
remote port mandatory
if bastion tag key value exists, use it to find the instance id, otherwise check if instance id is hardcoded. else, fails
if instance tag key value exists, use it to set the DB host. otherwise check dbhost, else fails
if remote port is not present, read variable for local port notice remote port
then...

aws ssm start-session \
  --region eu-west-2 \
  --target i-fafafafafafafa \
  --document-name AWS-StartPortForwardingSessionToRemoteHost \
  --parameters host="${RDS_HOST}",portNumber="3306",localPortNumber="3306"

