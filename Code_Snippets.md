# CODE Snippets


#### Testing NULL comparison with boolean column [SQL](https://discourse.looker.com/t/type-yesno-returns-null-values-as-no/2618/10)
<pre><code>
SELECT * from
  (
    SELECT NULL as field
    UNION ALL
    SELECT 1 as field
    UNION ALL  <br>
    SELECT NULL as field
  )
  as test where field is NULL

  # NOT field = NULL
</code></pre>

<br>
#### Parameters [LookML](https://looker-internal.skilljar.com/intro-to-parameters-and-templated-filters/235559)
<pre><code>
parameter: sale_price_metric_picker {
description: "Use with the Sale Price Metric measure"
type: unquoted
allowed_value: {
  label: "Total Sale Price"
  value: "SUM"
}
allowed_value: {
  label: "Average Sale Price"
  value: "AVG"
}
allowed_value: {
  label: "Maximum Sale Price"
  value: "MAX"
}
allowed_value: {
  label: "Minimum Sale Price"
  value: "MIN"
}
}


measure: sale_price_metric {
  type: number
  sql: {% sale_price_metric_picker %}(${sale_price}) ;;
}

Because we are using type:unquoted, we can dictate that our Measure will end up as

`sql:MIN(${sale_price});; ` or as  `sql:MAX(${sale_price});; `
</code></pre>

<br>
#### Templated Filters [LookML](https://looker-internal.skilljar.com/intro-to-parameters-and-templated-filters/235611)
<pre><code>
filter: category_count_picker {
type: string
suggest_explore: order_items_warehouse
suggest_dimension: products.category
}

measure: category_count {
  type: sum
  sql:
    CASE
      WHEN {% condition category_count_picker %} ${products.category} {% endcondition %}
      THEN 1
      ELSE 0
    END
  ;;
}
</code></pre>
