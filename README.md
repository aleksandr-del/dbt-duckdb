# dbt + DuckDB Learning Project

A lightweight dbt (data build tool) development environment using DuckDB as the database backend. Perfect for learning analytics engineering without the complexity of setting up a full database server.

## What is This?

This project demonstrates modern analytics engineering using:

- **dbt**: Transforms raw data into analytics-ready models using SQL
- **DuckDB**: Fast, embedded analytical database (no server required)
- **Jaffle Shop**: Classic e-commerce dataset for learning dbt concepts
- **Docker**: Containerized environment for consistent development

## Project Structure

```
├── jaffle_shop/                 # Main dbt project
│   ├── dbt.duckdb              # DuckDB database file (created after first run)
│   └── jaffle_shop/
│       ├── models/             # SQL transformation models
│       ├── seeds/              # CSV source data (not used - we preseed)
│       ├── tests/              # Data quality tests
│       ├── dbt_project.yml     # Project configuration
│       └── packages.yml        # dbt package dependencies
├── jaffle-shop-data/           # Downloaded CSV files for preseeding
├── .dbt/
│   └── profiles.yml            # Database connection config
├── docker-compose.yml          # Container orchestration
├── Dockerfile                  # dbt + DuckDB image
├── .env                        # Environment variables
├── initdb.py                   # Database preseeding script
├── start_ui_server.py          # DuckDB web UI server
└── download-jaffle-shop-data.py # CSV data download utility
```

## Quick Start

### 1. Fix Permissions

The Docker container runs as root, so fix ownership of the jaffle_shop directory:

```bash
cd ~/sandbox/dbt-duckdb
sudo chown -R $USER:$USER jaffle_shop/
```

### 2. Download Sample Data

Download the Jaffle Shop CSV files from GitHub:

```bash
python3 download-jaffle-shop-data.py
```

This creates `jaffle-shop-data/` with CSV files: `raw_customers.csv`, `raw_orders.csv`, `raw_payments.csv` and etc.

### 3. Start the Environment

```bash
docker compose up -d
```

### 4. Preseed Database

Load CSV data directly into DuckDB (instead of using `dbt seed`):

```bash
python3 initdb.py
```

This creates the `raw` schema and loads tables: `customers`, `orders`, `payments` and etc.

### 5. Run dbt Transformations

```bash
docker exec -it dbt dbt run --project-dir /usr/app/jaffle_shop
```

### 6. Run Tests

```bash
docker exec -it dbt dbt test --project-dir /usr/app/jaffle_shop
```

### 7. View Documentation

```bash
docker exec -it dbt dbt docs generate --project-dir /usr/app/jaffle_shop
docker exec -d dbt dbt docs serve --project-dir /usr/app/jaffle_shop --host 0.0.0.0
```

Then open: http://localhost:8080

## Python Helper Scripts

### download-jaffle-shop-data.py

Downloads CSV files from the official dbt Jaffle Shop repository on GitHub.

**What it does:**

- Fetches file list from GitHub API
- Downloads each CSV file to `jaffle-shop-data/` directory
- Handles HTTP errors and provides logging

**Usage:**

```bash
python3 download-jaffle-shop-data.py
```

### initdb.py

Preseeds the DuckDB database with raw data from CSV files.

**What it does:**

- Connects to `jaffle_shop/dbt.duckdb`
- Creates `raw` schema
- Loads each CSV file as a table (removes `raw_` prefix from filenames)
- Uses DuckDB's `read_csv_auto()` for automatic schema detection

**Usage:**

```bash
python3 initdb.py
```

**Note:** This replaces the need for `dbt seed` command.

### start_ui_server.py

Launches DuckDB's built-in web UI for database exploration.

**What it does:**

- Connects to the DuckDB database
- Starts web server on http://localhost:4213
- Keeps server running until interrupted (Ctrl+C)

**Usage:**

