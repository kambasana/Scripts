# Define the username and password
$username = "your_username"
$password = "your_password"

# Define the URL of the Fieldglass login page
$url = "https://www.fieldglass.eu/jobs"

# Open a new instance of Chrome and navigate to the login page
$chromePath = "C:\Program Files (x86)\Google\Chrome\Application\chrome.exe"
$arguments = "-url `"$url`" --auto-open-devtools-for-tabs --disable-infobars"
Start-Process -FilePath $chromePath -ArgumentList $arguments

# Wait for Chrome to finish loading the page
Start-Sleep -Seconds 5

# Send the username and password to the login form
$ie = New-Object -ComObject "InternetExplorer.Application"
$ie.Visible = $false
$ie.Navigate($url)

while ($ie.Busy) { Start-Sleep -Milliseconds 100 }

$usernameField = $ie.Document.getElementsByName("j_username") | Select-Object -First 1
$passwordField = $ie.Document.getElementsByName("j_password") | Select-Object -First 1

$usernameField.value = $username
$passwordField.value = $password

$submitButton = $ie.Document.getElementsByTagName("button") | Where-Object { $_.innerText -eq "Log In" }
$submitButton.Click()

# Wait for the login process to complete
Start-Sleep -Seconds 5

# Close the Internet Explorer COM object
$ie.Quit()
