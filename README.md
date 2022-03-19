# CDN Distributed Static Website Deployment:
This service catalog offering builds out a basic website hosted in a Storage Account behind a CDN Endpoint.

## Prerequisites: 
- Have the entire VDC deployed in either the 1 or 3 subscription testing approach

## Deployment Command: 
***az deployment sub create --location eastus --template-file service-catalog/StaticWebsite/CDNStaticWebsite.bicep***

## Post Deployment: 
Navigate to the resource group created in the Azure portal. Select the CDN endpoint resource. You then can select the origin URL or the CDN URL to view the default website created by the service catalog 

If you have website front-end code readily available, you can batch upload files to your new static website configuration using the following command:

***az storage blob upload-batch --source LOCAL_WEBSITE_FILES --destination https://STORAGE_NAME.blob.core.windows.net/$web --account-name NAME_HERE --account-key KEY_HERE***