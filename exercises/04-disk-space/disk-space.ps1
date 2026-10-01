Get-CimInstance Win32_LogicalDisk |
    Where-Object { $_.DriveType -eq 3} |
    Select-Object DeviceId,
        @{Name='SizeGB'; Expression={[math]::Round($_.Size / 1GB , 2)}},
        @{Name='FreeGB'; Expression={[math]::Round($_.FreeSpace /1GB ,2)}} ,
        @{Name='FreePercent'; Expression={ [math]::Round(($_.FreeSpace / $_.Size) * 100, 2) }} |
    Export-Csv -Path "C:\Projects\powershell-lab\data\disk-space-report.csv" -NoTypeInformation