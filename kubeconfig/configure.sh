#!/bin/sh

kubectl config set-cluster ${cluster} \
  --embed-certs=true \
  --server=${server} \
  --certificate-authority=${ca_pem}

kubectl config set-credentials admin@${cluster} \
  --embed-certs=true \
  --certificate-authority=${ca_pem} \
  --client-key=${client_key} \
  --client-certificate=${client_pem}

kubectl config set-context ${cluster}  \
  --cluster=${cluster} \
  --user=admin@${cluster} \
  --namespace=${namespace}

[ "${use_context}" = "true" ] && kubectl config use-context ${cluster}
