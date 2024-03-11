# Define the URL of the Fieldglass login page
$url = "https://www.fieldglass.eu/jobs"

# Open a new instance of Edge and navigate to the login page
$edgePath = "C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe"
$arguments = "--url `"$url`""
Start-Process -FilePath $edgePath -ArgumentList $arguments

# Wait for Edge to finish loading the page
Start-Sleep -Seconds 5

# Send the username and password to the login form
$ie = New-Object -ComObject "WScript.Shell"

# Wait for the username field to be available
Start-Sleep -Seconds 5

$ie.SendKeys("USERNAME")
$ie.SendKeys("{TAB}")
$ie.SendKeys("PASS")
$ie.SendKeys("{TAB}")
$ie.SendKeys("{ENTER}")

# Wait for the login process to complete
Start-Sleep -Seconds 5
