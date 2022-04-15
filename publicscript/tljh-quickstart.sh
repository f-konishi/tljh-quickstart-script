#!/bin/bash

${USERNAME:="admin"}
${USER_ENVIRONMENT:=""}
${AUTHTYPE:=""}
FAILED_LOGINS=5
NEXT_TRY=120

curl -L https://tljh.jupyter.org/bootstrap.py \
  | sudo python3 - \
    --admin $USERNAME

if [ $AUTHTYPE = "NativeAuthenticator" ]; then
tljh-config set auth.type nativeauthenticator.NativeAuthenticator
tljh-config set auth.NativeAuthenticator.allowed_failed_logins $FAILED_LOGINS
tljh-config set auth.NativeAuthenticator.seconds_before_next_try $NEXT_TRY

cat <<'EOT'>/opt/tljh/config/jupyterhub_config.d/custom_template.py
import os, nativeauthenticator
c.JupyterHub.template_paths = [f"{os.path.dirname(nativeauthenticator.__file__)}/templates/"]
EOT
fi

if [ $USER_ENVIRONMENT != ""]; then
tljh-config set user_environment.default_app $INTERFACE
fi
tljh-config reload