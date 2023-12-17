$date= Get-Date
"Fecha: $date" | out-file C:\Logs\Infoprocess.dat -append
"Procesos consumiendo mas de 25MB de memoria virtual" | out-file C:\Logs\Infoprocess.dat -append
Get-process | where {$_.virtualmemorysize -gt 500000000} | out-file C:\Logs\Infoprocess.dat -append
"Procesos consumiendo mas de 50MB de memoria para trabajar" | out-file C:\Logs\Infoprocess.dat -append
get-process | where {$_.WS -gt 50MB} | out-file C:\Logs\Infoprocess.dat -append
"Procesos consumiendo mas del 5% de la CPU" | out-file C:\Logs\Infoprocess.dat -append
Get-process | where-object {$_.CPU -gt 5} | out-file C:\Logs\Infoprocess.dat -append

