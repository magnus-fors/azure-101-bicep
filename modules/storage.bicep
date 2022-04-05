param location string

resource storageAccount 'Microsoft.Storage/storageAccounts@2021-08-01' = {
  name: 'magnusfo${uniqueString(resourceGroup().id)}'
  location: location
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'StorageV2'

  resource blobServ 'blobServices' = {
    name: 'default'

    resource imageContainer 'containers' = {
      name: 'images'
      properties: {
        publicAccess: 'Blob'
      }
    }

    resource thumbnailContainer 'containers' = {
      name: 'thumbnails'
      properties: {
        publicAccess: 'Blob'
      }
    }
  }
}

output storageAccountName string = storageAccount.name

output connectionString string = 'DefaultEndpointsProtocol=https;AccountName=${storageAccount.name};AccountKey=${storageAccount.listKeys().keys[0].value};EndpointSuffix=core.windows.net'
