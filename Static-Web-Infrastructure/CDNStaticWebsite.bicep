targetScope = 'subscription'

param projectName string = 'default'
param environment string = 'test'
param location string = deployment().location
param uniqueId string = uniqueString(utcNow())
param resourcePrefix string = toLower('${projectName}${environment}')

param resourceGroupName string = '${projectName}-rg'
param storageAccountName string = toLower(take('${resourcePrefix}${uniqueId}', 24))
param profileName string = '${projectName}-CDN'
param endpointName string = '${projectName}-CDNEndpoint'

resource resourceGroup 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: resourceGroupName
  location: location
}

module StaticWeb './storageAccStaticWebsite.bicep' = {
  name: 'staticWebsite'
  scope: resourceGroup
  params: {
    storageAccountName: storageAccountName
    location: location

  }
}

module CDNProfile './CDNProfile.bicep' = {
  name: 'CDNProfile'
  scope: resourceGroup
  params: {
    profileName: profileName 
    location: location
  }
}

module CDNEndpointStaticWeb './CDNEndpointStaticWeb.bicep' = {
  name: 'CDNEndpointStaticWeb'
  scope: resourceGroup
  params: {
    endpointName: '${profileName}/${endpointName}'
    location: location
    storageAccountName: storageAccountName
  }
  dependsOn: [
    CDNProfile
  ]
}
