#!/bin/bash

${USERNAME:="admin"}
${URL_TO_REQUIREMENTS:=""}
# Change default User Interface for users. [Jupyterlab,nteract,None]
${USER_ENVIRONMENT:=""}
# Change Authenticator [firstuseauthenticator.FirstUseAuthenticator,nativeauthenticator.NativeAuthenticator]
${AUTHTYPE:=""}
# NativeAuthenticator
${OPEN_SIGNUP=""}
${FAILED_LOGINS=5}
${NEXT_TRY=120}
# FirstUseAuthenticator
${CREATE_USERS=""}



curl -L https://tljh.jupyter.org/bootstrap.py \
  | sudo python3 - \
    --admin $USERNAME 

if [ $AUTHTYPE = "NativeAuthenticator" ]; then
tljh-config set auth.type nativeauthenticator.NativeAuthenticator

if [ $OPEN_SIGNUP != "" ]; then
tljh-config set auth.NativeAuthenticator.open_signup $OPEN_SIGNUP
fi
tljh-config set auth.NativeAuthenticator.allowed_failed_logins $FAILED_LOGINS
tljh-config set auth.NativeAuthenticator.seconds_before_next_try $NEXT_TRY

cat <<'EOT'>/opt/tljh/config/jupyterhub_config.d/custom_template.py
import os, nativeauthenticator
c.JupyterHub.template_paths = [f"{os.path.dirname(nativeauthenticator.__file__)}/templates/"]
EOT
fi

if [ $USER_ENVIRONMENT != "" ]; then
tljh-config set user_environment.default_app $USER_ENVIRONMENT
fi
tljh-config reload