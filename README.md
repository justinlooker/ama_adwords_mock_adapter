# Google AdWords: BigQuery Data Transfer Service

### Dependencies

This adapter relies on a project `app_marketing_analytics_config` as specified in the manifest.lkml file. This project needs to include an `adwords_config.view.lkml` file.

For example:

```LookML
view: adwords_config {
  extension: required

  dimension: adwords_schema {
    hidden: yes
    sql:adwords;;
  }

  dimension: adwords_customer_id {
    hidden: yes
    sql:1234567890;;
  }
}
```

### Block Info

This Block is modeled on the schema from Google's [BigQuery Transfer Service](https://cloud.google.com/bigquery/transfer/).

The schema documentation for AdWords can be found in [Google's docs](https://developers.google.com/adwords/api/docs/appendix/reports).

### Google AdWords Raw Data Structure

* **Entity Tables and Stats Tables** - There are several primary entities included in the AdWords data set, such as ad, ad group, campaign, customer, keyword, etc.. Each of these tables has a corresponding "Stats" table, which includes all the various metrics for that entity. For example, the "campaign" entity table contains attributes for each campaign, such as the campaign name and campaign status. The corresponding stats table - "Campaign Basic Stats" contains metrics such as impressions, clicks, and conversions. These stats tables are mapped to an ad_impression explore as an interface to the Looker Marketing Analytics application.

* **Snapshots** - AdWords tables keep records over time by snapshotting all data at the end of each day. The following day, a new snapshot is taken, and appended to the table. There are two columns on each table: `_DATA_DATE` and `_LATEST_DATE`. `_DATA_DATE` tells you the day the data was recorded, while `_LATEST_DATE` is an immutable field that tells you the most recent date a snapshot was taken. Querying the table using `_DATA_DATE` = `_LATEST_DATE` in the `WHERE` clause would give you only the data for the latest day.


### Reporting Schema Layout

![image](https://cloud.githubusercontent.com/assets/9888083/26472690/18f621d0-415c-11e7-85fc-e77334847757.png)
