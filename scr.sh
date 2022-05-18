#!/bin/bash

if groups $PAM_USER | grep admin > /dev/null; then
   exit 0
else
    if [[ (date +%u) > 5 ]]; then
        exit 1
    fi
fi 