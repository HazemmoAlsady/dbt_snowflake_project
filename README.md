# %%writefile setup_pipeline.sh
# RUN THIS IN A BASH CELL IN JUPYTER OR IN TERMINAL

#!/bin/bash

echo "🚀 Starting end-to-end data pipeline setup..."

# Step 1: Clone the repo
echo "📦 Cloning GitHub repository..."
git clone https://github.com/ansamAY/dbt_snowflake_project.git
cd dbt_snowflake_project || exit

# Step 2: Create and activate Python virtual environment
echo "🧪 Creating virtual environment..."
python -m venv venv
source venv/bin/activate

# Step 3: Upgrade pip and install dependencies
echo "⬇️ Installing dbt-snowflake and Apache Airflow..."
pip install --upgrade pip
pip install dbt-snowflake apache-airflow

# Step 4: Configure dbt profiles.yml
echo "⚙️ Setting up dbt profile for Snowflake..."
mkdir -p ~/.dbt

cat <<EOF > ~/.dbt/profiles.yml
snowflake_project:
  outputs:
    dev:
      type: snowflake
      account: xy12345.us-east-1  # 🔁 REPLACE with your Snowflake account
      user: dbt_user              # 🔁 REPLACE
      password: your_password     # 🔁 REPLACE
      role: ACCOUNTADMIN
      database: finance_db        # 🔁 REPLACE if needed
      warehouse: finance_wh       # 🔁 REPLACE
      schema: raw
      threads: 4
  target: dev
EOF

echo "✅ dbt profile written to ~/.dbt/profiles.yml"

# Step 5: Test dbt connection
echo "🔍 Testing dbt connection to Snowflake..."
dbt debug || echo "⚠️ dbt debug failed – check your Snowflake credentials!"

# Step 6: Run dbt models
echo "🏗️ Running dbt models..."
dbt run

# Step 7: Run dbt tests
echo "🧪 Running dbt tests..."
dbt test

# Step 8: Initialize and start Airflow
echo "🔄 Starting Apache Airflow (standalone mode)..."
export AIRFLOW_HOME=$(pwd)
airflow db init  # Initialize Airflow DB
airflow users create \
    --username admin \
    --firstname Admin \
    --lastname User \
    --role Admin \
    --email admin@example.com \
    --password admin  # Change in production!

# Start Airflow standalone (runs UI + scheduler)
echo "🌐 Airflow will start at http://localhost:8080"
echo "🔑 Login with username: admin, password: admin"
airflow standalone
