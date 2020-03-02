using namespace Microsoft.Bot.Schema
using namespace Microsoft.Bot.Connector

function Submit-AzBotActivityReply {
    [CmdletBinding(SupportsShouldProcess)]
    param (
        #The activity you wish to submit
        [Parameter(Mandatory, ValueFromPipeline)][Activity]$Activity,
        #The text of the reply
        [Parameter(Mandatory)][String]$Text
    )
    if (-not $client) { throw 'You must connect with the Connect-AzBot command first' }

    $activityReply = $Activity.CreateReply($Text)
    if ($PSCmdlet.ShouldProcess(
            "Conversation $($activityReply.conversation.id)", 
            "Replying to activity $($activityReply.ReplyToId) with text $text"
    )) {
        $response = [ConversationsExtensions]::ReplyToActivity(
            $client.Conversations, 
            $activityReply
        )
        if (-not $response.id) {
            throw 'An activity ID was not returned. This is usually either a bug or a sign that the command failed for another reason'
        }
        return $response.id
    }
}