include: "campaign.view"

explore: ad_group_join {
  extension: required

  join: ad_group {
    from: ad_group_adapter
    view_label: "Ad Groups"
    sql_on: ${fact.ad_group_id} = ${ad_group.ad_group_id} AND
      ${fact.campaign_id} = ${ad_group.campaign_id} AND
      ${fact.external_customer_id} = ${ad_group.external_customer_id} AND
      ${ad_group.latest} ;;
    relationship: many_to_one
  }
}

explore: ad_group_adapter {
  persist_with: adwords_etl_datagroup
  from: ad_group_adapter
  view_name: ad_group
  hidden: yes

  join: campaign {
    from: campaign_adapter
    view_label: "Campaign"
    sql_on: ${ad_group.campaign_id} = ${campaign.campaign_id} AND
      ${ad_group.external_customer_id} = ${campaign.external_customer_id} AND
      ${ad_group._date} = ${campaign._date};;
    relationship: many_to_one
  }
  join: customer {
    from: customer_adapter
    view_label: "Customer"
    sql_on: ${ad_group.external_customer_id} = ${customer.external_customer_id} AND
      ${ad_group._date} = ${customer._date} ;;
    relationship: many_to_one
  }
}

view: ad_group_adapter {
  extends: [google_adwords_base]

  derived_table: {
    sql:
      SELECT
        CURRENT_DATE() as _DATA_DATE,
        CURRENT_DATE() as _LATEST_DATE,
        'NA' as ExternalCustomerId,
        0 as AdGroupDesktopBidModifier,
        'NA' as AdGroupId,
        0 as AdGroupMobileBidModifier,
        'NA' as AdGroupName,
        'NA' as AdGroupStatus,
        0 as AdGroupTabletBidModifier,
        'NA' as BidType,
        'NA' as BiddingStrategyId,
        'NA' as BiddingStrategyName,
        'NA' as BiddingStrategySource,
        'NA' as BiddingStrategyType,
        'NA' as CampaignId,
        'NA' as ContentBidCriterionTypeGroup,
        0 as CpcBid,
        0 as CpmBid,
        0 as CpvBid,
        false as EnhancedCpcEnabled,
        false as EnhancedCpvEnabled,
        'NA' as LabelIds,
        'NA' as Labels,
        0 as TargetCpa,
        'NA' as TargetCpaBidSource,
        'NA' as TrackingUrlTemplate,
        'NA' as UrlCustomParameters
      ;;
  }

  dimension: ad_group_desktop_bid_modifier {
    hidden: yes
    type: number
    sql: ${TABLE}.AdGroupDesktopBidModifier ;;
  }

  dimension: ad_group_id {
    hidden: yes
    sql: ${TABLE}.AdGroupId ;;
  }

  dimension: ad_group_mobile_bid_modifier {
    hidden: yes
    type: number
    sql: ${TABLE}.AdGroupMobileBidModifier ;;
  }

  dimension: ad_group_name {
    type: string
    sql: ${TABLE}.AdGroupName ;;
    link: {
      label: "View on AdWords"
      icon_url: "https://www.google.com/s2/favicons?domain=www.adwords.google.com"
      url: "https://adwords.google.com/aw/ads?campaignId={{ campaign_id._value }}&adGroupId={{ ad_group_id._value }}"
    }
    link: {
      label: "Pause Ad Group"
      icon_url: "https://www.google.com/s2/favicons?domain=www.adwords.google.com"
      url: "https://adwords.google.com/aw/ads?campaignId={{ campaign_id._value }}&adGroupId={{ ad_group_id._value }}"
    }
    link: {
      url: "https://adwords.google.com/aw/ads?campaignId={{ campaign_id._value }}&adGroupId={{ ad_group_id._value }}"
      icon_url: "https://www.gstatic.com/awn/awsm/brt/awn_awsm_20171108_RC00/aw_blend/favicon.ico"
      label: "Change Bid"
    }
    required_fields: [external_customer_id, campaign_id, ad_group_id]
  }

  dimension: ad_group_status {
    hidden: yes
    type: string
    sql: ${TABLE}.AdGroupStatus ;;
  }

  dimension: status_active {
    hidden: yes
    type: yesno
    sql: ${ad_group_status} = "ENABLED" ;;
  }

  dimension: ad_group_tablet_bid_modifier {
    hidden: yes
    type: number
    sql: ${TABLE}.AdGroupTabletBidModifier ;;
  }

  dimension: bid_type {
    hidden: yes
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

  dimension: bidding_strategy_source {
    hidden: yes
    type: string
    sql: ${TABLE}.BiddingStrategySource ;;
  }

  dimension: bidding_strategy_type {
    hidden: yes
    type: string
    sql: ${TABLE}.BiddingStrategyType ;;
  }

  dimension: campaign_id {
    hidden: yes
    sql: ${TABLE}.CampaignId ;;
  }

  dimension: content_bid_criterion_type_group {
    hidden: yes
    type: string
    sql: ${TABLE}.ContentBidCriterionTypeGroup ;;
  }

  dimension: cpc_bid {
    type: string
    sql: (${TABLE}.CpcBid / 1000000) ;;
  }

  dimension: cpm_bid {
    type: number
    sql: (${TABLE}.CpmBid / 1000000) ;;
  }

  dimension: cpv_bid {
    type: string
    sql: (${TABLE}.CpvBid / 1000000) ;;
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

  dimension: target_cpa {
    type: number
    sql: (${TABLE}.TargetCpa / 1000000) ;;
  }

  dimension: target_cpa_bid_source {
    hidden: yes
    type: string
    sql: ${TABLE}.TargetCpaBidSource ;;
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
