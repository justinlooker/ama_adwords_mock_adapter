include: "/app_marketing_analytics_config/adwords_config.view"

include: "criteria_base.view"

explore: parental_status_adapter {
  extends: [criteria_joins_base]
  from: parental_status_adapter
  view_label: "Parental Status"
  view_name: criteria
  hidden: yes
}

view: parental_status_adapter {
  extends: [adwords_config, criteria_base]
  sql_table_name: {{ criteria.adwords_schema._sql }}.ParentalStatus_{{ criteria.adwords_customer_id._sql }} ;;

  dimension: criteria {
    label: "Parental Status"
  }
}
