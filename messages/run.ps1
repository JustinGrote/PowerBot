using namespace System.Net
#Accepts messages from Bot Services and places them in the queue for processing

# Input bindings are passed in via param block.
param($Request, $TriggerMetadata)

Write-Host $Request.RawBody
Write-Host "Received $($Request.Body.Type) Activity"

#We append ---JSON--- to force the input binding to not parse it into a PSObject since we are going to convert it to a Bot Activity
Push-OutputBinding -Name messages -Value ("---JSON---" + $Request.RawBody)

Push-OutputBinding -Name Response -Value ([HttpResponseContext]@{
    StatusCode = [HttpStatusCode]::Accepted
    Body = ''
})