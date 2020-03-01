using namespace System.Net
using namespace NewtonSoft.Json
using namespace System.Threading
using namespace System.Threading.Tasks
using namespace Microsoft.Bot.Builder
using namespace Microsoft.Bot.Schema

param ([string]$QueueItem, $TriggerMetadata)

if (test-path ../host.json) {Set-Location ..}
Add-Type -Path ./PowerBot/lib/*.dll

class PwshFunctionAdapter : BotAdapter {
    PwshFunctionAdapter() {}

    [Task] ProcessActivityAsync ([Activity]$activity) {
        $context = [TurnContext]::New($this, $activity)
        return $this.RunPipelineAsync($context, $null, [CancellationToken]::new()).ConfigureAwait($false)
    }

    [Task[resourceresponse[]]] SendActivitiesAsync ([ITurnContext]$context, [Activity[]]$activity, [CancellationToken]$cancellationToken) {
        return $this
    }

    #Stub Methods to implement later
    [Task[resourceresponse]] UpdateActivityAsync ([ITurnContext]$context, [Activity]$activity, [CancellationToken]$cancellationToken) {
        throw [NotImplementedException]::new()
    }
    [Task] DeleteActivityAsync([ITurnContext]$context, [ConversationReference]$reference, [CancellationToken]$cancellationToken) {
        throw [NotImplementedException]::new()
    }
}

$ErrorActionPreference = 'Stop'

#Move up a directory if we aren't in the function root. This is needed for Pester
if (test-path ../host.json) {Set-Location ..}

$activity = [JsonConvert]::DeserializeObject(($QueueItem -replace '^---JSON---',''), [activity])

#Only Process Message Activities for now
if ($activity.Type -ne 'message') {return}

$reply = $activity.CreateReply("I got your message that says $($activity.text)")

#The API requires camelcase properties so we must customize jsonconvert behavior
$jsonConvertSettings = [JsonSerializerSettings]::new()
$jsonConvertSettings.NullValueHandling = 'Ignore'
$jsonConvertSettings.ContractResolver = [Serialization.CamelCasePropertyNamesContractResolver]::new()
$replyJson = [jsonconvert]::SerializeObject($reply, $jsonConvertSettings)

$replyUri = $Reply.ServiceUrl + 
    '/v3/conversations/' + 
    $Reply.conversation.id +
    '/activities/' + 
    $Reply.ReplyToId
Write-Host "Replying to activity: $($activity.Type)"
$restResult = Invoke-RestMethod -method 'POST' -ContentType 'application/json' -Body $replyJson -Uri $ReplyUri -Verbose