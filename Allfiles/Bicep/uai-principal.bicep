param name string = 'mytest'

resource name_resource 'Microsoft.ManagedIdentity/userAssignedIdentities@2018-11-30' = {
  name: name
  location: resourceGroup().location
}

output principalId string = reference(name_resource.id, '2018-11-30', 'Full').properties.principalId