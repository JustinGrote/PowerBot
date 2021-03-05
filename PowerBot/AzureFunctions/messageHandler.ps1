using namespace System.Net
using namespace NewtonSoft.Json
using namespace System.Threading
using namespace System.Threading.Tasks
using namespace Microsoft.Bot.Builder
using namespace Microsoft.Bot.Schema
using namespace Microsoft.Bot.Connector
using namespace Microsoft.Bot.Connector.Authentication
using namespace microsoft.bot.builder.integration.aspnet.core

function messageHandler {
    param ([string]$QueueItem, $TriggerMetadata)

    #Move up a directory if we aren't in the function root. This is needed for Pester
    if (test-path ../host.json) { Set-Location .. }

    $activity = [JsonConvert]::DeserializeObject(($QueueItem -replace '^---JSON---', ''), [activity])
    "===Incoming Activity to Process===" + [Environment]::NewLine + ($Activity | ConvertTo-Json) | Write-Debug

    #Only Process Message Activities for now
    if ($activity.Type -ne 'message') { return }

    Connect-AzBot -Uri $activity.ServiceUrl -AppID $env:APPID -AppSecret $env:APPSECRET
    $replyId = $Activity | 
        Submit-AzBotActivityReply -Text "I got your message that says $($activity.text)"

    "Activity $($activity.id) was successfully replied as $replyId" | Write-Verbose
}