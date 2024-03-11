# Define the URL of the Fieldglass login page
$url = "https://www.fieldglass.eu/jobs"

# Open a new instance of Edge and navigate to the login page
$edgePath = "C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe"
$arguments = "--url `"$url`""
Start-Process -FilePath $edgePath -ArgumentList $arguments

# Wait for Edge to finish loading the page
Start-Sleep -Seconds 5

# Send the username and password to the login form
$username = "your_username"
$password = "your_password"

$ie = New-Object -ComObject "InternetExplorer.Application"
$ie.Visible = $false
$ie.Navigate($url)

while ($ie.Busy) { Start-Sleep -Milliseconds 100 }

$usernameField = $ie.Document.getElementsByName("username") | Select-Object -First 1
$passwordField = $ie.Document.getElementsByName("password") | Select-Object -First 1

$usernameField.value = $username
$passwordField.value = $password

$submitButton = $ie.Document.getElementsByTagName("button") | Where-Object { $_.innerText -eq "Submit" }
$submitButton.Click()

# Wait for the login process to complete
Start-Sleep -Seconds 5

# Close the Internet Explorer COM object
$ie.Quit()
