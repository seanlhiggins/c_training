
view: users {
  sql_table_name: public.users ;;

  dimension: id {
    primary_key: yes
    hidden: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension: age {
    group_label: "Age Dimensions"
    label: "Age of User"
    type: number
    sql: ${TABLE}.age ;;
  }


  dimension: age_tier {
    group_label: "Age Dimensions"
    type: tier
    sql: ${age} ;;
    tiers: [20,40,60,80]
    style: integer
  }

  dimension: is_user_under_35 {
    group_label: "Age Dimensions"
    type: yesno
    sql: ${age} < 35 ;;
  }

  dimension: is_new_user {
    type: yesno
    sql: DATEDIFF(day,${created_date},CURRENT_DATE) < 21 ;;
  }


  dimension: city {
    type: string
    sql: ${TABLE}.city ;;
  }

  dimension: country {
    type: string
    map_layer_name: countries
    sql: ${TABLE}.country ;;
  }

  dimension_group: created {
    type: time
    timeframes: [
      raw,
      time,
      date,day_of_week,day_of_year,
      week,week_of_year,
      month,month_name,
      quarter,
      year
    ]
    sql: ${TABLE}.created_at ;;
  }
  dimension_group: system {
    description: "current timestamp"
    type: time
    datatype: timestamp
    sql: GETDATE();;
  }
  dimension: email {
    type: string
    sql: ${TABLE}.email ;;
  }

  dimension: first_name {
    type: string
    sql: ${TABLE}.first_name ;;
  }

  dimension: gender {
    type: string
    sql: ${TABLE}.gender ;;
  }

  dimension: last_name {
    type: string
    sql: ${TABLE}.last_name ;;
  }

  dimension: latitude {
    type: number
    sql: ${TABLE}.latitude ;;
  }

  dimension: longitude {
    type: number
    sql: ${TABLE}.longitude ;;
  }

  dimension: state {
    type: string
    sql: ${TABLE}.state ;;
  }

  dimension: traffic_source {
    type: string
    sql: ${TABLE}.traffic_source ;;
  }

  dimension: zip {
    type: zipcode
    sql: ${TABLE}.zip ;;
  }

  measure: average_age {
    type: average
    sql: ${age} ;;
  }

  measure: count {
    type: count
    drill_fields: [id, first_name, last_name, events.count, order_items.count]
  }
}
