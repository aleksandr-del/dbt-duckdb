from itertools import groupby
from operator import itemgetter

from duckdb import DuckDBPyConnection, DuckDBPyRelation


def model(dbt, session: DuckDBPyConnection) -> DuckDBPyRelation:
    dbt.config(materialized="table")
    cte: DuckDBPyRelation = dbt.ref("int_orders_items_products_joined")
    col_names: list[str] = [col[0] for col in cte.description]
    data: list[dict[str, str | int | float]] = [dict(zip(col_names, row)) for row in cte.fetchall()]
    get_order: itemgetter = itemgetter("OrderId")
    sorted_data: list[dict[str, str | int | float]] = sorted(data, key=get_order)
    grouped_data: groupby = groupby(sorted_data, key=get_order)
    sql_str: str = ", ".join(
        f"({orderid}, {round(sum(row['Price'] for row in group), 2)})"
        for orderid, group in grouped_data
    )

    relation: DuckDBPyRelation = session.sql(
        f"SELECT col0 AS OrderId, col1 AS Revenue FROM (VALUES {sql_str})"
    )

    return relation
