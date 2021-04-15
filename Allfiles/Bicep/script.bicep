param name string = '\\"John Dole\\"'
param utcValue string = utcNow()

resource runPowerShellInlineWithOutput 'Microsoft.Resources/deploymentScripts@2020-10-01' = {
  name: 'runPowerShellInlineWithOutput'
  location: resourceGroup().location
  kind: 'AzurePowerShell'
  properties: {
    forceUpdateTag: utcValue
    azPowerShellVersion: '5.0'
    scriptContent: '\n          param([string\n                ] $name)\n          $output = "Hello {0}" -f $name\n          Write-Output $output\n          $DeploymentScriptOutputs = @{}\n          $DeploymentScriptOutputs[\'text\'\n                ] = $output\n        '
    arguments: '-name ${name}'
    timeout: 'PT1H'
    cleanupPreference: 'OnSuccess'
    retentionInterval: 'P1D'
  }
}

output result string = reference('runPowerShellInlineWithOutput').outputs.text