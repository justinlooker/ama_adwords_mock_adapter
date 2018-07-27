include: "google_adwords_base.view"

explore: customer_join {
  extension: required

  join: customer {
    from: customer_adapter
    view_label: "Customer"
    sql_on: ${fact.external_customer_id} = ${customer.external_customer_id} AND
      ${customer.latest} ;;
    relationship: many_to_one
  }
}

explore: customer_adapter {
  persist_with: adwords_etl_datagroup
  from: customer_adapter
  view_name: customer
  hidden: yes
}

view: customer_adapter {
  extends: [google_adwords_base]

  derived_table: {
    sql:
        SELECT
          CURRENT_DATE() as _DATA_DATE,
          CURRENT_DATE() as _LATEST_DATE,
          'NA' as ExternalCustomerId,
        'NA' as AccountCurrencyCode,
        'NA' as AccountDescriptiveName,
        'NA' as AccountTimeZoneId,
        false as CanManageClients,
        'NA' as CustomerDescriptiveName,
        false as IsAutoTaggingEnabled,
        false as IsTestAccount,
        'NA' as PrimaryCompanyName
      ;;
  }

  dimension: account_currency_code {
    hidden: yes
    type: string
    sql: ${TABLE}.AccountCurrencyCode ;;
  }

  dimension: account_descriptive_name {
    hidden: yes
    type: string
    sql: ${TABLE}.AccountDescriptiveName ;;
    required_fields: [external_customer_id]
  }

  dimension: account_time_zone_id {
    hidden: yes
    type: string
    sql: ${TABLE}.AccountTimeZoneId ;;
  }

  dimension: can_manage_clients {
    hidden: yes
    type: yesno
    sql: ${TABLE}.CanManageClients ;;
  }

  dimension: customer_descriptive_name {
    hidden: yes
    type: string
    sql: ${TABLE}.CustomerDescriptiveName ;;
  }

  dimension: is_auto_tagging_enabled {
    hidden: yes
    type: yesno
    sql: ${TABLE}.IsAutoTaggingEnabled ;;
  }

  dimension: is_test_account {
    hidden: yes
    type: yesno
    sql: ${TABLE}.IsTestAccount ;;
  }

  dimension: primary_company_name {
    type: string
    sql: ${TABLE}.PrimaryCompanyName ;;
    required_fields: [external_customer_id]
  }
}
