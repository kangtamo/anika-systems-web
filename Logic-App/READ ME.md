READ ME 

Pre-Deployment Steps: 
- Configure Azure Storage Account (Take note of the name)
- Create Table within Azure Storage Account (Take note of the Table name)

Deployment Steps: 
- az deployment group create --resource-group CorpSite-Static-POC-RG --template-file template.bicep
- Provide params storageAccount &  storageAccountTableName

Final Step Post Deployment: 
    Go into Logic App Designer, and authenticate / verify the two API connections (SendEmail & AddToTable)