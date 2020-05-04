#!/bin/bash -x
helm template vault vault-helm/ --namespace vault --output-dir . -f $1
