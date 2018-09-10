view: order_items {
  sql_table_name: public.order_items ;;

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  # dimension: pseudo_primary_key {
  #   primary_key: yes
  #   hidden: yes
  #   sql: ${created_date_date} || ${user_id} ;;
  # }


  dimension_group: created_date {

    type: time
    timeframes: [
      raw,
      time,time_of_day, hour_of_day,
      date,day_of_week,
      week,week_of_year,
      month,month_name,
      quarter,
      year
    ]
    sql: ${TABLE}.created_at ;;
  }

  dimension_group: delivered {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.delivered_at ;;
  }

  dimension: inventory_item_id {
    type: number
    # hidden: yes
    sql: ${TABLE}.inventory_item_id ;;
  }

  dimension: order_id {
    type: number
    sql: ${TABLE}.order_id ;;
  }

  dimension_group: returned {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.returned_at ;;
  }

  dimension: sale_price {
    type: number
    sql: ${TABLE}.sale_price ;;
  }

  dimension_group: shipped {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.shipped_at ;;
  }

  dimension: status {
    type: string
    sql: ${TABLE}.status ;;
  }

  dimension: user_id {
    type: number
    # hidden: yes
    sql: ${TABLE}.user_id ;;
  }


####### Measures Below Here

  measure: count {
    type: count
    drill_fields: [detail*]
    link: {
      url: "/dashboards/8/State=f['users.state']"
      label: "Users Dashboard"
    }
  }

  measure: total_sale_price {
    type: sum
    sql: ${sale_price} ;;
    drill_fields: [measure_drill_fields*]
  }

  measure: total_revenue_for_users_under_35 {
    description: "Total Revenue for users who are under 35, revenue is summed, no ex-vat filter"
    type: sum
    sql: ${sale_price} ;;
    drill_fields: [measure_drill_fields*]
    filters: {
      field: users.is_user_under_35
      value: "yes"
    }
  }
  measure: total_orders_new_users {
    type: count
    filters: {
      field: users.is_new_user
      value: "yes"
    }
  }
  measure: count_distinct_inventory_item_ids {
    type: count_distinct
    sql: ${inventory_item_id} ;;
    sql_distinct_key: ${order_id} ;;
  }

  measure: sum_distinct_sale_price {
    sql: ${sale_price} ;;
    type: average_distinct
  }


  dimension: profit {
    type: number
    value_format_name: usd
    sql: ${sale_price} -
      ${inventory_items.cost} ;;
  }

  measure: total_profit {
    sql: ${profit} ;;
    type: sum
  }

  # ----- Sets of fields for drilling ------
  set: measure_drill_fields {
    fields: [created_date_date,count,inventory_item_id,user_id]
  }

  set: detail {
    fields: [
      id,
      users.id,
      users.first_name,
      users.last_name,
      inventory_items.id,
      users.state,
      inventory_items.product_name
    ]
  }
}
