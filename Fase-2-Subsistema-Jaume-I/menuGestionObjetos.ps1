#Variables globales
$domain="dc=IESJaume-I,dc=mylocal"
#
#Funciones en la cabecera del script
#

function Show-Menu
{
     param (
           [string]$Titulo = 'MenÃº principal'
     )
     Clear-Host
     Write-Host "================ $Titulo ================"
    
     Write-Host "1: OpciÃ³n '1' Crear UOs."
     Write-Host "2: Opción  '2' Crear Equipos."
     Write-Host "3: OpciÃ³n '3' Crear Grupos."
     Write-Host "4: OpciÃ³n '4' Crear Usuarios."
     Write-Host "Q: OpciÃ³n 'Q' Salir."
}
function alta_UOs
{
     $ficheroCsvUO=Read-Host "Introduce el fichero csv de UO's:"
     $ficheroImportado = import-csv -Path $ficheroCsvUO -delimiter *
     foreach($line in $ficheroImportado)
     {
          New-ADOrganizationalUnit -Description:$line.Description -Name:$line.Name `
		-Path:$line.Path -ProtectedFromAccidentalDeletion:$true 
     }
     Write-Host "Se han creado las UOs satisfactoriamente en el dominio $domain"
}
function alta_grupos
{
     	$gruposCsv=Read-Host "Introduce el fichero csv de Grupos:"
	$ficheroImportado = import-csv -Path $gruposCsv -delimiter *
	foreach($linea in $ficheroImportado)
	{
		if ( !(Get-ADGroup -Filter 'name -eq "$linea.Name"' ) )
		{
			New-ADGroup -Name:$linea.Name -Description:$linea.Description `
			-GroupCategory:$linea.Category `
			-GroupScope:$linea.Scope  `
			-Path:$linea.Path
		}	
		else { Write-Host "El grupo $line.Name ya existe en el sistema"}
	}
 	 Write-Host "Se han creado las grupos satisfactoriamente en el dominio $domain"
     
}
function alta_usuarios
{
	$fileUsersCsv=Read-Host "Introduce el fichero csv de los usuarios:"
	$ficheroImportado = import-csv -Path $fileUsersCsv -Delimiter *				     
	foreach($linea in $ficheroImportado)
	{
		$passAccount=ConvertTo-SecureString $linea.Password -AsPlainText -force
		$Surnames=$linea.Surname1+' '+$linea.Surname2
		$nameLarge=$linea.Name+' '+$linea.Surname1+' '+$linea.Surname2
		$email=$linea.Email
		[boolean]$Habilitado=$true
    		If($linea.Enabled -Match 'N') { $Habilitado=$false}
		#Establecer los dÃ­as de expiraciÃ³n de la cuenta (Columna del csv ExpirationAccount)
   		$ExpirationAccount = $linea.TurnPassDays
    		$timeExp = (get-date).AddDays($ExpirationAccount)
		#
		# Ejecutamos el comando para crear el usuario
		#
		New-ADUser -SamAccountName $linea.Account -UserPrincipalName $linea.Account -Name $linea.Account `
			-Surname $Surnames -DisplayName $nameLarge -GivenName $linea.Name -LogonWorkstations:$linea.Computer `
			-Description "Cuenta de $nameLarge" -EmailAddress $email `
			-AccountPassword $passAccount -Enabled $Habilitado `
			-CannotChangePassword $false -ChangePasswordAtLogon $true `
			-PasswordNotRequired $false -Path $linea.Path -AccountExpirationDate $timeExp `
		
  		#
  		## Establecer horario de inicio de sesiÃ³n       
                $horassesion = $linea.NetTime -replace(" ","")
                net user $linea.Account /times:$horassesion 
		
  		#Asignar cuenta de Usuario a Grupo
		# Distingued Name CN=Nombre-grupo,ou=..,ou=..,dc=..,dc=...
		#En este caso el grupo se encuentra en la misma UO que el usuario
                $cnGrpAccount=$linea.Group
		Add-ADGroupMember -Identity $cnGrpAccount -Members $linea.Account
		
	}     
}


#Primero comprobaremos si se tiene cargado el mÃ³dulo Active Directory
if (!(Get-Module -Name ActiveDirectory)) #AccederÃ¡ al then solo si no existe una entrada llamada ActiveDirectory
{
  Import-Module ActiveDirectory #Se carga el mÃ³dulo
}
function alta_equipos {
#
#CreaciÃ³n de los grupos a partir de un fichero csv
#
#Lee el fichero grupos.csv. El carÃ¡cter delimitador de columna es :
$equiposCsv=Read-Host "Introduce el fichero csv de Equipos:"
$fichero= import-csv -Path $equiposCsv -delimiter "*"

foreach($line in $fichero)
{
	#Comprobamos que no exista el equipo en el sistema
	if ( !(Get-ADComputer -Filter 'name -eq "$line.Computer"' ) )
	{
		New-ADComputer -Enabled:$true -Name:$line.Computer -Path:$line.Path -SamAccountName:$line.Computer
	}
	else { Write-Host "El equipo $line.Computer ya existe en el sistema"}
}

write-Host ""
write-Host "Se han creado los equipos en el dominio $domain" -Fore green
write-Host "" 
}

#
#MENU PRINCIPAL
#
do
{
     Show-Menu
     $input = Read-Host "Por favor, pulse una opciÃ³n"
     switch ($input)
     {
           '1' {
                Clear-Host
                alta_UOs
           } '2' {
                Clear-Host
                alta_equipos
           } '3' {
                Clear-Host
                alta_grupos
           } '4' {
                Clear-Host
                alta_usuarios
           } 'q' {
                'Salimos de la App'
                return
           }
     }
     pause
}
until ($input -eq 'q')

