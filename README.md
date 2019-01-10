Scripts to quickly setup AD and populate it with unique users.

Run Powershell as administrator on a new installation of Windows Server (Tested on 2008, 2012, 2016, 2019).

~~~
.\1-install-adds.ps1
.\2-populate.ps1
~~~

Local administrator account will have it's password set to Password123. Change the password or disable this account after installation of AD.