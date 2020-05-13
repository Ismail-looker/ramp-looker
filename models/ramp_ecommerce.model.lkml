connection: "thelook"

# include all the views
include: "/views/**/*.view"

datagroup: ramp_ecommerce_default_datagroup {
  # sql_trigger: SELECT MAX(id) FROM etl_log;;
  max_cache_age: "1 hour"
}

persist_with: ramp_ecommerce_default_datagroup

# 1. Order Items Explore (Orders, Inventory Items, Users, Products)
explore: order_items {
  label: "Order Items (Ramp)"
  view_label: "Order Items"                                   # Explore parameter 1 - view_label
  sql_always_where: ${orders.created_date} >= '2017-01-01' ;; # Explore parameter 2 - sql_always_where
#   always_filter: {                                            # Explore parameter 3 - always_filter
#     filters: {
#       field: orders.is_order_complete
#       value: "yes"
#     }
#   }
  fields: [ALL_FIELDS*]                           # Explore parameter 4 - fields

  join: orders {
    type: left_outer                                          # Join parameter 1 - type
    sql_on: ${order_items.order_id} = ${orders.id} ;;
    relationship: many_to_one                                 # Join parameter 2 - relationship
  }

  join: inventory_items {
    type: left_outer
    sql_on: ${order_items.inventory_item_id} = ${inventory_items.id} ;;
    relationship: many_to_one
  }

  join: users {
    type: left_outer
    sql_on: ${orders.user_id} = ${users.id} ;;
    relationship: many_to_one
  }

  join: products {
    type: left_outer
    sql_on: ${inventory_items.product_id} = ${products.id} ;;
    relationship: many_to_one
  }
}

# 2. Inventory Items Explore (Products)
explore: inventory_items {
  label: "Inventory Items (Ramp)"
  view_label: "Inventory Items"

  join: products {
    type: left_outer
    sql_on: ${inventory_items.product_id} = ${products.id} ;;
    relationship: many_to_one
  }
}

# 3. Orders Explore (Users)
explore: orders {
  label: "Orders (Ramp)"
  view_label: "Orders"

  join: users {
    type: left_outer
    sql_on: ${orders.user_id} = ${users.id} ;;
    relationship: many_to_one
  }
}

# Products Explore
explore: products {
  label: "Products (Ramp)"

  join: inventory_items {
    type: left_outer
    sql_on: ${products.id} = ${inventory_items.product_id};;
    relationship: one_to_many
  }
}

# User data Explore (Users)
explore: user_data {
  label: "User Data (Ramp)"
  view_label: "User Data"

  join: users {
    type: left_outer
    sql_on: ${user_data.user_id} = ${users.id} ;;
    relationship: many_to_one
    fields: [                                                # Join parameter 3 - fields
      users.created_date,
      users.full_name,
      users.email,
      users.age,
      users.gender,
      users.state_on_map
    ]
  }
}

# Users Explore
explore: users {
  label: "Users (Ramp)"
}

# Events Explore (Users)
explore: events {
  hidden: yes
  label: "Events (Ramp)"
  view_label: "Events"

  join: users {
    type: left_outer
    fields: [users.created_date]
    sql_on: ${events.user_id} = ${users.id} ;;
    relationship: many_to_one
  }
}

explore: customer_facts {
  hidden: yes
  join: orders {
    relationship: many_to_many
    sql_on: ${customer_facts.user_id}=${orders.user_id} ;;
  }
}
