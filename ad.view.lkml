include: "ad_group.view"

explore: ad_join {
  extension: required

  join: ad {
    from: ad_adapter
    view_label: "Ads"
    sql_on: ${fact.creative_id} = ${ad.creative_id} AND
      ${fact.ad_group_id} = ${ad.ad_group_id} AND
      ${fact.campaign_id} = ${ad.campaign_id} AND
      ${fact.external_customer_id} = ${ad.external_customer_id} AND
      ${ad.latest} ;;
    relationship:  many_to_one
  }
}

explore: ad_adapter {
  persist_with: adwords_etl_datagroup
  from: ad_adapter
  view_name: ad
  hidden: yes

  join: ad_group {
    from: ad_group_adapter
    view_label: "Ad Group"
    sql_on: ${ad.ad_group_id} = ${ad_group.ad_group_id} AND
      ${ad.campaign_id} = ${ad_group.campaign_id} AND
      ${ad.external_customer_id} = ${ad_group.external_customer_id} AND
      ${ad._date} = ${ad_group._date};;
    relationship: many_to_one
  }
  join: campaign {
    from: campaign_adapter
    view_label: "Campaign"
    sql_on: ${ad.campaign_id} = ${campaign.campaign_id} AND
      ${ad.external_customer_id} = ${campaign.external_customer_id} AND
      ${ad._date} = ${campaign._date};;
    relationship: many_to_one
  }
  join: customer {
    from: customer_adapter
    view_label: "Customer"
    sql_on: ${ad.external_customer_id} = ${customer.external_customer_id} AND
      ${ad._date} = ${customer._date} ;;
    relationship: many_to_one
  }
}

