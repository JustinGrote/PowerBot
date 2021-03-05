
function messages {
    param ($Request, $TriggerMetadata)
    "Received $($Request.Body.Type) Activity" | Write-Information

    Push-OutputBinding -Name messages -Value ("---JSON---" + $Request.RawBody)

    Push-OutputBinding -Name Response -Value (
        [HttpResponseContext]@{
            StatusCode = [HttpStatusCode]::Accepted
            Body = ''
        }
    )
}