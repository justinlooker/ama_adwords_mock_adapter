include: "/app_marketing_analytics_config/adwords_config.view"

include: "criteria_base.view"

explore: audience_adapter {
  extends: [criteria_joins_base]
  from: audience_adapter
  view_label: "Audience"
  view_name: criteria
  hidden: yes
}

view: audience_adapter {
  extends: [adwords_config, criteria_base]
  sql_table_name: {{ criteria.adwords_schema._sql }}.Audience_{{ criteria.adwords_customer_id._sql }} ;;

  dimension: criteria {
    label: "Audience"
  }

  dimension: user_list_name {
    type: string
    sql: ${TABLE}.UserListName ;;
  }
}
