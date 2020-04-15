#!/bin/bash -x
helm template vault vault-helm/ --namespace vault --output-dir out -f values-ha-raft.yaml
