view: order_items {
  sql_table_name: demo_db.order_items ;;
  drill_fields: [id]

  dimension: id {
    description: "Order Items ID"
    primary_key: yes
    type: number                                          # Dimension type 1 - Number
    sql: ${TABLE}.id ;;
  }

  dimension: inventory_item_id {
    description: "Inventory Item ID"
    type: number
    # hidden: yes
    sql: ${TABLE}.inventory_item_id ;;
  }

  dimension: order_id {
    description: "Order ID"
    type: number
    # hidden: yes
    sql: ${TABLE}.order_id ;;
  }

  dimension_group: returned {
    description: "Returned Time"
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
    description: "Sale Price"
    type: number
    value_format_name: eur
    sql: ${TABLE}.sale_price ;;
  }

# Dimensions ##################################################################
##   My Modifications
  dimension: profit {
    description: "Profit from order item"
    type: number
    value_format_name: eur
    sql: ${sale_price} - ${inventory_items.cost_in_euros} ;;
  }

  dimension: markup {
    description: "Markup on order item"
    type: number
    value_format_name: percent_2
    sql: ${profit}/${inventory_items.cost_in_euros} ;;
  }

  dimension: profit_margin {
    description: "Profit Margin on order item"
    type: number
    value_format_name: percent_2
    sql: ${profit}/${sale_price} ;;
  }
##############################################################################

# Measures ##################################################################
##   My Modifications
  measure: cheapest_item {
    type: min                                             # Measure type 1 - Min
    value_format_name: eur
    sql: ${sale_price} ;;
  }

  measure: most_costly_item {
    type: max                                             # Measure type 1 - Max
    value_format_name: eur
    sql: ${sale_price} ;;
  }

  measure: average_sale_price {
    type: average                                         # Measure type 2 - Average
    value_format_name: eur
    sql: ${sale_price} ;;
  }

  measure: total_sale_price {
    description: "Total Revenue in Euros"
    type: sum                                             # Measure type 3 - Sum
    value_format_name: eur
    sql: ${sale_price} ;;
  }

  measure: total_profit {
    description: "Total Profit in Euros"
    type: number                                          # Measure type 4 - Number
    value_format_name: eur
    sql: ${total_sale_price} - ${inventory_items.total_cost_in_euros} ;;
  }

  measure: median_order {
    description: "Median"
    type: median                                          # Measure type 5 - Median
    value_format_name: eur
    sql: ${sale_price} ;;
  }
##############################################################################

  measure: count {
    description: "Number of Order Items"
    type: count
    drill_fields: [id, orders.id, inventory_items.id, products.brand, products.category]
  }

}
