using namespace System.Threading
using namespace System.Threading.Tasks
using namespace Microsoft.Bot.Builder
using namespace Microsoft.Bot.Schema
class EchoBot : Ibot {
    [Task] OnTurnAsync ([ITurnContext]$context, [CancellationToken]$cancellationToken = $null) {
        return $context.SendActivityAsync('Got it!')
    }
}