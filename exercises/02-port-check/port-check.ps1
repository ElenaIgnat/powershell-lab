$servers = Get-Content ".\data\servers.txt"

$results = @()

foreach ( $server in $servers) {

    $test = Test-NetConnection `
        -ComputerName $server `
        -Port 443 `
        -WarningAction SilentlyContinue
    
    $results += [PSCustomObject]@{
        Server = $server
        Port = 443
        Reachable = $test.TcpTestSucceeded
        }
}

$results | Export-Csv ".\data\port-443-report.csv" -NoTypeInformation

$results

