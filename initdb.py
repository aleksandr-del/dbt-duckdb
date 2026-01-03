#!/usr/bin/env python3

import logging
from pathlib import Path

import duckdb


def main() -> None:
    logging.basicConfig(
        level=logging.INFO,
        format="%(levelname)s - [%(asctime)s] - %(name)s - %(message)s",
        style="%",
    )
    logger = logging.getLogger(__name__)
    schema_name = "raw"
    conn = duckdb.connect("jaffle_shop/dbt.duckdb")
    logger.info("Connected to dbt.db ...")
    conn.execute(f"CREATE SCHEMA IF NOT EXISTS {schema_name}")
    logger.info(f"Created schema {schema_name}")
    data_dir = Path("raw-data")

    for csv_file in data_dir.glob("*.csv"):
        table_name = csv_file.stem.split("_")[1]
        conn.execute(
            f"""
            CREATE OR REPLACE TABLE {schema_name}.{table_name} AS
            SELECT * FROM read_csv_auto('{csv_file}')
            """
        )
        logger.info("✅ Loaded table %s", table_name)

    conn.close()
    logger.info("Done preseeding DB")


if __name__ == "__main__":
    main()
