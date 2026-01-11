from duckdb import DuckDBPyConnection, DuckDBPyRelation


def model(dbt, session: DuckDBPyConnection) -> DuckDBPyRelation:
    dbt.config(materialized="table")
    cte: DuckDBPyRelation = dbt.ref("int_orders_items_products_joined")
    cte_aggr: DuckDBPyRelation = cte.aggregate(
        aggr_expr="OrderId, round(sum(Price), 2) AS Revenue",
        group_expr="OrderId"
    )
    orders: DuckDBPyRelation = dbt.ref("stg_furniture_mart_orders")
    final_df: DuckDBPyRelation = cte_aggr.join(
        other_rel=orders,
        condition="OrderId",
        how="inner"
    )

    return final_df.project(
        (
            "OrderId, OrderPlacedTimestamp, UpdatedAt, "
            "OrderStatus, SalesPerson, Revenue"
        )
    )
