Get-WinEvent -LogName System |
    Where-Object { $_.LevelDisplayName -eq 'Error' } |
    Sort-Object TimeCreated -Descending |
    Select-Object -First 10 TimeCreated, ID, ProviderName, Message  