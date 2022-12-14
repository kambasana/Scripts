# Powershell Script to Move Outlook OST to New Location 22-11-22
# Script modified from James J - Right Size Solutions

function ConvertFrom-Hexa($hexstring)
{
    ($hexstring.Split(",",[System.StringSplitOptions]::RemoveEmptyEntries) | ?{$_ -gt '0'} | ForEach{[char][int]"$($_)"}) -join ''
}

Function ConvertTo-Hexa($str)
{
    $ans = ''
    [System.Text.Encoding]::Unicode.GetBytes($str + "`0")
}
# Set Path to move OST - server paths would be "\\servername\Users$"
$newBasePath = "D:\OST\Users$"
$username = [Environment]::UserName

#find key that has the 001f6610 property that holds the OST file path - one key per outlook profile.
$name = '001f6610'
$keys = @( (Get-ChildItem "HKCU:\Software\Microsoft\Office\16.0\Outlook\Profiles\" -Recurse | Where-Object {$_.Property -eq $name}).name )
$keys
foreach($key in $keys)
{
write-host $key -foregroundcolor green
$key = $key.Replace("HKEY_CURRENT_USER\","HKCU:\")
write-host $key -foregroundcolor green

$value = (get-itemproperty -path $key -name $name).$name
$value2 = (Get-ItemProperty -path $key | Select -ExpandProperty $name) -join ','

$oldValue = ConvertFrom-Hexa $value2
write-host "Old Value for OST File was:  $oldValue" -foregroundcolor Yellow
#make sure it is an OST in this field
if($oldValue.substring($oldValue.length - 4,4) -eq ".ost")
{

$oldFilenameParts = $oldValue.split("\")
$oldFilename = $oldFilenameParts[$oldFilenameParts.Count - 1]

$new = "$newBasePath\$username\$oldFilename"
$newBin = ConvertTo-Hexa($new)
$newBin2 = $newBin -join ','
$newBin2Str = ConvertFrom-Hexa $newBin2
write-host "New Value for OST file (encoded and decoded) is: $newBin2Str" -foregroundcolor Yellow

write-host "About to change value in registry..." -foregroundcolor RED
set-ItemProperty -path $key -name $name -value $newBin
}
}
