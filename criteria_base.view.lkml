include: "ad_group.view"
include: "google_adwords_base.view"

explore: criteria_joins_base {
  extension: required
  hidden: yes
  view_name: criteria

  join: ad_group {
    from: ad_group_adapter
    view_label: "Ad Groups"
    sql_on: ${criteria.ad_group_id} = ${ad_group.ad_group_id} AND
      ${criteria.campaign_id} = ${ad_group.campaign_id} AND
      ${criteria.external_customer_id} = ${ad_group.external_customer_id} AND
      ${criteria._date} = ${ad_group._date} ;;
    relationship: many_to_one
  }
  join: campaign {
    from: campaign_adapter
    view_label: "Campaign"
    sql_on: ${criteria.campaign_id} = ${campaign.campaign_id} AND
      ${criteria.external_customer_id} = ${campaign.external_customer_id} AND
      ${criteria._date} = ${campaign._date};;
    relationship: many_to_one
  }
  join: customer {
    from: customer_adapter
    view_label: "Customer"
    sql_on: ${criteria.external_customer_id} = ${customer.external_customer_id} AND
      ${criteria._date} = ${customer._date} ;;
    relationship: many_to_one
  }
}

view: criteria_base {
  extension: required
  extends: [google_adwords_base]

  dimension: ad_group_id {
    sql: ${TABLE}.AdGroupId ;;
    hidden:  yes
  }

  dimension: base_ad_group_id {
    sql: ${TABLE}.BaseAdGroupId ;;
    hidden:  yes
  }

  dimension: base_campaign_id {
    sql: ${TABLE}.BaseCampaignId ;;
    hidden:  yes
  }

  dimension: bid_modifier {
    type: number
    sql: ${TABLE}.BidModifier ;;
    hidden:  yes
  }

  dimension: bid_type {
    type: string
    sql: ${TABLE}.BidType ;;
    hidden:  yes
  }

  dimension: campaign_id {
    sql: ${TABLE}.CampaignId ;;
    hidden:  yes
  }

  dimension: cpc_bid {
    type: string
    sql: ${TABLE}.CpcBid ;;
    hidden:  yes
  }

  dimension: cpc_bid_source {
    type: string
    sql: ${TABLE}.CpcBidSource ;;
    hidden:  yes
  }

  dimension: cpm_bid {
    type: number
    sql: ${TABLE}.CpmBid ;;
    hidden:  yes
  }

  dimension: cpm_bid_source {
    type: string
    sql: ${TABLE}.CpmBidSource ;;
    hidden:  yes
  }

  dimension: criteria {
    type: string
    sql: ${TABLE}.Criteria ;;
  }

  dimension: criteria_destination_url {
    type: string
    sql: ${TABLE}.CriteriaDestinationUrl ;;
    hidden: yes
  }

  dimension: criterion_id {
    sql: ${TABLE}.CriterionId ;;
    hidden:  yes
  }

  dimension: final_app_urls {
    type: string
    sql: ${TABLE}.FinalAppUrls ;;
    hidden:  yes
  }

  dimension: final_mobile_urls {
    type: string
    sql: ${TABLE}.FinalMobileUrls ;;
    hidden:  yes
  }

  dimension: final_urls {
    type: string
    sql: ${TABLE}.FinalUrls ;;
    hidden:  yes
  }

  dimension: is_negative {
    type: yesno
    sql: ${TABLE}.IsNegative ;;
    hidden:  yes
  }

  dimension: is_restrict {
    type: yesno
    sql: ${TABLE}.IsRestrict ;;
    hidden:  yes
  }

  dimension: status_raw {
    hidden: yes
    type: string
    sql: ${TABLE}.Status ;;
  }

  dimension: status {
    hidden: yes
    type: string
    sql: REPLACE(${status_raw}, "Status_", "") ;;
  }

  dimension: status_active {
    type: yesno
    sql: ${status} = "Active" ;;
  }

  dimension: tracking_url_template {
    type: string
    sql: ${TABLE}.TrackingUrlTemplate ;;
    hidden:  yes
  }

  dimension: url_custom_parameters {
    type: string
    sql: ${TABLE}.UrlCustomParameters ;;
    hidden:  yes
  }

  dimension: key_base {
    hidden: yes
    sql: CONCAT(
      CAST(${external_customer_id} AS STRING), "-",
      CAST(${campaign_id} AS STRING), "-",
      CAST(${ad_group_id} AS STRING), "-",
      CAST(${criterion_id} AS STRING)) ;;
  }

  measure: count {
    type: count_distinct
    sql: ${key_base} ;;
    drill_fields: [drill_detail*]
  }

  measure: count_active {
    type: count_distinct
    sql: ${key_base} ;;
    filters: {
      field: status_active
      value: "Yes"
    }
    drill_fields: [drill_detail*]
  }

  set: drill_detail {
    fields: [criterion_id, criteria, status, cpc_bid]
  }
  set: detail {
    fields: [external_customer_id, campaign_id, ad_group_id, count, count_active, status_active, drill_detail*]
  }
}
