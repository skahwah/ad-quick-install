# 1-install-adds.ps1
# Written by: Sanjiv Kawa
# @kawabungah

# disable password complexity
secedit /export /cfg c:\secpol.cfg
(gc C:\secpol.cfg).replace("PasswordComplexity = 1", "PasswordComplexity = 0") | Out-File C:\secpol.cfg
secedit /configure /db c:\windows\security\local.sdb /cfg c:\secpol.cfg /areas SECURITYPOLICY
rm -force c:\secpol.cfg -confirm:$false

# the administrator account needs a non-blank password
net user administrator Password123
net user administrator /active:yes

# install ad and tools
Add-WindowsFeature RSAT-ADDS-Tools
install-windowsfeature AD-Domain-Services
Import-Module ADDSDeployment
Import-Module ServerManager

$password = (ConvertTo-SecureString -AsPlainText -Force -String "Password123")

# install new forest and domain
Install-ADDSForest -CreateDnsDelegation:$false -DatabasePath "C:\Windows\NTDS" -DomainMode Default -DomainName "lab.local" -DomainNetbiosName "LAB" -ForestMode Default -InstallDns:$true -LogPath "C:\Windows\NTDS" -NoRebootOnCompletion:$false -SysvolPath "C:\Windows\SYSVOL" -SafeModeAdministratorPassword: $password -Force:$true

# re-enable password complexity
secedit /export /cfg c:\secpol.cfg
(gc C:\secpol.cfg).replace("PasswordComplexity = 1", "PasswordComplexity = 0") | Out-File C:\secpol.cfg
secedit /configure /db c:\windows\security\local.sdb /cfg c:\secpol.cfg /areas SECURITYPOLICY
rm -force c:\secpol.cfg -confirm:$false
