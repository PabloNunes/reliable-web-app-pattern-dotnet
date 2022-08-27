param location string
param resourceToken string
param tags object
param isProd bool

var storageSku = isProd ? 'Standard_ZRS' : 'Standard_LRS'

resource storageAccount 'Microsoft.Storage/storageAccounts@2021-09-01' = {
  name: '${resourceToken}storage' //storage account name cannot contain character '-'
  tags: tags
  location: location
  sku: {
    name: storageSku
  }
  kind: 'StorageV2'

  resource queueService 'queueServices@2021-09-01' = {
    name: 'default'

    resource queue 'queues@2021-09-01' = {
      name: 'relecloudconcertevents'
    }
  }
}

resource existingKv 'Microsoft.KeyVault/vaults@2021-11-01-preview' existing = {
  name: 'rc-${resourceToken}-kv' // keyvault name cannot start with a number
  scope: resourceGroup()
}

resource kvSecretStorageAcct 'Microsoft.KeyVault/vaults/secrets@2021-11-01-preview' = {
  parent: existingKv
  name: 'App--StorageAccount--QueueConnectionString'
  properties: {
    value: 'DefaultEndpointsProtocol=https;AccountName=${storageAccount.name};AccountKey=${storageAccount.listKeys().keys[0]};EndpointSuffix=core.windows.net'
  }
}

output keyVaultStorageConnStrName string = kvSecretStorageAcct.name