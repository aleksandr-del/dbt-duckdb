#!/usr/bin/env python3

import logging
import time

import duckdb


def main() -> None:
    logging.basicConfig(
        level=logging.INFO,
        format="%(levelname)s - [%(asctime)s] - %(name)s - %(message)s",
        style="%",
    )
    logger = logging.getLogger(__name__)

    conn = duckdb.connect("jaffle_shop/dbt.duckdb")
    conn.execute("CALL start_ui_server()")
    logger.info("🌐 UI started: http://localhost:4213\n")

    try:
        while True:
            time.sleep(60)
    except KeyboardInterrupt:
        logger.info("Stopped Duckdb UI ...")
    finally:
        conn.close()


if __name__ == "__main__":
    main()
