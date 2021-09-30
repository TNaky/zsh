#!/usr/bin/zsh

local aws_dir_path=${XDG_CONFIG_HOME}/aws
if [ -d ${aws_dir_path} ]; then
    export AWS_CONFIG_FILE=${aws_dir_path}/config
    export AWS_SHARED_CREDENTIALS_FILE=${aws_dir_path}/credentials
fi

unset aws_dir_path
