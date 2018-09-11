view: user_orders_facts {
  derived_table: {
    sql: SELECT
        order_items.user_id  AS "order_items.user_id",
        COUNT(*) AS "order_items.count",
        COALESCE(SUM(order_items.sale_price ), 0) AS "order_items.total_sale_price"
      FROM public.order_items  AS order_items

      GROUP BY 1
      ORDER BY 2 DESC
       ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension: order_items_user_id {
    primary_key: yes
    hidden: yes
    type: number
    sql: ${TABLE}."order_items.user_id" ;;
  }

  measure: lifetime_orders {
    type: sum
    sql: ${TABLE}."order_items.count" ;;
  }

  measure: average_lifetime_value {
    type: average
    sql: ${TABLE}."order_items.total_sale_price" ;;
  }

  set: detail {
    fields: [order_items_user_id, lifetime_orders, average_lifetime_value]
  }
}
