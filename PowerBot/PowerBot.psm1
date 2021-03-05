using namespace System.Net
using namespace NewtonSoft.Json
using namespace System.Threading
using namespace System.Threading.Tasks
using namespace Microsoft.Bot.Builder
using namespace Microsoft.Bot.Schema
using namespace Microsoft.Bot.Connector
using namespace Microsoft.Bot.Connector.Authentication

Add-Type -path $PSScriptRoot\lib\*.dll

#These stub functions are required due to the fact that the Azure Functions Powershell workers doesn't actually parse the module, it just looks in this file for functions.
#TODO: Remove if this gets fixed: 
function messages ($Request, $TriggerMetadata) { }
function messageHandler ($QueueItem, $TriggerMetadata) { }

$SCRIPT:client = $null

$ErrorActionPreference = 'Stop'
$DebugPreference = 'Continue'
$VerbosePreference = 'Continue'

$publicFunctions = [Collections.Generic.List[String]]@()
foreach ($folderItem in 'Classes', 'Private', 'Public', 'AzureFunctions') {
    if (Test-Path $PSScriptRoot\$folderItem) {
        (Get-Item $PSScriptRoot\$folderItem\*.ps1).foreach{
            . $PSItem
            if ($folderItem -in 'AzureFunctions', 'Public') {
                $PublicFunctions.Add($PSItem.basename)
            }
        }
    }
}

Export-ModuleMember -Function $publicFunctions