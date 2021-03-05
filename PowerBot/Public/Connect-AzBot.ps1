using namespace Microsoft.Bot.Connector
using namespace Microsoft.Bot.Connector.Authentication
using namespace Microsoft.IdentityModel.Clients.ActiveDirectory
using namespace System.Threading
using namespace System.Net
using namespace System.Net.HTTP

function Connect-AzBot {
    param (
        #Bot Service Endpoint Uri
        $Uri = 'https://api.botframework.com',
        #Enter your Bot Service AppId and Secret from your Bot Channel Registration. Hint: https://portal.azure.com/#create/Microsoft.BotServiceConnectivityGalleryPackage
        [Parameter(Mandatory)][String]$AppID,
        [Parameter(Mandatory)][String]$AppSecret,
        #Pass through the connector Client Object
        [Switch]$PassThru,
        #Specify an HTTP proxy. Useful with Fiddler for low level debugging
        [String]$Proxy = $ENV:AZBOTPROXY
    )

    if ($Proxy) {
        $httpClientHandlerWithProxy = [HTTPClientHandler]@{
            UseProxy = $true
            Proxy    = [WebProxy]::new($Proxy, $false)
        }
        $httpClientWithProxy = [HttpClient]::New($httpClientHandlerWithProxy)

        $microsoftAppCredentials = [MicrosoftAppCredentials]::new($AppID, $AppSecret, $httpClientWithProxy) 
        $SCRIPT:client = [ConnectorClient]::new($Uri, $microsoftAppCredentials, $httpClientWithProxy, $false, $null)
    }
    else {
        $SCRIPT:client = [ConnectorClient]::new($Uri, $AppID, $AppSecret, $null)
    }

    #BUG: I shouldn't have to do this. Headers aren't getting added for some reason
    $client::AddDefaultRequestHeaders($client.httpclient)
    $client.httpclient.DefaultRequestHeaders.Authorization = "Bearer $($client.credentials.GetTokenAsync().GetAwaiter().GetResult())"


    #Ping the API to see if there are any errors using the key
    #Get-AzBotConversation -ErrorAction Stop > $null

    if ($PassThru) { return $client }
}