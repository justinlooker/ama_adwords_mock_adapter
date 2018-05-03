include: "/app_marketing_analytics_config/adwords_config.view"

include: "criteria_base.view"

explore: gender_adapter {
  extends: [criteria_joins_base]
  from: gender_adapter
  view_label: "Gender"
  view_name: criteria
  hidden: yes
}

view: gender_adapter {
  extends: [adwords_config, criteria_base]
  sql_table_name: {{ criteria.adwords_schema._sql }}.Gender_{{ criteria.adwords_customer_id._sql }} ;;

  dimension: criteria {
    label: "Gender"
  }
}
