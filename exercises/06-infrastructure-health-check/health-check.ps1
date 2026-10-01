$computer = Get-CimInstance Win32_ComputerSystem
$os = Get-CimInstance Win32_OperatingSystem

Write-Output "Hostname: $($computer.Name)"
Write-Output "OS:$($os.Caption)"
Write-Output "Last Boot: $($os.LastBootUpTime)"

$uptime = (Get-Date) - $os.LastBootUpTime

Write-Output "Uptime: $($uptime.Days) days, $($uptime.Hours) hours"

$network = Get-NetIPConfiguration |
    Where-Object { $_.IPv4DefaultGateway -ne $null }

Write-Output "IP Address: $($network.IPv4Address.IPAddress)"
Write-Output "Default Gateway: $($network.IPv4DefaultGateway.NextHop)"
Write-Output "DNS Servers: $($network.DNSServer.ServerAddresses -join ', ')"

$disk = Get-CimInstance Win32_LogicalDisk |
    Where-Object { $_.DeviceID -eq 'C:' }

$freePercent = [math]::Round(($disk.FreeSpace / $disk.Size) * 100, 2)

Write-Output "Disk C: Free Space: $([math]::Round($disk.FreeSpace / 1GB, 2)) GB"
Write-Output "Disk C: Free Percent: $freePercent %"

$services = 'WinRM', 'W32Time', 'Dnscache'

foreach ($serviceName in $services) {
    $service = Get-Service -Name $serviceName -ErrorAction SilentlyContinue

    if ($null -eq $service) {
        Write-Output "Service $($serviceName): NOT FOUND"
    }
    else {
        Write-Output "Service $($serviceName): $($service.Status)"
    }
}

$targets = '192.168.100.1', '192.168.100.10', 'google.com'

foreach ($target in $targets) {
    $reachable = Test-Connection -ComputerName $target -Count 1 -Quiet

    if ($reachable) {
        Write-Output "Connectivity $($target): OK"
    }
    else {
        Write-Output "Connectivity $($target): FAILED"
    }
}

$portTests = @(
    @{ Host = 'google.com'; Port = 443 },
    @{ Host = 'github.com'; Port = 443 }
)

foreach ($test in $portTests) {
    $result = Test-NetConnection -ComputerName $test.Host -Port $test.Port -WarningAction SilentlyContinue

    if ($result.TcpTestSucceeded) {
        Write-Output "TCP $($test.Host):$($test.Port): OK"
    }
    else {
        Write-Output "TCP $($test.Host):$($test.Port): FAILED"
    }
}