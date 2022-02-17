README 

Confluence WalkThrough : https://anikasystemsinc.atlassian.net/wiki/spaces/MSP/pages/370049027/Static+Website+Logic+App+Deployment


Pre-Deployment Steps: 
- Configure Azure Storage Account (Take note of the name)
- Create Table within Azure Storage Account (Take note of the Table name)

Deployment Steps: 
- az deployment group create --resource-group CorpSite-Static-POC-RG --template-file template.bicep
- Provide params storageAccount &  storageAccountTableName

Final Step Post Deployment: 
- Go into Logic App Designer, and authenticate / verify the two API connections (SendEmail & AddToTable)