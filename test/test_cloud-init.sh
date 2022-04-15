#/bin/bash

export USERNAME="admin123"
export INTEFACE=""
export AUTHTYPE="NativeAuthenticator"

${USERNAME:="admin"}
${INTERFACE:=""}
${AUTHTYPE:=""}
${FAILED_LOGINS:="5"}
${NEXT_TRY:="120"}

printenv 
echo $AUTHTYPE