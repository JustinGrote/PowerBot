function messageHandler {
    param ([string]$QueueItem, $TriggerMetadata)

    #Used to process the incoming activity Messages
    $pwshBotAdapter = [PwshBotAdapter]::new()

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
}