```bash
python3 start_ui_server.py
```

**⚠️ Important:** Stop the UI server before running dbt commands, as DuckDB doesn't support concurrent connections. Press Ctrl+C to stop.

## Understanding the Data Flow

The Jaffle Shop dataset simulates an e-commerce business with:

1. **Raw Data** (preseeded via `initdb.py`):
    - `raw.customers` - Customer information
    - `raw.orders` - Order transactions
    - `raw.payments` - Payment details

2. **Staging Models** (`/models/staging`):
    - Clean and standardize raw data
    - Apply basic transformations
    - One model per source table

3. **Mart Models** (`/models/marts`):
    - Business logic and metrics
    - Join multiple staging models
    - Create analytics-ready tables

## Key dbt Commands

### Development Workflow

```bash
# Interactive shell
docker exec -it dbt /bin/bash

# Install dependencies
dbt deps --project-dir /usr/app/jaffle_shop

# Run all models
dbt run --project-dir /usr/app/jaffle_shop

# Run specific model
dbt run --select customers --project-dir /usr/app/jaffle_shop

# Test data quality
dbt test --project-dir /usr/app/jaffle_shop

# Full refresh (rebuild everything)
dbt run --full-refresh --project-dir /usr/app/jaffle_shop
```

### Documentation & Exploration

```bash
# Generate docs
dbt docs generate --project-dir /usr/app/jaffle_shop

# Serve docs locally
dbt docs serve --host 0.0.0.0 --project-dir /usr/app/jaffle_shop

# Compile SQL (without running)
dbt compile --project-dir /usr/app/jaffle_shop

# Show model dependencies
dbt list --project-dir /usr/app/jaffle_shop
```

## Database Exploration Options

### Option 1: DuckDB Web UI

```bash
python3 start_ui_server.py
# Open http://localhost:4213
# Stop with Ctrl+C before running dbt commands
```

### Option 2: dbt Documentation

```bash
docker exec -d dbt dbt docs serve --project-dir /usr/app/jaffle_shop --host 0.0.0.0
# Open http://localhost:8080
```

## Environment Configuration

The `.env` file configures:

- `DBT_HOST_PROJECT_DIR`: Maps local project to container
- `DBT_HOST_PROFILES_FILE`: Database connection settings
- `DBT_WORKDIR`: Working directory inside container
- `DBT_SERVER_PORT`: Documentation server port (8080)

## Troubleshooting

### Permission Issues

```bash
# Fix ownership after container operations
sudo chown -R $USER:$USER jaffle_shop/
```

### Database Lock Issues

```bash
# Stop DuckDB UI before running dbt commands
# DuckDB doesn't support concurrent connections
```

### Container Issues

```bash
# Rebuild container
docker compose down
docker compose build --no-cache
docker compose up -d

# Check logs
docker logs dbt

# Access shell
docker exec -it dbt /bin/bash
```

### dbt Issues

```bash
# Clear compiled files
docker exec -it dbt dbt clean --project-dir /usr/app/jaffle_shop

# Debug connection
docker exec -it dbt dbt debug --project-dir /usr/app/jaffle_shop

# Check model compilation
docker exec -it dbt dbt compile --select model_name --project-dir /usr/app/jaffle_shop
```

## Workflow Summary

1. `python3 download-jaffle-shop-data.py` - Download CSV files
2. `sudo chown -R $USER:$USER jaffle_shop/` - Fix permissions
3. `docker compose up -d` - Start container
4. `python3 initdb.py` - Preseed database
5. `python3 start_ui_server.py` - Explore data (optional)
6. `docker exec -it dbt dbt run --project-dir /usr/app/jaffle_shop` - Run models
7. `docker exec -it dbt dbt test --project-dir /usr/app/jaffle_shop` - Test quality
8. `docker exec -d dbt dbt docs serve --project-dir /usr/app/jaffle_shop --host 0.0.0.0` - View docs
