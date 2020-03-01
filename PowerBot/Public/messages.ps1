
function messages {
    param ($Request, $TriggerMetadata)
    Write-Host $Request.RawBody
    Write-Host "Received $($Request.Body.Type) Activity"

    Push-OutputBinding -Name messages -Value ("---JSON---" + $Request.RawBody)

    Push-OutputBinding -Name Response -Value (
        [HttpResponseContext]@{
            StatusCode = [HttpStatusCode]::Accepted
            Body = ''
        }
    )
}