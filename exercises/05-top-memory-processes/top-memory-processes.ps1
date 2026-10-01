Get-Process |
    Sort-Object WorkingSet64 -Descending |
    Select-Object         ProcessName,
        Id,
        @{Name='MemoryMB'; Expression={[math]::Round($_.WorkingSet64 / 1MB , 2)}} |
    Select-Object -First 10 