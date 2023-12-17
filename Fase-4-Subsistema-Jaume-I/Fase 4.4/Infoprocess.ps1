$date= Get-Date
"Fecha: $date" | out-file C:\Logs\infoProcess.dat -append
"Procesos consumiendo mas de 25MB de memoria virtual" | out-file C:\Logs\infoProcess.dat -append
Get-process | where {$_.virtualmemorysize -gt 250000000} | out-file C:\Logs\infoProcess.dat -append
"Procesos consumiendo mas de 50MB de memoria para trabajar" | out-file C:\Logs\infoProcess.dat -append
get-process | where {$_.WS -gt 50MB} | out-file C:\Logs\infoProcess.dat -append
"Procesos consumiendo mas del 5% de la CPU" | out-file C:\Logs\infoProcess.dat -append
Get-process | where-object {$_.CPU -gt 5} | out-file C:\Logs\infoProcess.dat -append
"Procesos activos" | out-file C:\Logs\infoProcess.dat -append
Get-process | Measure-object | out-file C:\Logs\infoProcess.dat -append
