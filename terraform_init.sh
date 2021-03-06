#!/bin/bash
       
  # todo to be replaced with SAS key - short ttl or msi with the rover
id=$(az resource list --tag stgtfstate=level0 | jq -r .[0].id)
stg=$(az storage account show --ids ${id})
 
export storage_account_name=$(echo ${stg} | jq -r .name) && echo " - storage_account_name: ${storage_account_name}"
export resource_group=$(echo ${stg} | jq -r .resourceGroup) && echo " - resource_group: ${resource_group}"
export access_key=$(az storage account keys list --account-name ${storage_account_name} --resource-group ${resource_group} | jq -r .[0].value)
export container=$(echo ${stg}  | jq -r .tags.container) && echo " - container: ${container}"
export location=$(echo ${stg} | jq -r .location) && echo " - location: ${location}"
export tf_name="${PWD##*/}.tfstate" && echo " - tf_name: ${tf_name}"

export keyvault=$(az resource list --tag kvtfstate=level0 | jq -r .[0].name) && echo " - keyvault_name: ${keyvault}"

terraform init \
  -reconfigure \
  -backend=true \
  -lock=false \
  -backend-config storage_account_name=${storage_account_name} \
  -backend-config container_name=${container} \
  -backend-config access_key=${access_key} \
  -backend-config key=${tf_name}   
