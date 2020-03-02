using namespace Microsoft.Bot.Connector
using namespace Microsoft.IdentityModel.Clients.ActiveDirectory
using namespace System.Threading

function Connect-AzBot {
    param (
        #Bot Service Endpoint Uri
        $Uri = 'https://api.botframework.com',
        #Enter your Bot Service AppId and Secret from your Bot Channel Registration. Hint: https://portal.azure.com/#create/Microsoft.BotServiceConnectivityGalleryPackage
        [Parameter(Mandatory)][PSCredential]$Credential,
        #Pass through the connector Client Object
        [Switch]$PassThru,
        #How long to wait for authentication to complete, in seconds (Default: 3)
        [Int]$Timeout = 1
    )

    #Microsoft.Bot.Connector.ConnectorClient new(uri baseUri, string microsoftAppId, string microsoftAppPassword, Params System.Net.Http.DelegatingHandler[] handlers)
    $SCRIPT:client = [ConnectorClient]::new($Uri, $Credential.Username, $Credential.GetNetworkCredential().Password, $null)

    $cancelSource = [CancellationTokenSource]::new([TimeSpan]::new(0, 0, $Timeout))

    #System.Threading.Tasks.Task[Microsoft.Rest.HttpOperationResponse[Microsoft.Bot.Schema.ConversationsResult]] GetConversationsWithHttpMessagesAsync(string continuationToken, System.Collections.Generic.Dictionary[string,System.Collections.Generic.List[string]]customHeaders, System.Threading.CancellationToken cancellationToken)

    try {
        $connectClientResult = $client.Conversations.GetConversationsWithHttpMessagesAsync($null, $null, $cancelSource.Token).Result
    }
    catch {
        #TODO: Cleaner error handling
        if ($PSItem -match '\: \"(?<message>.+?) \(AADSTS(?<errorCode>\d+)\: (?<detailMessage>.+)') {
            throw ([ADALServiceException]::new($matches.errorCode, ($matches.message, $matches.detailMessage -join ' ')))
            #throw [AdalException]::new(($psitem -split 'AADSTS')[1].split('Trace ID')[0]
        }
        else {
            throw $PSItem
        }
    }

    if (-not $connectClientResult.Body.Conversations) { throw "Connected to $uri but no conversations were found. This client should only be used in response to incoming conversation activities" }

    if ($PassThru) { return $client }
}