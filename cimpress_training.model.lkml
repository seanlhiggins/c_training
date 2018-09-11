connection: "events_ecommerce"

# include all the views
include: "*.view"
include: "business_pulse*.dashboard.lookml"

datagroup: cimpress_training_default_datagroup {
  sql_trigger: SELECT MAX(id) FROM cimpress_etl_logs;;
  max_cache_age: "24 hours"
}

#
# datagroup: cimpress_events_real_time {
#   max_cache_age: "0 hours"
# }
#
#
# persist_with: cimpress_training_default_datagroup
# #####something
#


explore: distribution_centers {}

explore: etl_jobs {}


explore: order_items {
  persist_for: "0 hours"
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


  join: user_orders_facts {
    view_label: "Lifetime Orders"
    type: left_outer
    sql_on: ${users.id} = ${user_orders_facts.order_items_user_id} ;;
    relationship: one_to_one
  }

  join: products {
    relationship: many_to_one
    sql_on: ${products.id} = ${inventory_items.product_id} ;;
  }
  join: repeat_purchase_facts {
    relationship: many_to_one
    type: full_outer
    sql_on: ${order_items.order_id} = ${repeat_purchase_facts.order_id} ;;
  }
}


#######

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
