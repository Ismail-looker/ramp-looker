view: users {
  sql_table_name: demo_db.users ;;
  drill_fields: [id]

  dimension: id {
    description: "User ID"
    primary_key: yes
    type: number                                          # Dimension type 1 - Number
    sql: ${TABLE}.id ;;
  }

  dimension: age {
    description: "User Age"
    type: number
    sql: ${TABLE}.age ;;
  }

  dimension: city {
    description: "User City"
    type: string                                          # Dimension type 2 - String
    sql: ${TABLE}.city ;;
  }

  dimension: country {
    description: "User Country"
    type: string
    map_layer_name: countries
    sql: ${TABLE}.country ;;
  }

  dimension_group: created {
    description: "When User was created"
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

  dimension: email {
    description: "User E-mail"
    type: string
    sql: ${TABLE}.email ;;
  }

  dimension: first_name {
    description: "User Firstname"
    type: string
    sql: ${TABLE}.first_name ;;
  }

  dimension: gender {
    description: "User Gender"
    # type: string
    # sql:  ${TABLE}.gender;;
    case: {                                              # Dimension type 3 - Case
      when: {
        sql: ${TABLE}.gender = 'm';;
        label: "Male"
      }
      when: {
        sql: ${TABLE}.gender = 'f';;
        label: "Female"
      }
      else: "Other"
    }
  }

  dimension: last_name {
    description: "User Lastname"
    type: string
    sql: ${TABLE}.last_name ;;
  }

  dimension: state {
    description: "User State"
    type: string
    sql: ${TABLE}.state ;;
  }

# DIMENSIONS ##################################################################
##   My Modifications
  dimension: age_tier {                                  # Dimension type 4 - Tier
    description: "User Age Tier"
    type: tier
    tiers: [0, 10, 20, 30, 40, 50, 60, 70, 80]
    style: integer
    sql: ${age} ;;
  }

  dimension: full_name {
    description: "User Firstname + Surname"
    type: string
    sql: Concat(${first_name} , " " , ${last_name})  ;;
  }

  dimension: state_on_map{
    description: "US States (Map)"
    map_layer_name: us_states
    sql: ${TABLE}.state ;;
  }

  dimension: region {
    description: "User Region"
    case: {                                              # Dimension type 3 - Case
      when: {
        sql: ${state}
        IN (
          'Connecticut','Maine','New Hampshire','Massachusetts','New Jersey',
          'New York','Pennsylvania','Rhode Island','Vermont');;
      label: "Northeast"
      }
      when: {
        sql: ${state}
          IN (
            'Alaska','Arizona','California','Colorado','Hawaii','Idaho',
            'Montana','Nevada','New Mexico','Oregon','Utah','Washington','Wyoming') ;;
        label: "West"
      }
      when: {
        sql: ${state}
          IN (
            'Illinois','Indiana',
            'Iowa','Kansas','Michigan','Missouri','Minnesota','Nebraska',
            'North Dakota','Ohio','South Dakota','Wisconsin') ;;
        label: "Midwest"
      }
      when: {
        sql: ${state}
          IN (
            'Alabama','Arkansas','Delaware','Florida','Georgia','Kentucky',
            'Louisiana','Maryland','Mississippi','Oklahoma','North Carolina',
            'South Carolina','Tennessee','Texas','Virginia','West Virginia') ;;
        label: "South"
      }
      when: {
        sql: ${state}
          IN (
            'District of Columbia') ;;
        label: "District of Columbia"
      }
      else: "Other"
    }
  }
################################################################################

  dimension: zip {
    description: "User Zip Code"
    type: zipcode                                        # Dimension type 5 - Zipcode
    sql: ${TABLE}.zip ;;
  }

  measure: count {
    description: "Number of Users"
    type: count
    drill_fields: [id, first_name, last_name, orders.count]
  }

# Measures ##################################################################
## My Modifications



##############################################################################
}
