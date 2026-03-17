# Installing Terraform on Windows

This guide provides step-by-step instructions to install Terraform on Windows using different methods. Terraform is an infrastructure as code tool by HashiCorp.

## Method 1: Using winget (Recommended - No Admin Required)

Winget is the Windows Package Manager, available on Windows 10 (version 1709 or later) and Windows 11.

### Step 1: Verify winget Installation
Open PowerShell and run:
```powershell
winget --version
```
If you see a version number, winget is installed. If not, update Windows or install the App Installer from the Microsoft Store.

### Step 2: Install Terraform
Run the following command in PowerShell:
```powershell
winget install HashiCorp.Terraform
```
This will download and install Terraform to your user directory.

### Step 3: Verify Installation
After installation, restart your PowerShell terminal or run:
```powershell
$env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")
terraform --version
```
You should see output like: `Terraform v1.x.x on windows_amd64`

## Method 2: Using Chocolatey

Chocolatey is a package manager for Windows. This method requires administrator privileges.

### Step 1: Install Chocolatey
Open PowerShell as Administrator and run:
```powershell
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
```

### Step 2: Install Terraform
```powershell
choco install terraform
```

### Step 3: Verify Installation
Restart PowerShell and run:
```powershell
terraform --version
```

## Method 3: Manual Download and Installation

If package managers are not available or preferred.

### Step 1: Download Terraform
1. Go to the [Terraform downloads page](https://www.terraform.io/downloads.html).
2. Download the Windows AMD64 ZIP file.

### Step 2: Extract the Archive
Extract the ZIP file to a directory, e.g., `C:\Terraform` or `%USERPROFILE%\Terraform`.

### Step 3: Add to PATH
1. Right-click on "This PC" or "My Computer" > Properties > Advanced system settings > Environment Variables.
2. Under "User variables" or "System variables", find "Path", click Edit.
3. Add the path to the Terraform directory (e.g., `C:\Terraform`).
4. Click OK to save.

### Step 4: Verify Installation
Open a new PowerShell or Command Prompt and run:
```cmd
terraform --version
```

## Updating Terraform

### Using winget:
```powershell
winget upgrade HashiCorp.Terraform
```

### Using Chocolatey:
```powershell
choco upgrade terraform
```

### Manual:
Download the latest version and replace the executable.

## Troubleshooting

- If `terraform` command is not recognized, ensure the PATH is updated and restart your terminal.
- For permission issues, try running PowerShell as Administrator.
- Check the official [Terraform documentation](https://www.terraform.io/docs/cli/install/index.html) for more details.</content>
<parameter name="filePath">Terraform_Installation_Windows.md