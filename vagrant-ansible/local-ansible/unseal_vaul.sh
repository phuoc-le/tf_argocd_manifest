#!/bin/bash

set -ex

VAULT_KEY_1='xOVWr4OtVw4IPewgn/4ilP1ASjtoIGQh9q5vLsca/Axt'
VAULT_KEY_2='0M7rKcqXk5BijyRL+ro3ACarj+I9yZLV3kFZsCVFnW8Y'
VAULT_KEY_3='DYXGLa6BGCU87F+IAhDFrOmfl+qfBUCnLF+rxoGvpgKE'

kubectl wait --for=jsonpath='{.status.phase}'=Running pod -l app.kubernetes.io/name=vault -n infra --timeout=900s

kubectl exec -it vault-0 -n infra -- vault operator unseal $VAULT_KEY_1
kubectl exec -it vault-0 -n infra -- vault operator unseal $VAULT_KEY_2
kubectl exec -it vault-0 -n infra -- vault operator unseal $VAULT_KEY_3