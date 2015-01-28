#vib script to file 

function CreateHostObject
{
$HostObject = New-Object System.Object
Add-Member -MemberType NoteProperty -Name host -Value "" -InputObject $HostObject
Add-Member -MemberType NoteProperty -Name AcceptanceLevel -Value "" -InputObject $HostObject
Add-Member -MemberType NoteProperty -Name ID -Value "" -InputObject $HostObject
Add-Member -MemberType NoteProperty -Name InstallDate -Value "" -InputObject $HostObject
Add-Member -MemberType NoteProperty -Name Name -Value "" -InputObject $HostObject
Add-Member -MemberType NoteProperty -Name ReleaseDate -Value "" -InputObject $HostObject
Add-Member -MemberType NoteProperty -Name Status -Value "" -InputObject $HostObject
Add-Member -MemberType NoteProperty -Name Vendor -Value "" -InputObject $HostObject
Add-Member -MemberType NoteProperty -Name Version -Value "" -InputObject $HostObject
$HostObject
}


Function ConnectToVSphere
{
Connect-VIServer #ServerName | Out-Null
}

if ((Get-PSSnapin | Where-Object { $_.Name -eq "VMware.DeployAutomation"}) -eq $null ) {Add-PSSnapIn VMware.DeployAutomation}
if ((Get-PSSnapin | Where-Object { $_.Name -eq "VMware.ImageBuilder"}) -eq $null ) {Add-PSSnapIn VMware.ImageBuilder}
if ((Get-PSSnapin | Where-Object { $_.Name -eq "VMware.VimAutomation.Cloud"}) -eq $null ) {Add-PSSnapIn VMware.VimAutomation.Cloud}
if ((Get-PSSnapin | Where-Object { $_.Name -eq "VMware.VimAutomation.Core"}) -eq $null ) {Add-PSSnapIn VMware.VimAutomation.Core}
if ((Get-PSSnapin | Where-Object { $_.Name -eq "VMware.VimAutomation.License"}) -eq $null ) {Add-PSSnapIn VMware.VimAutomation.License}

Write-Host "Connecting to vSphere ..."
ConnectToVSPhere

$hostList = @()
Write-Host "Getting list of hosts from vSphere ..."
$AllHosts = Get-VMHost | Where {$_.ConnectionState -eq “Connected”}
foreach ($VMHost in $AllHosts)
{
$ESXCLI = Get-EsxCli -VMHost $VMHost
Write-Host "Getting host: $vmhost drivers from vSphere ..."
$hostDrivers = $ESXCLI.software.vib.list() | Select AcceptanceLevel,ID,InstallDate,Name,ReleaseDate,Status,Vendor,Version
foreach ($driver in $hostDrivers)
{
$hostObject = createhostobject
$hostObject.host = $vmhost
$hostObject.AcceptanceLevel = $driver.AcceptanceLevel
$hostObject.ID = $driver.ID
$hostObject.InstallDate = $driver.InstallDate
$hostObject.Name = $driver.Name
$hostObject.ReleaseDate = $driver.ReleaseDate
$hostObject.Status = $driver.Status
$hostObject.Vendor = $driver.Vendor
$hostObject.Version = $driver.Version
$hostList += $hostObject
}
}

$hostList | export-csv c:\hostdrivers.csv  -Force -NoTypeInformation
