#!/bin/bash -x

TOKEN_REVIEW_JWT=$(kubectl get -n openshift-config secret vault-auth -o go-template='{{ .data.token }}' | base64 --decode)
KUBE_CA_CERT=$(kubectl config view --raw --minify --flatten -o jsonpath='{.clusters[].cluster.certificate-authority-data}' | base64 --decode)
KUBE_HOST=$(kubectl config view --raw --minify --flatten -o jsonpath='{.clusters[].cluster.server}')

echo "export TOKEN_REVIEW_JWT=$TOKEN_REVIEW_JWT"
echo "export KUBE_CA_CERT=$KUBE_CA_CERT"
echo "export KUBE_HOST=$KUBE_HOST"
