# Output date
Write-Host Get-Date

# Exit immediately if a command exits with a non-zero status
$ErrorActionPreference = "Stop"

# Capture start time
$start_time = Get-Date
Write-Host "Starting the data pipeline."

# Cleanup function to deactivate virtual environment and stop Docker
function Cleanup {
    Write-Host "Deactivating virtual environment..."
    if ($env:VIRTUAL_ENV) {
        deactivate
    }
    
    Write-Host "Stopping Docker container..."
    docker-compose down
    
    Write-Host "Data pipeline execution completed!"
    $end_time = Get-Date
    $execution_time = $end_time - $start_time
    Write-Host "scraper status: $scraper_status"
    Write-Host "Total execution time: $execution_time"
}
# Ensures cleanup runs when the script exits
$null = Register-EngineEvent PowerShell.Exiting -Action { Cleanup }

# Navigate to the project directory
Set-Location -Path "C:\your\project\directory"  # Adjust this to your project path

# Start Docker container
Write-Host "Starting Docker container..."
docker-compose up -d

# Wait for the container to be fully up
Start-Sleep -Seconds 3

# Activate virtual environment
Write-Host "Activating virtual environment..."
$env:VIRTUAL_ENV = "C:\path\to\myenv"  # Adjust to your virtual environment path
$env:PATH = "$env:VIRTUAL_ENV\Scripts;$env:PATH"  # Add virtualenv to PATH
& "$env:VIRTUAL_ENV\Scripts\Activate.ps1"  # Activate virtual environment

Start-Sleep -Seconds 3

# Run the first Python script (scraping YouTube comments)
Write-Host "Running YouTube comment scraper..."
python youtube_comment_scraper.py
$scraper_status = $?

if ($scraper_status -eq 0) {
    Write-Host "Scraper executed successfully. Proceeding with analysis."
    
    # Run the second Python script (analyzing emotions)
    Write-Host "Running emotion analysis..."
    python get_emotion.py
    
    # Wait to ensure data is stored
    Start-Sleep -Seconds 3
} else {
    Write-Host "Scraper failed. Skipping analysis and proceeding to cleanup."
    exit 1
}
