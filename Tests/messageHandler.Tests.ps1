Describe "messageHandler" {
    Import-Module $PSScriptRoot\..\PowerBot\PowerBot.psm1 -force
    #$ENV:AZBOTPROXY = 'http://localhost:8888'
    It 'Runs' {
        messageHandler -QueueItem (gc -raw $PSScriptRoot/Mocks/Teams.json)
    }
}
