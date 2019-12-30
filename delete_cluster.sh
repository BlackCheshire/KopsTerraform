#!/bin/bash 
source input.in 

terraform init

terraform destroy -auto-approve

cd backend/

terraform init

sed -i 's/${var.cluster_name}/'${CLUSTER_NAME}'/g' vpc_kops.tf

terraform destroy -auto-approve \
-var "access_key=${AWS_ACCESS_KEY_ID}" \
-var "secret_key=${AWS_SECRET_ACCESS_KEY}" \
-var "region=${REGION}" \
-var "cluster_name=${CLUSTER_NAME}" \
-var "cidr=${NETWORK_CIDR}" \
-var "node_size=${NODE_SIZE}" \
-var "master_size=${MASTER_SIZE}" \
-var "kub_ver=${KUBERNETES_VERSION}" \
-var "node_q=${NODE_QUANTITY}" \
-var "network_p=${KUBE_NETWORK}" \
-var "image=${IMAGE}" \
-var "subnets=${SUBNETS}" \
-var "azs=${AV_ZONE}" \
-var "api_a=${API_ACCESS}" \
-var "ssh_a=${SSH_ACCESS}"

sed -i 's/'${CLUSTER_NAME}'/${var.cluster_name}/g' vpc_kops.tf

aws s3 rb s3://${CLUSTER_NAME} --force