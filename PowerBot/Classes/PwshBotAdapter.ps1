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
    PwshBotAdapter() {}

    [Task] ProcessActivityAsync ([Activity]$activity) {
        $context = [TurnContext]::New($this, $activity)
        return $this.RunPipelineAsync($context, $null, [CancellationToken]::new()).ConfigureAwait($false)
    }

    [Task[microsoft.bot.schema.resourceresponse[]]] SendActivitiesAsync ([ITurnContext]$context, [Activity[]]$activity, [CancellationToken]$cancellationToken) {
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
