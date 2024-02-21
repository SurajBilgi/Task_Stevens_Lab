#!/bin/bash
# Author: Suraj S Bilgi
# Masters in Applied AI, Stevens Institute of Technology

# Setting up the desired PostgreSQL version
POSTGRES_VERSION="latest"

# Set the container name
CONTAINER_NAME="stevens_postgres"

# Set the PostgreSQL default user and password
POSTGRES_USER="postgres"
POSTGRES_PASSWORD="suraj" 

# Pull the official PostgreSQL image from Docker Hub
echo "Pulling the official PostgreSQL Docker image..."
docker pull postgres:$POSTGRES_VERSION

# Launch a Docker container running PostgreSQL
echo "Launching a Docker container running PostgreSQL..."
docker run --name $CONTAINER_NAME -e POSTGRES_PASSWORD=$POSTGRES_PASSWORD -d -p 5432:5432 postgres:$POSTGRES_VERSION

# Wait for PostgreSQL to start
echo "Waiting for PostgreSQL to start..."
sleep 5 # Adjust based on your system speed

# Copy the CSV file into the Docker container
echo "Copying the CSV file into the Docker container..."
docker cp /mnt/data/IBM.csv $CONTAINER_NAME:/IBM.csv

echo "Setup completed."



# Defining and Setting up the Database connection parameters
DB_NAME="IBM_data"
DB_USER="postgres"
DB_PASSWORD="suraj"
DB_HOST="localhost"
DB_PORT="5432"
FILE_PATH = 'IBM.csv'

# Data Import task: Started
echo "Data import task Started."

# Starting the Postgres Docker image
PGPASSWORD='suraj' psql -h $DB_HOST -U $DB_USER -p $DB_PORT -d postgres <<EOF

-- Creating the Database named: stevens_ibm_task 
CREATE DATABASE stevens_ibm_task;

-- Establishing the Connection to the Database
\c stevens_ibm_task postgres;

-- Creating the Table name and giving the Column names
CREATE TABLE IF NOT EXISTS ibm_test (item_id TEXT,ibes_ticker TEXT,estimator TEXT,analyst_code TEXT,canadian_currency TEXT,primary_diluted_flag TEXT,forecast_period_indicator TEXT,measure TEXT,forecast_period_end_date TEXT,forecast_value TEXT,activation_date TEXT,activation_time TEXT,review_date TEXT,review_time TEXT,announce_date TEXT,announce_time TEXT,currency TEXT,origin_file_name TEXT,origin_file_period TEXT);

-- Importing the IBM.csv file to the Database Table
\COPY ibm_test(item_id,ibes_ticker,estimator,analyst_code,canadian_currency,primary_diluted_flag,forecast_period_indicator,measure,forecast_period_end_date,forecast_value,activation_date,activation_time,review_date,review_time,announce_date,announce_time,currency,origin_file_name,origin_file_period) FROM $FILE_PATH WITH (FORMAT csv, HEADER true);

-- Printing the Table
SELECT * FROM ibm_test LIMIT 5;

EOF

echo "Data import task complete."

echo "Data Analysis Starts"
python EDA.py