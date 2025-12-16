#!/usr/bin/env python3

import logging
import os

import requests


def main() -> None:
    logging.basicConfig(
        level=logging.INFO,
        format="%(levelname)s - [%(asctime)s] - %(name)s - %(message)s",
        style="%",
    )
    logger = logging.getLogger(__name__)

    dir_name = "jaffle-data"
    os.makedirs(dir_name, exist_ok=True)

    url = "https://api.github.com/repos/dbt-labs/jaffle-shop/contents/seeds/jaffle-data"
    response = requests.get(url)
    files = None
    try:
        response.raise_for_status()
        files = response.json()
    except requests.exceptions.HTTPError as err:
        logger.error("HTTP-error: %s", err)
        return
    except requests.exceptions.JSONDecodeError as err:
        logger.error("JSON decode error: %s", err)
        return

    if files is not None:
        for file in files:
            logger.info(
                "Starting to download %s from %s", file["name"], file["download_url"]
            )
            try:
                file_response = requests.get(file["download_url"])
                file_response.raise_for_status()
                with open(f"{dir_name}/{file['name']}", mode="wb") as f:
                    f.write(file_response.content)
                    logger.info("Saved file %s at %s", file["name"], dir_name)
            except requests.exceptions.HTTPError as err:
                logger.error("Failed to download %s: %s", file["name"], err)
                return

        logger.info("Done downloading files")


if __name__ == "__main__":
    main()
