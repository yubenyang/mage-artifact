#!/usr/bin/env bash
set -euo pipefail

node=$1
ssh root@"$node" 'mkdir -p /root/.ssh && chmod 700 /root/.ssh'
scp "$HOME/.ssh/id_rsa" root@"$node":/root/.ssh/id_rsa
ssh root@"$node" 'chmod 600 /root/.ssh/id_rsa'