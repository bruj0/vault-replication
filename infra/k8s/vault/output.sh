#!/bin/bash -x
helm template vault-injector . --namespace vault-injector --output-dir out -f values-auto.yaml
