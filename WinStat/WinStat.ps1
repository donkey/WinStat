<#
  WinStat.ps1 windows client connection status
  Version 1.0.1 (12.03.2017) by DonMatteo
  Mail: think@unblog.ch
  Blog: think.unblog.ch
#>
$windows = [PSCustomObject]@{
	Caption = (Get-WmiObject -Class Win32_OperatingSystem).Caption
	Version = [Environment]::OSVersion.Version
	User = [Environment]::UserName
	Domain = [Environment]::UserDomainName
	Machine = [Environment]::MachineName
}
$winver = "{0}  ({1})" -f $windows.Caption, $windows.Version
$winver
try {
    (Get-ADUser $env:USERNAME)
}
catch {
    Write-Warning "User could not be found because Active Directory does not exist."
}
$user = "Logged On $(get-date) as $((Get-Item env:\username).Value) on computer $((Get-Item env:\Computername).Value)"
$user
Write-Host "
User           : $env:USERNAME
SID            : $env:USERSID
Home path      : $env:HOMEPATH
Computer       : $env:COMPUTERNAME
AD Domain      : $env:USERDOMAIN
Roamingprofile : $env:USERDOMAIN_ROAMINGPROFILE
Userprofile    : $env:USERPROFILE
LogonServer    : $env:LOGONSERVER
"
(Get-WmiObject win32_networkadapterconfiguration -filter "ipenabled = 'True'" -ComputerName $windows.Machine | Select PSComputername,
	@{Name = "IPAddress";Expression = {
	[regex]$ipv4 = "(\d{1,3}(\.?)){4}"
	$ipv4.matches($_.IPAddress).Value}},MACAddress)
$ipv4