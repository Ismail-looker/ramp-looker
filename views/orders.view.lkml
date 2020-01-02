view: orders {
  sql_table_name: demo_db.orders ;;
  drill_fields: [id]

  dimension: id {
    description: "Orders ID"
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension_group: created {
    description: "Time Order was created"
    type: time                                          # Dimension type 7 - Time
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

  dimension: status {
    description: "Status of the Order"
    type: string
    sql: ${TABLE}.status ;;
  }

  dimension: user_id {
    description: "User ID"
    type: number
    # hidden: yes
    sql: ${TABLE}.user_id ;;
  }

  dimension: is_order_complete {
    type: yesno                                          # Dimension type 6 - YesNo
    sql: ${status} = 'complete';;
  }

  measure: count {
    description: "Number of Orders"
    type: count
    drill_fields: [id, created_date, products.item_name, users.id, users.first_name, users.last_name, users.email]
  }
}
