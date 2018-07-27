include: "customer.view"

explore: campaign_join {
  extension: required

  join: campaign {
    from: campaign_adapter
    view_label: "Campaign"
    sql_on: ${fact.campaign_id} = ${campaign.campaign_id} AND
      ${fact.external_customer_id} = ${campaign.external_customer_id} AND
      ${campaign.latest};;
    relationship: many_to_one
  }
}

explore: campaign_adapter {
  persist_with: adwords_etl_datagroup
  from: campaign_adapter
  view_name: campaign
  hidden: yes

  join: customer {
    from: customer_adapter
    view_label: "Customer"
    sql_on: ${campaign.external_customer_id} = ${customer.external_customer_id} AND
      ${campaign._date} = ${customer._date} ;;
    relationship: many_to_one
  }
}


view: campaign_adapter {
  extends: [google_adwords_base]

  derived_table: {
    sql:
        SELECT
          CURRENT_DATE() as _DATA_DATE,
          CURRENT_DATE() as _LATEST_DATE,
          'NA' as ExternalCustomerId,
          'NA' as AdvertisingChannelSubType,
          'NA' as AdvertisingChannelType,
          0 as Amount,
          'NA' as BidType,
          'NA' as BiddingStrategyId,
          'NA' as BiddingStrategyName,
          'NA' as BiddingStrategyType,
          'NA' as BudgetId,
          0 as CampaignDesktopBidModifier,
          'NA' as CampaignId,
          0 as CampaignMobileBidModifier,
          'NA' as CampaignName,
          'NA' as CampaignStatus,
          0 as CampaignTabletBidModifier,
          'NA' as CampaignTrialType,
          CURRENT_DATE() as EndDate,
          false as EnhancedCpcEnabled,
          false as EnhancedCpvEnabled,
          false as IsBudgetExplicitlyShared,
          'NA' as LabelIds,
          'NA' as Labels,
          'NA' as Period,
          'NA' as ServingStatus,
          CURRENT_DATE() as StartDate,
          'NA' as TrackingUrlTemplate,
          'NA' as UrlCustomParameters
        ;;
  }

  dimension: advertising_channel_sub_type {
    hidden: yes
    type: string
    sql: ${TABLE}.AdvertisingChannelSubType ;;
  }

  dimension: advertising_channel_type {
    hidden: yes
    type: string
    sql: ${TABLE}.AdvertisingChannelType ;;
  }

  dimension: amount {
    type: number
    sql: (${TABLE}.Amount / 1000000) ;;
  }

  dimension: bid_type {
    type: string
    sql: ${TABLE}.BidType ;;
  }

  dimension: bidding_strategy_id {
    hidden: yes
    sql: ${TABLE}.BiddingStrategyId ;;
  }

  dimension: bidding_strategy_name {
    hidden: yes
    type: string
    sql: ${TABLE}.BiddingStrategyName ;;
  }

  dimension: bidding_strategy_type {
    hidden: yes
    type: string
    sql: ${TABLE}.BiddingStrategyType ;;
  }

  dimension: budget_id {
    hidden: yes
    sql: ${TABLE}.BudgetId ;;
  }

  dimension: campaign_desktop_bid_modifier {
    hidden: yes
    type: number
    sql: ${TABLE}.CampaignDesktopBidModifier ;;
  }

  dimension: campaign_id {
    hidden: yes
    sql: ${TABLE}.CampaignId ;;
  }

  dimension: campaign_mobile_bid_modifier {
    hidden: yes
    type: number
    sql: ${TABLE}.CampaignMobileBidModifier ;;
  }

  dimension: name {
    type: string
    sql: ${TABLE}.CampaignName ;;
    link: {
      label: "Campaign Dashboard"
      url: "/dashboards/marketing_analytics::campaign_metrics_cost_per_conversion?Campaign={{ value | encode_uri }}"
      icon_url: "http://www.looker.com/favicon.ico"
    }
    link: {
      label: "View on AdWords"
      icon_url: "https://www.google.com/s2/favicons?domain=www.adwords.google.com"
      url: "https://adwords.google.com/aw/adgroups?campaignId={{ campaign_id._value | encode_uri }}"
    }
    link: {
      label: "Pause Campaign"
      icon_url: "https://www.google.com/s2/favicons?domain=www.adwords.google.com"
      url: "https://adwords.google.com/aw/ads?campaignId={{ campaign_id._value | encode_uri }}"
    }
    link: {
      url: "https://adwords.google.com/aw/ads?campaignId={{ campaign_id._value | encode_uri }}"
      icon_url: "https://www.gstatic.com/awn/awsm/brt/awn_awsm_20171108_RC00/aw_blend/favicon.ico"
      label: "Change Budget"
    }
    required_fields: [external_customer_id, campaign_id]
  }

  dimension: campaign_status_raw {
    hidden: yes
    type: string
    sql: ${TABLE}.CampaignStatus ;;
  }

  dimension: campaign_status {
    hidden: yes
    type: string
    sql: REPLACE(${campaign_status_raw}, "Status_", "") ;;
  }

  dimension: status_active {
    hidden: yes
    type: yesno
    sql: ${campaign_status} = "Active" ;;
  }

  dimension: campaign_tablet_bid_modifier {
    hidden: yes
    type: number
    sql: ${TABLE}.CampaignTabletBidModifier ;;
  }

  dimension: campaign_trial_type {
    hidden: yes
    type: string
    sql: ${TABLE}.CampaignTrialType ;;
  }

  dimension_group: end {
    hidden: yes
    type: time
    timeframes: [
      raw,
      date,
      week,
      month,
      quarter,
      year
    ]
    convert_tz: no
    sql: (TIMESTAMP(${TABLE}.EndDate)) ;;
  }

  dimension: enhanced_cpc_enabled {
    hidden: yes
    type: yesno
    sql: ${TABLE}.EnhancedCpcEnabled ;;
  }

  dimension: enhanced_cpv_enabled {
    hidden: yes
    type: yesno
    sql: ${TABLE}.EnhancedCpvEnabled ;;
  }

  dimension: is_budget_explicitly_shared {
    hidden: yes
    type: yesno
    sql: ${TABLE}.IsBudgetExplicitlyShared ;;
  }

  dimension: label_ids {
    hidden: yes
    type: string
    sql: ${TABLE}.LabelIds ;;
  }

  dimension: labels {
    hidden: yes
    type: string
    sql: ${TABLE}.Labels ;;
  }

  dimension: period {
    hidden: yes
    type: string
    sql: ${TABLE}.Period ;;
  }

  dimension: serving_status_raw {
    hidden: yes
    type: string
    sql: ${TABLE}.ServingStatus ;;
  }

  dimension: serving_status {
    hidden: yes
    type: string
    sql: REPLACE(${serving_status_raw}, "CAMPAIGN_SYSTEM_SERVING_STATUS_", "") ;;
  }

  dimension_group: start {
    hidden: yes
    type: time
    timeframes: [
      raw,
      date,
      week,
      month,
      quarter,
      year
    ]
    convert_tz: no
    sql: (TIMESTAMP(${TABLE}.StartDate)) ;;
  }

  dimension: tracking_url_template {
    hidden: yes
    type: string
    sql: ${TABLE}.TrackingUrlTemplate ;;
  }

  dimension: url_custom_parameters {
    hidden: yes
    type: string
    sql: ${TABLE}.UrlCustomParameters ;;
  }
}
