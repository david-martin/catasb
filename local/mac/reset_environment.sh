#!/bin/sh

ANS_CODE="../../ansible"
source ./common_vars
ansible-playbook -vv ${ANS_CODE}/reset_mac_environment.yml --extra-vars "${EXTRA_VARS}"
