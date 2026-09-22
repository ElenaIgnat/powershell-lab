$employees = Import-Csv ".\data\employees.csv"

$report = $employees | 
    Where-Object { $_.Department -eq "IT" } |
    Select-Object Name , Username, Department

$report | Export-Csv ".\data\it-employees.csv"  -NoTypeInformation

