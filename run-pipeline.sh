#!/bin/bash

# Output date
date

# Exit immediately if a command exits with a non-zero status
set -e  

start_time=$(date +%s) # Capture start time
echo "Starting the data pipeline."

# Cleanup function to deactivate virtual environment and stop Docker
cleanup() {
    echo "Deactivating virtual environment..."
    deactivate || true  # Ensure deactivation doesn't cause errors if not active
    
    echo "Stopping Docker container..."
    sudo docker compose down
    
    echo "Data pipeline execution completed!"
    end_time=$(date +%s) # Capture end time
    execution_time=$(( end_time - start_time )) # Capture duration
    echo "scraper status: $scraper_status"
    echo "Total execution time: $execution_time seconds"
}
trap cleanup EXIT  # Ensures cleanup runs when the script exits

# Navigate to the project directory
cd /path/to/your/directory || { echo "Failed to change directory"; exit 1; } # Write the path to your directory

# Start Docker container
echo "Starting Docker container..."
sudo docker compose up -d

# Wait for the container to be fully up
sleep 3

# Activate virtual environment
echo "Activating virtual environment..."
source myenv/bin/activate # Change myenv to your venv name

sleep 3

# Run the first Python script (scraping YouTube comments)
echo "Running YouTube comment scraper..."
python youtube_comment_scraper.py
scraper_status=$?

if [ $scraper_status -eq 0 ]; then
	echo "Scraper executed successfully. Proceeding with analysis."
    
    	# Run the second Python script (analyzing emotions)
    	echo "Running emotion analysis..."
    	python get_emotion.py
    
    	# Wait to ensure data is stored
    	sleep 3
else
    	echo "Scraper failed. Skipping analysis and proceeding to cleanup."
    	exit 1
fi
