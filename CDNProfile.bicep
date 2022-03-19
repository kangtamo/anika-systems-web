
param profileName string
param location string 

param CDNSku string = 'Standard_Microsoft'

resource CDNProfile 'Microsoft.Cdn/profiles@2020-04-15' = {
  name: profileName
  location: location
  sku: {
    name: CDNSku
  }
}
