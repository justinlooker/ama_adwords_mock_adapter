include: "/app_marketing_analytics_config/adwords_config.view"

include: "criteria_base.view"

explore: age_range_adapter {
  persist_with: adwords_etl_datagroup
  extends: [criteria_joins_base]
  from: age_range_adapter
  view_label: "Age Range"
  view_name: criteria
  hidden: yes
}

view: age_range_adapter {
  extends: [criteria_base]

  derived_table: {
    sql:
        SELECT
          CURRENT_DATE() as _DATA_DATE,
          CURRENT_DATE() as _LATEST_DATE,
          'NA' as ExternalCustomerId,
          'NA' as AdGroupId,
          'NA' as BaseAdGroupId,
          'NA' as BaseCampaignId,
          0 as BidModifier,
          'NA' as BidType,
          'NA' as CampaignId,
          'NA' as CpcBid,
          'NA' as CpcBidSource,
          0 as CpmBid,
          'NA' as CpmBidSource,
          'NA' as Criteria,
          'NA' as CriteriaDestinationUrl,
          'NA' as CriterionId,
          'NA' as FinalAppUrls,
          'NA' as FinalMobileUrls,
          'NA' as FinalUrls,
          false as IsNegative,
          false as IsRestrict,
          'NA' as Status,
          'NA' as TrackingUrlTemplate,
          'NA' as UrlCustomParameters,
          'NA' as criteria
        ;;
  }

  dimension: criteria {
    label: "Age Range"
  }
}
