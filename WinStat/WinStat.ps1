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
"{0}  ({1})" -f $windows.Caption, $windows.Version

try {
    (Get-ADUser $env:USERNAME)
}
catch {
    Write-Warning "User could not be found because Active Directory does not exist."
}
$user = "Logged On $(get-date) as $((Get-Item env:\username).Value) on computer $((Get-Item env:\Computername).Value)"
Write-Host ""
$user
Write-Host ""
Write-Host "User           :" $env:USERNAME
Write-Host "SID            :" $env:USERSID
Write-Host "Home           :" $env:HOMEPATH
Write-Host "Machine        :" $env:COMPUTERNAME
Write-Host "Domain         :" $env:USERDOMAIN
Write-Host "Roamingprofile :" $env:USERDOMAIN_ROAMINGPROFILE
Write-Host "Userprofile    :" $env:USERPROFILE
Write-Host "LogonServer    :" $env:LOGONSERVER

(Get-WmiObject win32_networkadapterconfiguration -filter "ipenabled = 'True'" -ComputerName localhost | Select PSComputername,
@{Name = "IPAddress";Expression = {
[regex]$ipv4 = "(\d{1,3}(\.?)){4}"
$ipv4.matches($_.IPAddress).Value}},MACAddress)
$ipv4