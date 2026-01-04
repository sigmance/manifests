#!/usr/bin/env bash
set -euo pipefail

script_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)

kubectl apply -f "${script_dir}/example/katib-mysql-pv.yaml"
kubectl apply -f "${script_dir}/example/mysql-pv-claim-pv.yaml"
kubectl apply -f "${script_dir}/example/minio-pvc-pv.yaml"
kubectl apply -f "${script_dir}/example/seaweedfs-pv.yaml"

while ! kustomize build "${script_dir}/example" | kubectl apply --server-side --force-conflicts -f -; do
  echo "Retrying to apply resources"
  sleep 20
done
