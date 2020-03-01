Describe "messageHandler" {
    It 'Runs' {
        & $PSScriptRoot/run.ps1 -QueueItem (gc -raw $PSScriptRoot/Mocks/Hello.json)
    }
}
