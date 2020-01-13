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

#### Templated Filters [LookML]
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
