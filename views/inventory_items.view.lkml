view: inventory_items {
  sql_table_name: demo_db.inventory_items ;;
  drill_fields: [id]

  dimension: id {
    description: "Inventory Item ID"
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension: cost_in_euros {
    description: "Cost of Inventory Item (€)"
    type: number
    value_format_name: eur
    sql: ${TABLE}.cost ;;

  }

  dimension_group: created {
    description: "When Inventory Item was created"
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
    sql: ${TABLE}.created_at ;;
  }

  dimension: product_id {
    description: "Inventory Item Product ID"
    type: number
    # hidden: yes
    sql: ${TABLE}.product_id ;;
  }

  dimension_group: sold {
    description: "When Inventory Item was sold"
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
    sql: ${TABLE}.sold_at ;;
  }

  measure: total_cost_in_euros {
    description: "Total cost of Inventory Items in Euros"
    type: sum
    value_format_name: eur
    sql: ${TABLE}.cost;;
    drill_fields: [id, created_date, products.item_name, products.id, products.brand, products.category]
  }

  measure: count {
    description: "Number of Inventory Items"
    type: count
    drill_fields: [id, products.item_name, products.id, products.brand, products.category]
  }
}
