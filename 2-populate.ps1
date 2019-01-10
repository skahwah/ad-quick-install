# 2-populate.ps1
# Written by: Sanjiv Kawa
# @kawabungah

$DNName=Get-ADDomain | select -ExpandProperty DistinguishedName
$ForestName=Get-ADDomain | select -ExpandProperty Forest
$Import=Import-CSV ".\users.csv" -Delimiter ";"

#Create OUs
dsadd ou "OU=Executive,$DNName" -desc "Executive Organizational Unit"
dsadd ou "OU=Finance,$DNName" -desc "Finance Group Organizational Unit"
dsadd ou "OU=Marketing,$DNName" -desc "Marketing Group Organizational Unit"
dsadd ou "OU=Operations,$DNName" -desc "Operations Group Organizational Unit"
dsadd ou "OU=IT,$DNName" -desc "IT Group Organizational Unit"
dsadd ou "OU=Sales,$DNName" -desc "Sales Group Organizational Unit"
dsadd ou "OU=Research,$DNName" -desc "Research Group Organizational Unit"
 
Foreach ($user in $Import)
{
 $pass = $user.Password | ConvertTo-SecureString -AsPlainText -Force
 $path = "OU=" + $user.Department + "," + $DNName
 $upn = $user.email + "@" + $ForestName
 
 $props = @{
    Name = $user.Name 
    GivenName = $user.FirstName 
    Surname = $user.LastName 
    SamAccountName = $user.email
    Path = $path 
    AccountPassword = $pass 
    PasswordNeverExpires = $True 
    ChangePasswordAtLogon = $False 
    UserPrincipalName = $upn 
    EmailAddress = $upn 
    Department = $user.Department 
    Description = $user.Department 
    OfficePhone = $user.Telephone 
    Enabled = $True
 }
 New-ADUser @props -PassThru

}

#Add users in the IT group into domain admins 
$path = "OU=IT," + $DNName
Get-ADUser -SearchBase $path -Filter * | Add-ADGroupMember -Identity "Domain Admins"
