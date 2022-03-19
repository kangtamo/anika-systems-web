// This deployment creates a storage account and enables it for static web hosting  
param storageAccountName string
param location string
param storageSku string = 'Standard_LRS'
param indexDocumentPath string = 'index.html'
param indexDocumentContents string = '<h1>Example static website</h1>'

resource storageAccountName_resource 'Microsoft.Storage/storageAccounts@2021-06-01' = {
  name: storageAccountName
  location: location
  kind: 'StorageV2'
  sku: {
    name: storageSku
  }
}

resource DeploymentScript 'Microsoft.ManagedIdentity/userAssignedIdentities@2018-11-30' = {
  name: 'DeploymentScript'
  location: location
}

resource id_Microsoft_ManagedIdentity_userAssignedIdentities_DeploymentScript_Microsoft_Authorization_roleDefinitions_17d1049b_9a84_46fb_8f53_869881c3d3ab 'Microsoft.Authorization/roleAssignments@2020-04-01-preview' = {
  scope: storageAccountName_resource
  name: guid(resourceGroup().id, DeploymentScript.id, subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '17d1049b-9a84-46fb-8f53-869881c3d3ab'))
  properties: {
    roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '17d1049b-9a84-46fb-8f53-869881c3d3ab')
    principalId: DeploymentScript.properties.principalId
    principalType: 'ServicePrincipal'
  }
}

resource Microsoft_Resources_deploymentScripts_deploymentScript 'Microsoft.Resources/deploymentScripts@2020-10-01' = {
  name: 'deploymentScript'
  location: location
  kind: 'AzurePowerShell'
  identity: {
    type: 'UserAssigned'
    userAssignedIdentities: {
      '${DeploymentScript.id}': {}
    }
  }
  properties: {
    azPowerShellVersion: '3.0'
    scriptContent: '$ErrorActionPreference = \'Stop\'\n$storageAccount = Get-AzStorageAccount -ResourceGroupName $env:ResourceGroupName -AccountName $env:StorageAccountName\n\n# Enable the static website feature on the storage account.\n$ctx = $storageAccount.Context\nEnable-AzStorageStaticWebsite -Context $ctx -IndexDocument $env:IndexDocumentPath\n\n# Add the index HTML page.\n$tempIndexFile = New-TemporaryFile\nSet-Content $tempIndexFile $env:IndexDocumentContents -Force\nSet-AzStorageBlobContent -Context $ctx -Container \'$web\' -File $tempIndexFile -Blob $env:IndexDocumentPath -Properties @{\'ContentType\' = \'text/html\'} -Force\n'
    retentionInterval: 'PT4H'
    environmentVariables: [
      {
        name: 'ResourceGroupName'
        value: resourceGroup().name
      }
      {
        name: 'StorageAccountName'
        value: storageAccountName
      }
      {
        name: 'IndexDocumentPath'
        value: indexDocumentPath
      }
      {
        name: 'IndexDocumentContents'
        value: indexDocumentContents
      }
    ]
  }
  dependsOn: [
    id_Microsoft_ManagedIdentity_userAssignedIdentities_DeploymentScript_Microsoft_Authorization_roleDefinitions_17d1049b_9a84_46fb_8f53_869881c3d3ab
    storageAccountName_resource
  ]
}

output staticWebsiteUrl string = storageAccountName_resource.properties.primaryEndpoints.web
