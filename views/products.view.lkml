view: products {
  sql_table_name: demo_db.products ;;
  drill_fields: [id]

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension: brand {
    type: string
    sql: ${TABLE}.brand ;;
  }

  dimension: category {
    type: string
    sql: ${TABLE}.category ;;
  }

  dimension: department {
    type: string
    sql: ${TABLE}.department ;;
  }

  dimension: item_name {
    type: string
    sql: ${TABLE}.item_name ;;
    link: {
      label: "Google Search"
      url: "http://www.google.com/search?q={{ value }}"
      icon_url: "http://google.com/favicon.ico"
    }
  }

  dimension: rank {
    type: number
    sql: ${TABLE}.rank ;;
  }

  dimension: retail_price {
    type: number
    sql: ${TABLE}.retail_price ;;
  }

## DIMENSIONS ##################################################################
  dimension: retail_price_tier {
    description: "Retail Price Tiers"
    type: tier
    tiers: [0, 10, 20, 30, 40, 50, 60, 70, 80]
    style: integer
    sql: ${retail_price} ;;
  }

################################################################################

  dimension: sku {
    type: string
    sql: ${TABLE}.sku ;;
    link: {
      label: "Google"
      url: "http://www.google.com/search?q={{ value }}"
      icon_url: "http://google.com/favicon.ico"
    }
  }

  measure: count {
    type: count
    drill_fields: [id, item_name, inventory_items.count]
  }
## Measures ##################################################################
  measure: total_cost {
    description: "Total Product Cost in Euros "
    type: sum_distinct
    sql_distinct_key: ${inventory_items.id} ;;
    value_format_name: eur
    sql: ${inventory_items.cost_in_euros};;
    drill_fields: [products.brand, products.category,products.departments, inventory_items.count]
  }


##############################################################################
}
