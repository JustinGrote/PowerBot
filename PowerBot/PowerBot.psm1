using assembly lib/Microsoft.Bot.Builder.dll
using assembly lib/Microsoft.Bot.Schema.dll
using assembly lib/Newtonsoft.Json.dll
using namespace System.Net
using namespace NewtonSoft.Json
using namespace System.Threading
using namespace System.Threading.Tasks
using namespace Microsoft.Bot.Builder
using namespace Microsoft.Bot.Schema

#These stub functions are required due to sub-optimal Azure Functions Host Parsing
#TODO: Remove if this gets fixed: 
function messages ($Request, $TriggerMetadata) {}
function messageHandler ($QueueItem, $TriggerMetadata) {}

@('Classes','Public').foreach{
    (Get-Item $PSScriptRoot\$PSItem\*.ps1).foreach{
        . $PSItem
    }
}

"Look Ma I'm Famous" > $home\desktop\test.txt

Export-ModuleMember 'messages','messageHandler'