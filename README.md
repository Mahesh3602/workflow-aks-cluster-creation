# AKS Cluster Workflow

# run in cloud shell
Define your assigned group
RESOURCE_GROUP="XXXX"
# Storage name must be unique globally - add some random numbers at the end
STORAGE_ACCOUNT_NAME="maheshtfstate$(date +%s)"

# Create Storage Account
az storage account create --resource-group $RESOURCE_GROUP --name $STORAGE_ACCOUNT_NAME --sku Standard_LRS

# Create Blob Container
az storage container create --name tfstate --account-name $STORAGE_ACCOUNT_NAME

# set env secrets and variables
ARM_CLIENT_ID = 
ARM_CLIENT_SECRET = 

ARM_TENANT_ID = 

ARM_SUBSCRIPTION_ID = 

AZURE_RG

STORAGE_ACCOUNT_NAME