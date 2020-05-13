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
    type: string
    sql: ${TABLE}.state ;;
    drill_fields: [zip]
    map_layer_name: us_states
    link: {
      label: "By Zip"
      url: "
      {% assign vis= '{\"map_plot_mode\":\"points\",
      \"heatmap_gridlines\":false,
      \"heatmap_gridlines_empty\":false,
      \"heatmap_opacity\":0.5,
      \"show_region_field\":true,
      \"draw_map_labels_above_data\":true,
      \"map_tile_provider\":\"light\",
      \"map_position\":\"fit_data\",
      \"map_scale_indicator\":\"off\",
      \"map_pannable\":true,
      \"map_zoomable\":true,
      \"map_marker_type\":\"circle\",
      \"map_marker_icon_name\":\"default\",
      \"map_marker_radius_mode\":\"proportional_value\",
      \"map_marker_units\":\"meters\",
      \"map_marker_proportional_scale_type\":\"linear\",
      \"map_marker_color_mode\":\"fixed\",
      \"show_view_names\":false,
      \"show_legend\":true,
      \"quantize_map_value_colors\":false,
      \"reverse_map_value_colors\":false,
      \"type\":\"looker_map\",
      \"defaults_version\":1}' %}

      {% assign dynamic_fields= '[]' %}

      {{link}}&vis={{vis | encode_uri}}&dynamic_fields={{dynamic_fields | encode_uri}}"
    }
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

#   dimension: state_on_map{
#     description: "US States (Map)"
#     map_layer_name: us_states
#     sql: ${TABLE}.state ;;
#   }



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
    drill_fields: [first_name, last_name, gender, orders.count]
  }
################################################################################

  dimension: height_high {
    map_layer_name: us_states
    sql: ${TABLE}.state ;;
    drill_fields: [zip]
    link: {
      label: "link url"
      url:"{% assign vis_config= '{
        \"map_plot_mode\":\"po\"map_plot_mode\":\"points\",\"heatmap_gridlines\":false,\"heatmap_gridlines_empty\":false,\"heatmap_opacity\":0.5,\"show_region_field\":true,\"draw_map_labels_above_data\":true,\"map_tile_provider\":\"light\",\"map_position\":\"fit_data\",\"map_scale_indicator\":\"off\",\"map_pannable\":true,\"map_zoomable\":true,\"map_marker_type\":\"circle\",\"map_marker_icon_name\":\"default\",\"map_marker_radius_mode\":\"proportional_value\",\"map_marker_units\":\"meters\",\"map_marker_proportional_scale_type\":\"linear\",\"map_marker_color_mode\":\"fixed\",\"show_view_names\":false,\"show_legend\":true,\"quantize_map_value_colors\":false,\"reverse_map_value_colors\":false,\"type\":\"looker_map\",\"defaults_version\":1}' %}
        {{ dummy._link }}&vis_config={{ vis_config | encode_uri }}&toggle=dat,pik,vis&limit=5000&sorts=count+desc"
    }
  }


