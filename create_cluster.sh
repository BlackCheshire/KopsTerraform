#!/bin/bash 
source input.in 
aws s3api create-bucket --bucket $CLUSTER_NAME --region $REGION --create-bucket-configuration LocationConstraint=$REGION

cd backend/

{
echo 'terraform {'
echo 'backend "s3" {'
echo 'encrypt = true' 
echo 'bucket =' "\"${CLUSTER_NAME}"\"
echo 'key    =' "\"terraform/${CLUSTER_NAME}"\" 
echo 'region =' "\"${REGION}"\"
echo '}' 
echo '}' 
} > terraform_state_backet.tf

sed -i 's/${var.cluster_name}/'${CLUSTER_NAME}'/g' vpc_kops.tf

terraform init \
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

terraform apply -auto-approve \
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

TF_OUTPUT=$(terraform output -json)

echo $TF_OUTPUT

sed -i 's/'${CLUSTER_NAME}'/${var.cluster_name}/g' vpc_kops.tf

cd ..

{
echo 'terraform {'
echo 'backend "s3" {'
echo 'encrypt = true' 
echo 'bucket =' "\"${CLUSTER_NAME}"\"
echo 'key    =' "\"kops/${CLUSTER_NAME}"\" 
echo 'region =' "\"${REGION}"\"
echo '}' 
echo '}' 
} > terraform_state_backet.tf

kops toolbox template --name ${CLUSTER_NAME} --values <( echo ${TF_OUTPUT}) --template template_public.yaml --format-yaml > cluster.yaml

STATE="s3://$(echo ${TF_OUTPUT} | jq -r .cluster_name.value)"

kops replace -f cluster.yaml --state ${STATE} --name ${CLUSTER_NAME} --force

kops create secret --name ${CLUSTER_NAME} --state ${STATE} --name ${CLUSTER_NAME} sshpublickey admin -i ~/.ssh/id_rsa.pub

kops update cluster --out=. --target=terraform --state ${STATE} --name ${CLUSTER_NAME}

terraform init

terraform apply -auto-approve