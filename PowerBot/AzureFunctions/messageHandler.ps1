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

    $ErrorActionPreference = 'Stop'

    #Move up a directory if we aren't in the function root. This is needed for Pester
    if (test-path ../host.json) { Set-Location .. }

    $activity = [JsonConvert]::DeserializeObject(($QueueItem -replace '^---JSON---', ''), [activity])

    #Only Process Message Activities for now
    if ($activity.Type -ne 'message') { return }

    #Get credential from environment variable
    try {
        $botCredential = [PSCredential]::new($ENV:APPID, (ConvertTo-SecureString -AsPlainText -Force $ENV:APPSECRET))
    } catch {
        throw 'APPID and APPSECRET envrionment variables not found. Did you set them to the App ID and App Secret of your Bot App? https://blog.botframework.com/2018/07/03/find-your-azure-bots-appid-and-appsecret/'
    }

    Connect-AzBot -Uri $activity.ServiceUrl -Credential $botCredential
    $replyId = $Activity | 
        Submit-AzBotActivityReply -Text "I got your message that says $($activity.text)"
    Write-Verbose "Activity $($activity.id) successfully was successfully replied as $replyId"
}