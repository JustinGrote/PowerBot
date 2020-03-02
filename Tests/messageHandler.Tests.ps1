Describe "messageHandler" {
    Import-Module $PSScriptRoot\..\PowerBot\PowerBot.psm1 -force
    It 'Runs' {
        messageHandler -QueueItem (gc -raw $PSScriptRoot/Mocks/Hello.json)
    }
}
