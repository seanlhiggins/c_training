connection: "events_ecommerce"

# include all the views
include: "*.view"

datagroup: cimpress_training_default_datagroup {
  # sql_trigger: SELECT MAX(id) FROM etl_log;;
  max_cache_age: "1 hour"
}

persist_with: cimpress_training_default_datagroup

explore: distribution_centers {}

explore: etl_jobs {}

explore: order_items {
  label: "(1) Orders, Items and Users"
  view_name: order_items
  # sql_always_where: ${created_week} = TO_CHAR(DATE_TRUNC('week', DATE_ADD('day',-{{order_items.week_selector._parameter_value}},CURRENT_DATE)),'YYYY-MM-DD') ;;

  join: inventory_items {
    #Left Join only brings in items that have been sold as order_item
    type: full_outer
    relationship: one_to_one
    sql_on: ${inventory_items.id} = ${order_items.inventory_item_id} ;;
  }

  join: users {
    relationship: many_to_one
    sql_on: ${order_items.user_id} = ${users.id} ;;
  }

  join: products {
    relationship: many_to_one
    sql_on: ${products.id} = ${inventory_items.product_id} ;;
  }
}
explore: events {
  description: "This is an expensive Explore, don't touch unless your name is Sean"
  join: users {
    type: left_outer
    sql_on: ${events.user_id} = ${users.id} ;;
    relationship: many_to_one
  }
}

explore: foo {}

explore: inventory_items {
  join: products {
    type: left_outer
    sql_on: ${inventory_items.product_id} = ${products.id} ;;
    relationship: many_to_one
  }

  join: distribution_centers {
    type: left_outer
    sql_on: ${products.distribution_center_id} = ${distribution_centers.id} ;;
    relationship: many_to_one
  }
}






explore: products {
  join: distribution_centers {
    type: left_outer
    sql_on: ${products.distribution_center_id} = ${distribution_centers.id} ;;
    relationship: many_to_one
  }
}

explore: users {

}
