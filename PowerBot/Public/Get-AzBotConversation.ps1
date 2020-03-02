using namespace Microsoft.Bot.Connector

function Get-AzBotConversation {
    param(
        #Timeout in milliseconds. Default is 3000 (3 seconds)
        [int]$timeout = 3000
    )
    if (-not $client) {throw 'You must connect with the Connect-AzBot command first'}

    [ConversationsExtensions]::GetConversationsAsync($client.conversations).GetAwaiter().GetResult().Conversations
}