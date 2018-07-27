include: "google_adwords_base.view"

view: video_adapter {
  extends: [google_adwords_base]

  derived_table: {
    sql:
        SELECT
          CURRENT_DATE() as _DATA_DATE,
          CURRENT_DATE() as _LATEST_DATE,
          'NA' as ExternalCustomerId,
          0 as AdGroupId,
          0 as CampaignId,
          0 as VideoDuration,
          'NA' as VideoId,
          'NA' as VideoTitle,
          0 as AdGroupId,
          0 as CampaignId,
          0 as VideoDuration,
          'NA' as VideoId,
          'NA' as VideoTitle
      ;;
  }

  dimension: ad_group_id {
    hidden: yes
    type: number
    sql: ${TABLE}.AdGroupId ;;
  }

  dimension: campaign_id {
    hidden: yes
    type: number
    sql: ${TABLE}.CampaignId ;;
  }

  dimension: video_duration {
    type: number
    sql: ${TABLE}.VideoDuration ;;
  }

  dimension: video_id {
    hidden: yes
    type: string
    sql: ${TABLE}.VideoId ;;
  }

  dimension: video_title {
    type: string
    sql: ${TABLE}.VideoTitle ;;
  }
}
