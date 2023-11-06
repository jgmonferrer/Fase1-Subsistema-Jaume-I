#Primero comprobaremos si se tiene cargado el mÃ³dulo Active Directory
if (!(Get-Module -Name ActiveDirectory)) #AccederÃ¡ al then solo si no existe una entrada llamada ActiveDirectory
{
  Import-Module ActiveDirectory #Se carga el mÃ³dulo
}
#Listar los usuarios del dominio smr.local
Write-Host Equipos -Fore green 
Get-ADComputer -filter * -SearchBase "dc=IESJaume-I,dc=mylocal" | Select Name
