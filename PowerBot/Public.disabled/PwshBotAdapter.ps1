using assembly ../lib/Microsoft.Bot.Builder.dll
using assembly ../lib/Microsoft.Bot.Schema.dll
using assembly ../lib/Newtonsoft.Json.dll
using namespace System.Net
using namespace Newtonsoft.Json
using namespace System.Threading
using namespace System.Threading.Tasks
using namespace Microsoft.Bot.Builder
using namespace Microsoft.Bot.Schema

class PwshBotAdapter : BotAdapter {
    PwshBotAdapter() {$this}

    [Task] ProcessActivityAsync ([Activity]$activity) {
        write-host "ProcessActivityAsync $($activity.id)"
        $context = [TurnContext]::New($this, $activity)
        $cancel = [CancellationTokenSource]::new()
        $runPipelineAsyncTask = $this.RunPipelineAsync($context, $null ,$cancel.Token)
        return $runPipelineAsyncTask
    }

    [Task[microsoft.bot.schema.resourceresponse[]]] SendActivitiesAsync ([ITurnContext]$context, [Activity[]]$activity, [CancellationToken]$cancellationToken) {
        write-host "Sending Activity $($activity.text)"
        return [resourceresponse[]]@([ResourceResponse](($activity.id)))
    }

    #Stub Methods to implement later
    [Task[resourceresponse]] UpdateActivityAsync ([ITurnContext]$context, [Activity]$activity, [CancellationToken]$cancellationToken) {
        throw [NotImplementedException]::new()
    }
    [Task] DeleteActivityAsync([ITurnContext]$context, [ConversationReference]$reference, [CancellationToken]$cancellationToken) {
        throw [NotImplementedException]::new()
    }
}