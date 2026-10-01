Get-Service |
    Where-Object { $_.Status -eq 'Stopped'} |
    Select-Object Name, DisplayName, Status |
    Export-Csv -Path "C:\Projects\powershell-lab\data\report-stopped-services.csv" -NoTypeInformation