#   dimension: state {
#     description: "User State"
#     type: string
#     sql: ${TABLE}.state ;;
#   }

  measure: dummy { # Dummy measure added to generate drill link for dimension below. After copy from https://xin-looker.github.io/ Replace {{link}} with {{dummy._link}}
    type: number
    sql: 1=1 ;;
    drill_fields: [zip,count]  # drill fields for the custom link (Drill by Zip (...))
  }

  dimension: state_on_map{
    description: "US States (Map)"
    map_layer_name: us_states
    sql: ${TABLE}.state ;;
    drill_fields: [zip,count]
    link: {
      label: "Drill By Zip (Point Map)"   #
      url: "{% assign vis= '{
      \"map_plot_mode\":\"points\",
      \"heatmap_gridlines\":false,
      \"heatmap_gridlines_empty\":false,
      \"heatmap_opacity\":0.5,
      \"show_region_field\":true,
      \"draw_map_labels_above_data\":true,
      \"map_tile_provider\":\"light\",
      \"map_position\":\"fit_data\",
      \"map_scale_indicator\":\"off\",
      \"map_pannable\":true,
      \"map_zoomable\":true,
      \"map_marker_type\":\"circle\",
      \"map_marker_icon_name\":\"default\",
      \"map_marker_radius_mode\":\"proportional_value\",
      \"map_marker_units\":\"meters\",
      \"map_marker_proportional_scale_type\":\"linear\",
      \"map_marker_color_mode\":\"fixed\",
      \"show_view_names\":false,
      \"show_legend\":true,
      \"quantize_map_value_colors\":false,
      \"reverse_map_value_colors\":false,
      \"type\":\"looker_map\",
      \"defaults_version\":1}' %}

      {{dummy._link}}&vis={{ vis | encode_uri }}"
    }
    link: {
      label: "Drill By Zip (Column Chart)"
      url: "{% assign vis= '{\"x_axis_gridlines\":false,
            \"y_axis_gridlines\":true,
            \"show_view_names\":false,
            \"show_y_axis_labels\":true,
            \"show_y_axis_ticks\":true,
            \"y_axis_tick_density\":\"default\",
            \"y_axis_tick_density_custom\":5,
            \"show_x_axis_label\":true,
            \"show_x_axis_ticks\":true,
            \"y_axis_scale_mode\":\"linear\",
            \"x_axis_reversed\":false,
            \"y_axis_reversed\":false,
            \"plot_size_by_field\":false,
            \"trellis\":\"\",
            \"stacking\":\"\",
            \"limit_displayed_rows\":false,
            \"legend_position\":\"center\",
            \"point_style\":\"none\",
            \"show_value_labels\":false,
            \"label_density\":25,
            \"x_axis_scale\":\"auto\",
            \"y_axis_combined\":true,
            \"ordering\":\"none\",
            \"show_null_labels\":false,
            \"show_totals_labels\":false,
            \"show_silhouette\":false,
            \"totals_color\":\"#808080\",
            \"type\":\"looker_column\",
            \"map_plot_mode\":\"points\",
            \"heatmap_gridlines\":false,
            \"heatmap_gridlines_empty\":false,
            \"heatmap_opacity\":0.5,
            \"show_region_field\":true,
            \"draw_map_labels_above_data\":true,
            \"map_tile_provider\":\"light\",
            \"map_position\":\"fit_data\",
            \"map_scale_indicator\":\"off\",
            \"map_pannable\":true,
            \"map_zoomable\":true,
            \"map_marker_type\":\"circle\",
            \"map_marker_icon_name\":\"default\",
            \"map_marker_radius_mode\":\"proportional_value\",
            \"map_marker_units\":\"meters\",
            \"map_marker_proportional_scale_type\":\"linear\",
            \"map_marker_color_mode\":\"fixed\",
            \"show_legend\":true,
            \"quantize_map_value_colors\":false,
            \"reverse_map_value_colors\":false,
            \"defaults_version\":1,
            \"series_types\":{},
            \"show_null_points\":true,
            \"interpolation\":\"linear\"}' %}

            {{dummy._link}}&vis={{vis | encode_uri}}"
    }
  }


  dimension: zip {
    description: "User Zip Code"
    type: zipcode
    sql: ${TABLE}.zip ;;
  }

  measure: count {
    description: "Number of Users"
    type: count
    drill_fields: [id, zip, first_name, last_name, orders.count] # Just paste escaped vis from https://xin-looker.github.io/ in url parameter below
    link: {
      label: "Custom Drill in Measure"
      url: "{% assign vis= '{\"map_plot_mode\":\"points\",
            \"heatmap_gridlines\":false,
            \"heatmap_gridlines_empty\":false,
            \"heatmap_opacity\":0.5,
            \"show_region_field\":true,
            \"draw_map_labels_above_data\":true,
            \"map_tile_provider\":\"light\",
            \"map_position\":\"fit_data\",
            \"map_scale_indicator\":\"off\",
            \"map_pannable\":true,
            \"map_zoomable\":true,
            \"map_marker_type\":\"circle\",
            \"map_marker_icon_name\":\"default\",
            \"map_marker_radius_mode\":\"proportional_value\",
            \"map_marker_units\":\"meters\",
            \"map_marker_proportional_scale_type\":\"linear\",
            \"map_marker_color_mode\":\"fixed\",
            \"show_view_names\":false,
            \"show_legend\":true,
            \"quantize_map_value_colors\":false,
            \"reverse_map_value_colors\":false,
            \"type\":\"looker_map\",
            \"defaults_version\":1}' %}

            {{link}}&vis={{vis | encode_uri}}"
    }
  }






# Measures ##################################################################
## My Modifications


  measure: test_drillcount {
    description: "Number of Users"
    type: count
    drill_fields: [zip]
    link: {
      label: "Drill By Zip"
      url: "{% assign vis_config= '{
            \"map_plot_mode\":\"points\",
            \"heatmap_gridlines\":false,
            \"heatmap_gridlines_empty\":false,
            \"heatmap_opacity\":0.5,
            \"show_region_field\":true,
            \"draw_map_labels_above_data\":true,
            \"map_tile_provider\":\"light\",
            \"map_position\":\"fit_data\",
            \"map_scale_indicator\":\"off\",
            \"map_pannable\":true,
            \"map_zoomable\":true,
            \"map_marker_type\":\"circle\",
            \"map_marker_icon_name\":\"default\",
            \"map_marker_radius_mode\":\"proportional_value\",
            \"map_marker_units\":\"meters\",
            \"map_marker_proportional_scale_type\":\"linear\",
            \"map_marker_color_mode\":\"fixed\",
            \"show_view_names\":false,
            \"show_legend\":true,
            \"quantize_map_value_colors\":false,
            \"reverse_map_value_colors\":false,
            \"type\":\"looker_map\",
            \"defaults_version\":1}' %}
            {{link}}&vis_config={{ vis_config | encode_uri }}"
    }
    link: {
      label: "Drill By Zip"
      url: "{% assign vis_config= '{
            \"map_plot_mode\":\"points\",
            \"heatmap_gridlines\":false,
            \"heatmap_gridlines_empty\":false,
            \"heatmap_opacity\":0.5,
            \"show_region_field\":true,
            \"draw_map_labels_above_data\":true,
            \"map_tile_provider\":\"light\",
            \"map_position\":\"fit_data\",
            \"map_scale_indicator\":\"off\",
            \"map_pannable\":true,
            \"map_zoomable\":true,
            \"map_marker_type\":\"circle\",
            \"map_marker_icon_name\":\"default\",
            \"map_marker_radius_mode\":\"proportional_value\",
            \"map_marker_units\":\"meters\",
            \"map_marker_proportional_scale_type\":\"linear\",
            \"map_marker_color_mode\":\"fixed\",
            \"show_view_names\":false,
            \"show_legend\":true,
            \"quantize_map_value_colors\":false,
            \"reverse_map_value_colors\":false,
            \"type\":\"looker_map\",
            \"defaults_version\":1}' %}
            {{link}}&vis_config={{ vis_config | encode_uri }}"
    }
  }


##############################################################################
}
