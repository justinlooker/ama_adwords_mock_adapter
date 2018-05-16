include: "/app_marketing_analytics_config/adwords_config.view"

include: "ad_group.view"
include: "google_adwords_base.view"

explore: keyword_adapter {
  persist_with: adwords_etl_datagroup
  from: keyword_adapter
  view_name: keyword
  hidden: yes

  join: ad_group {
    from: ad_group_adapter
    view_label: "Ad Groups"
    sql_on: ${keyword.ad_group_id} = ${ad_group.ad_group_id} AND
      ${keyword.campaign_id} = ${ad_group.campaign_id} AND
      ${keyword.external_customer_id} = ${ad_group.external_customer_id} AND
      ${keyword._date} = ${ad_group._date} ;;
    relationship: many_to_one
  }
  join: campaign {
    from: campaign_adapter
    view_label: "Campaign"
    sql_on: ${keyword.campaign_id} = ${campaign.campaign_id} AND
      ${keyword.external_customer_id} = ${campaign.external_customer_id} AND
      ${keyword._date} = ${campaign._date};;
    relationship: many_to_one
  }
  join: customer {
    from: customer_adapter
    view_label: "Customer"
    sql_on: ${keyword.external_customer_id} = ${customer.external_customer_id} AND
      ${keyword._date} = ${customer._date} ;;
    relationship: many_to_one
  }
}

view: keyword_adapter {
  extends: [adwords_config, google_adwords_base]
  sql_table_name: {{ keyword.adwords_schema._sql }}.Keyword_{{ keyword.adwords_customer_id._sql }} ;;

  dimension: ad_group_id {
    sql: ${TABLE}.AdGroupId ;;
    hidden: yes
  }

  dimension: approval_status {
    type: string
    sql: ${TABLE}.ApprovalStatus ;;
  }

  dimension: bid_type {
    type: string
    sql: ${TABLE}.BidType ;;
  }

  dimension: bidding_strategy_id {
    sql: ${TABLE}.BiddingStrategyId ;;
    hidden: yes
  }

  dimension: bidding_strategy_name {
    type: string
    sql: ${TABLE}.BiddingStrategyName ;;
  }

  dimension: bidding_strategy_source {
    type: string
    sql: ${TABLE}.BiddingStrategySource ;;
  }

  dimension: bidding_strategy {
    type: string
    sql: ${TABLE}.BiddingStrategyType ;;
    }

  dimension: bidding_strategy_type {
    type: string
    case: {
      when: {
        sql: ${bidding_strategy} = 'Target CPA' ;;
        label: "Target CPA"
      }
      when: {
        sql: ${bidding_strategy} = 'Enhanced CPC';;
        label: "Enhanced CPC"
      }
      when: {
        sql: ${bidding_strategy} = 'cpc' ;;
        label: "CPC"
      }
      when: {
        sql: ${bidding_strategy} = 'cpv' ;;
        label: "CPV"
      }
      else: "Other"
    }
  }

  dimension: campaign_id {
    sql: ${TABLE}.CampaignId ;;
    hidden: yes
  }

  dimension: cpc_bid {
    hidden: yes
    type: number
    sql: (${TABLE}.CpcBid / 1000000) ;;
  }

  dimension: cpc_bid_source {
    type: string
    sql: ${TABLE}.CpcBidSource ;;
  }

  dimension: cpm_bid {
    hidden: yes
    type: number
    sql: (${TABLE}.CpmBid / 1000000) ;;
  }

  dimension: creative_quality_score {
    type: string
    sql: ${TABLE}.CreativeQualityScore ;;
    hidden: yes
  }

  dimension: criteria {
    type: string
    sql: ${TABLE}.Criteria ;;
    link: {
      icon_url: "https://www.google.com/images/branding/product/ico/googleg_lodp.ico"
      label: "Google Search"
      url: "https://www.google.com/search?q={{ value | encode_uri}}"
    }
    required_fields: [external_customer_id, campaign_id, ad_group_id, criterion_id]
  }

  dimension: campaign_ad_group_keyword_combination {
    type: string
    sql: CONCAT(${campaign.campaign_name}, "_", ${ad_group.ad_group_name}, "_", ${keyword.criteria}) ;;
  }

  dimension: criteria_destination_url {
    type: string
    sql: ${TABLE}.CriteriaDestinationUrl ;;
    group_label: "URLS"
  }

  dimension: criterion_id {
    sql: ${TABLE}.CriterionId ;;
    hidden: yes
  }

  dimension: enhanced_cpc_enabled {
    type: yesno
    sql: ${TABLE}.EnhancedCpcEnabled ;;
    hidden:  yes
  }

  dimension: estimated_add_clicks_at_first_position_cpc {
    type: number
    sql: ${TABLE}.EstimatedAddClicksAtFirstPositionCpc ;;
    hidden:  yes
  }

  dimension: estimated_add_cost_at_first_position_cpc {
    type: number
    sql: ${TABLE}.EstimatedAddCostAtFirstPositionCpc ;;
    hidden:  yes
  }

  dimension: final_app_urls {
    type: string
    sql: ${TABLE}.FinalAppUrls ;;
    group_label: "URLS"
  }

  dimension: final_mobile_urls {
    type: string
    sql: ${TABLE}.FinalMobileUrls ;;
    group_label: "URLS"
  }

  dimension: final_urls {
    type: string
    sql: ${TABLE}.FinalUrls ;;
    group_label: "URLS"
  }

  dimension: first_page_cpc {
    type: string
    sql: ${TABLE}.FirstPageCpc ;;
  }

  dimension: first_position_cpc {
    type: string
    sql: ${TABLE}.FirstPositionCpc ;;
  }

  dimension: has_quality_score {
    type: yesno
    sql: ${TABLE}.HasQualityScore ;;
    hidden: yes
  }

  dimension: is_negative {
    type: yesno
    sql: ${TABLE}.IsNegative ;;
  }

  dimension: keyword_match_type {
    type: string
    sql: ${TABLE}.KeywordMatchType ;;
  }

  dimension: label_ids {
    type: string
    sql: ${TABLE}.LabelIds ;;
    hidden: yes
  }

  dimension: labels {
    type: string
    sql: ${TABLE}.Labels ;;
  }

  dimension: post_click_quality_score {
    type: string
    sql: ${TABLE}.PostClickQualityScore ;;
  }

  dimension: quality_score {
    type: number
    sql: ${TABLE}.QualityScore ;;
  }

  dimension: search_predicted_ctr {
    type: string
    sql: ${TABLE}.SearchPredictedCtr ;;
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

  dimension: system_serving_status_raw {
    hidden: yes
    type: string
    sql: ${TABLE}.SystemServingStatus ;;
  }

  dimension: system_serving_status {
    type: string
    sql: REPLACE(${system_serving_status_raw}, "CRITERIA_SYSTEM_SERVING_STATUS_", "") ;;
  }

  dimension: top_of_page_cpc {
    type: string
    sql: ${TABLE}.TopOfPageCpc ;;
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
}