view: ad_adapter {
  extends: [google_adwords_base]
  derived_table: {
    sql:
      SELECT
        CURRENT_DATE() as _DATA_DATE,
        CURRENT_DATE() as _LATEST_DATE,
        'NA' as ExternalCustomerId,
        'NA' as AdGroupAdDisapprovalReasons,
        false as AdGroupAdTrademarkDisapproved,
        'NA' as AdGroupId,
        'NA' as AdType,
        'NA' as BusinessName,
        'NA' as CallOnlyPhoneNumber,
        'NA' as CampaignId,
        'NA' as CreativeApprovalStatus,
        'NA' as CreativeDestinationUrl,
        'NA' as CreativeFinalAppUrls,
        'NA' as CreativeFinalMobileUrls,
        'NA' as CreativeFinalUrls,
        'NA' as CreativeId,
        'NA' as CreativeTrackingUrlTemplate,
        'NA' as CreativeUrlCustomParameters,
        'NA' as Description,
        'NA' as Description1,
        'NA' as Description2,
        'NA' as DevicePreference,
        'NA' as DisplayUrl,
        'NA' as EnhancedDisplayCreativeLogoImageMediaId,
        'NA' as EnhancedDisplayCreativeMarketingImageMediaId,
        'NA' as Headline,
        'NA' as HeadlinePart1,
        'NA' as HeadlinePart2,
        'NA' as ImageAdUrl,
        'NA' as ImageCreativeImageHeight,
        'NA' as ImageCreativeImageWidth,
        'NA' as ImageCreativeName,
        'NA' as LabelIds,
        'NA' as Labels,
        'NA' as LongHeadline,
        'NA' as Path1,
        'NA' as Path2,
        'NA' as ShortHeadline,
        'NA' as Status,
        'NA' as Trademarks
      ;;
  }

  dimension: ad_group_ad_disapproval_reasons {
    type: string
    sql: ${TABLE}.AdGroupAdDisapprovalReasons ;;
  }

  dimension: ad_group_ad_trademark_disapproved {
    type: yesno
    sql: ${TABLE}.AdGroupAdTrademarkDisapproved ;;
  }

  dimension: ad_group_id {
    sql: ${TABLE}.AdGroupId ;;
    hidden: yes
  }

  dimension: ad_type {
    type: string
    sql: ${TABLE}.AdType ;;
  }

  dimension: business_name {
    type: string
    sql: ${TABLE}.BusinessName ;;
  }

  dimension: call_only_phone_number {
    type: string
    sql: ${TABLE}.CallOnlyPhoneNumber ;;
    hidden: yes
  }

  dimension: campaign_id {
    sql: ${TABLE}.CampaignId ;;
    hidden: yes
  }

  dimension: creative_approval_status_raw {
    hidden: yes
    type: string
    sql: ${TABLE}.CreativeApprovalStatus ;;
  }

  dimension: creative_approval_status {
    type: string
    sql: REPLACE(${creative_approval_status_raw}, "ApprovalStatus_", "") ;;
#     expression: replace(${creative_approval_status_raw}, "ApprovalStatus_", "") ;;
  }

  dimension: creative_destination_url {
    type: string
    sql: ${TABLE}.CreativeDestinationUrl ;;
    group_label: "URLS"
  }

  dimension: creative_final_app_urls {
    type: string
    sql: ${TABLE}.CreativeFinalAppUrls ;;
    group_label: "URLS"
  }

  dimension: creative_final_mobile_urls {
    type: string
    sql: ${TABLE}.CreativeFinalMobileUrls ;;
    group_label: "URLS"
  }

  dimension: creative_final_urls {
    hidden: yes
    type: string
    sql: ${TABLE}.CreativeFinalUrls ;;
    group_label: "URLS"
  }

  dimension: creative_final_urls_clean {
    hidden: yes
    type: string
    sql: REGEXP_EXTRACT(${creative_final_urls}, r'\"([^\"]*)\"') ;;
  }

  dimension: creative_final_urls_domain_path {
    label: "Creative Final Urls"
    type: string
    sql: SUBSTR(REGEXP_EXTRACT(${creative_final_urls_clean}, r'^https?://(.*)\?'), 0, 50) ;;
    link: {
      url: "{{ creative_final_urls_clean }}"
      label: "Landing Page"
    }
    group_label: "URLS"
  }

  dimension: creative_id {
    sql: ${TABLE}.CreativeId ;;
    hidden: yes
  }

  dimension: creative_tracking_url_template {
    type: string
    sql: ${TABLE}.CreativeTrackingUrlTemplate ;;
    hidden: yes
  }

  dimension: creative_url_custom_parameters {
    type: string
    sql: ${TABLE}.CreativeUrlCustomParameters ;;
    hidden: yes
  }

  dimension: description {
    type: string
    sql: ${TABLE}.Description ;;
  }

  dimension: description1 {
    type: string
    sql: ${TABLE}.Description1 ;;
  }

  dimension: description2 {
    type: string
    sql: ${TABLE}.Description2 ;;
  }

  dimension: device_preference {
    type: number
    sql: ${TABLE}.DevicePreference ;;
  }

  dimension: display_url {
    type: string
    sql: ${TABLE}.DisplayUrl ;;
    group_label: "URLS"
  }

  dimension: enhanced_display_creative_logo_image_media_id {
    sql: ${TABLE}.EnhancedDisplayCreativeLogoImageMediaId ;;
    hidden: yes
  }

  dimension: enhanced_display_creative_marketing_image_media_id {
    sql: ${TABLE}.EnhancedDisplayCreativeMarketingImageMediaId ;;
    hidden: yes
  }

  dimension: headline {
    type: string
    sql: ${TABLE}.Headline;;
    group_label: "Headline"
  }

  dimension: headline_part1 {
    type: string
    sql: ${TABLE}.HeadlinePart1 ;;
    group_label: "Headline"
  }

  dimension: headline_part2 {
    type: string
    sql: ${TABLE}.HeadlinePart2 ;;
    group_label: "Headline"
  }

  dimension: image_ad_url {
    type: string
    sql: ${TABLE}.ImageAdUrl ;;
    group_label: "URLS"
  }

  dimension: image_creative_image_height {
    type: number
    sql: ${TABLE}.ImageCreativeImageHeight ;;
    hidden: yes
  }

  dimension: image_creative_image_width {
    type: number
    sql: ${TABLE}.ImageCreativeImageWidth ;;
    hidden: yes
  }

  dimension: image_creative_name {
    type: string
    sql: ${TABLE}.ImageCreativeName ;;
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

  dimension: long_headline {
    type: string
    sql: ${TABLE}.LongHeadline ;;
    hidden: yes
  }

  dimension: path1 {
    type: string
    sql: ${TABLE}.Path1 ;;
    hidden: yes
  }

  dimension: path2 {
    type: string
    sql: ${TABLE}.Path2 ;;
    hidden: yes
  }

  dimension: short_headline {
    type: string
    sql: ${TABLE}.ShortHeadline ;;
    hidden: yes
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
    # expression: replace(${status_raw}, "Status_", "") ;;
  }

  dimension: status_active {
    type: yesno
    sql: ${status} = "Enabled" ;;
  }

  dimension: trademarks {
    type: string
    sql: ${TABLE}.Trademarks ;;
  }

  dimension: creative {
    type: string
    sql: SUBSTR(CONCAT(
      COALESCE(CONCAT(${headline}, "\n"),"")
      , COALESCE(CONCAT(${headline_part1}, "\n"),"")
      , COALESCE(CONCAT(${headline_part2}, "\n"),"")
      ), 0, 50) ;;
    link: {
      url: "https://adwords.google.com/aw/ads?campaignId={{ campaign_id._value }}&adGroupId={{ ad_group_id._value }}"
      icon_url: "https://www.gstatic.com/awn/awsm/brt/awn_awsm_20171108_RC00/aw_blend/favicon.ico"
      label: "Pause Ad"
    }
    link: {
      url: "https://adwords.google.com/aw/ads?campaignId={{ campaign_id._value }}&adGroupId={{ ad_group_id._value }}"
      icon_url: "https://www.gstatic.com/awn/awsm/brt/awn_awsm_20171108_RC00/aw_blend/favicon.ico"
      label: "Change Bid"
    }
    required_fields: [external_customer_id, campaign_id, ad_group_id, creative_id]
    # expression: substring(concat(${headline}, ${headline_part1}, ${headline_part2}), 0, 50)
  }

  dimension: display_headline {
    type: string
    sql: CONCAT(
      COALESCE(CONCAT(${headline}, "\n"),"")
      , COALESCE(CONCAT(${headline_part1}, "\n"),"")) ;;
  }
}
