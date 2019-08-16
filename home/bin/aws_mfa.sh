#!/bin/bash

echo -n "Enter one-time AWS token from 1Password: "
read TOKEN

echo 'making tmpfile'
TMPFILE=$(mktemp /tmp/$(basename $0).XXXX)
echo "created tmpfile $TMPFILE"
trap "rm $TMPFILE" EXIT

echo "making get-session-token request"
/usr/local/bin/aws sts get-session-token --serial-number arn:aws:iam::012526998981:mfa/briandeane --token-code $TOKEN > $TMPFILE

echo "printing contents of tmpfile"
cat $TMPFILE

access_key_id=$(grep "AccessKeyId" $TMPFILE | cut -d':' -f2 | grep -o '".*"' | sed 's/"//g')
secret_access_key=$(grep "SecretAccessKey" $TMPFILE | cut -d':' -f2 | grep -o '".*"' | sed 's/"//g')
session_token=$(grep "SessionToken" $TMPFILE | cut -d':' -f2 | grep -o '".*"' | sed 's/"//g')

# TODO: cleverly write these to ~/.aws/credentials by overwriting previous values in 'mfa' profile
echo 'export these aws variables to shell'
cat <<DOC
export AWS_ACCESS_KEY_ID=$access_key_id
export AWS_SECRET_ACCESS_KEY=$secret_access_key
export AWS_SESSION_TOKEN=$session_token
DOC
