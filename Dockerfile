FROM python:3.11-slim

RUN apt-get update -qq && \
    pip install --no-cache-dir dbt-core dbt-duckdb

WORKDIR /usr/app

CMD ["dbt", "--version"]
