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


  dimension: order_items_user_id {
    primary_key: yes
    hidden: yes
    type: number
    sql: ${TABLE}.order_items.user_id ;;

  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }


  dimension: order_items_count {
    type: number
    sql: ${TABLE}."order_items.count" ;;
  }

  dimension: order_items_total_sale_price {
    type: number
    sql: ${TABLE}."order_items.total_sale_price" ;;
  }

  measure: lifetime_orders {
    type: sum
    sql: ${TABLE}."orders_items.count" ;;

  }

  set: detail {
    fields: [order_items_user_id, order_items_count, order_items_total_sale_price]
  }
}
