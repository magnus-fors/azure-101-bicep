// This bicep main template is deployed from the project root using the following command
// az deployment group create -n <deployment name> -g <resource group name> -f main.bicep
// Example:
//   az group create --name magnusfo-bicep-group --location 'northeurope'
//   az deployment group create --name mydeployment --resource-group magnusfo-bicep-group -f main.bicep

@description('Azure region where resources should be deployed')
param location string = 'northeurope'

@description('Timestamp used to uniquely name each module deployment')
param now string = utcNow()

module web './modules/web.bicep' = {
  name: 'web-module-${now}'
  params: {
    location: location
  }
}

module storage './modules/storage.bicep' = {
  name: 'storage-module-${now}'
  params: {
    location: location
  }
}

module cosmos './modules/cosmos.bicep' = {
  name: 'cosmos-module-${now}'
  params: {
    location: location
  }
}

module servicebus './modules/servicebus.bicep' = {
  name: 'servicebus-module-${now}'
  params: {
    location: location
  }
}

module functionApp './modules/function-app.bicep' = {
  name: 'function-app-module-${now}'
  params: {
    location: location

    // a list of endpoints that will be added to the CORS list on the function app
    corsUrls: [
      web.outputs.storageWebEndpoint
      web.outputs.cdnEndpoint
    ]

    // TODO: add application settings that your function app requires
    // - go through the local.settings.json file in your function app project to see which app settings you need
    // - check ./modules/function-app.bicep to see which app settings are provided automatically for you
    appSettings: [
      {
        name: 'AZURE_STORAGE_CONNECTION_STRING'
        value: storage.outputs.connectionString
      }
      {
        name: 'magnusfocosmodb_DOCUMENTDB'
        value: cosmos.outputs.connectionString
      }
      {
        name: 'SERVICE_BUS_CONNECTION_STRING'
        value: servicebus.outputs.connectionString
      }
    ]
  }
}
