# Git Repository Manager
<#
.SYNOPSIS
    A PowerShell script to manage Git repositories: clone, pull, or push changes.

.DESCRIPTION
    This script helps manage Git repositories using the Git CLI.
    It provides options to clone a repository, pull the latest changes, or push local changes to a remote repository.

.PARAMETER Action
    The action to perform: Clone, Pull, or Push.

.PARAMETER Repository
    The repository URL for cloning or the path for Pull/Push.

.PARAMETER Branch
    The branch to checkout or interact with (optional for Clone and Pull).

.EXAMPLE
    PS> ./GitRepoManager.ps1 -Action Clone -Repository "https://github.com/user/repo.git"
    
    Clones the specified repository.

.EXAMPLE
    PS> ./GitRepoManager.ps1 -Action Pull -Repository "C:\Repos\MyRepo"
    
    Pulls the latest changes from the default branch.

.EXAMPLE
    PS> ./GitRepoManager.ps1 -Action Push -Repository "C:\Repos\MyRepo" -Branch "main"
    
    Pushes changes to the specified branch.
#>

param (
    [Parameter(Mandatory=$true)]
    [ValidateSet("Clone", "Pull", "Push")]
    [string]$Action,

    [Parameter(Mandatory=$true)]
    [string]$Repository,

    [Parameter(Mandatory=$false)]
    [string]$Branch
)

# Check if Git is installed
if (-not (Get-Command "git" -ErrorAction SilentlyContinue)) {
    Write-Error "Git CLI is not installed. Please install Git to use this script."
    exit
}

# Perform the action
switch ($Action) {
    "Clone" {
        Write-Host "Cloning repository from URL: $Repository" -ForegroundColor Green
        git clone $Repository
        if ($LASTEXITCODE -eq 0) {
            Write-Host "Repository cloned successfully!" -ForegroundColor Cyan
        } else {
            Write-Error "Failed to clone the repository."
        }
    }
    "Pull" {
        if (-not (Test-Path $Repository)) {
            Write-Error "The specified repository path does not exist: $Repository"
            exit
        }
        Write-Host "Pulling latest changes for repository at: $Repository" -ForegroundColor Green
        Set-Location $Repository
        git pull
        if ($LASTEXITCODE -eq 0) {
            Write-Host "Successfully pulled latest changes!" -ForegroundColor Cyan
        } else {
            Write-Error "Failed to pull changes."
        }
    }
    "Push" {
        if (-not (Test-Path $Repository)) {
            Write-Error "The specified repository path does not exist: $Repository"
            exit
        }
        if (-not $Branch) {
            Write-Error "Please specify the branch to push changes to using the -Branch parameter."
            exit
        }
        Write-Host "Pushing changes for repository at: $Repository to branch: $Branch" -ForegroundColor Green
        Set-Location $Repository
        git push origin $Branch
        if ($LASTEXITCODE -eq 0) {
            Write-Host "Changes pushed successfully!" -ForegroundColor Cyan
        } else {
            Write-Error "Failed to push changes."
        }
    }
    default {
        Write-Error "Invalid action specified. Use Clone, Pull, or Push."
    }
}

# Reset location to avoid issues
Set-Location -Path (Get-Location).Path
