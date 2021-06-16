param variables_managedIdentityName ? /* TODO: fill in correct type */

@description('The region were to deploy assets')
param location string

resource variables_managedIdentityName_resource 'Microsoft.ManagedIdentity/userAssignedIdentities@2018-11-30' = {
  name: variables_managedIdentityName
  location: location
}