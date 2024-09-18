-- ext_835a439b."pcna-matomoreporting" source

CREATE VIEW ext_835a439b."pcna-matomoreporting" AS
WITH
  reportingtable AS (
   SELECT
     idvisit
   , sitename
   , referrertype
   , referrername
   , referrerkeyword
   , referrerurl
   , devicetype
   , dealerID
   , ApplicationID
   , model
   , pagetitle
   , servertimepretty
   , pageviewposition
   , subtitle
   , typ
   , market
   , VehicleCondition
   FROM
     (
      SELECT
        idvisit
      , sitename
      , referrertype
      , referrername
      , referrerkeyword
      , referrerurl
      , devicetype
      , "actiondetails.dimension14" dealerID
      , "actiondetails.dimension16" ApplicationID
      , "actiondetails.dimension17" model
      , "actiondetails.pagetitle" pagetitle
      , servertimepretty
      , "actiondetails.pageviewposition" pageviewposition
      , "actiondetails.subtitle" subtitle
      , "actiondetails.type" typ
      , country market
      , (CASE WHEN (regexp_extract("actiondetails.subtitle", '-(new)-', 1) IS NOT NULL) THEN 'new' WHEN (regexp_extract("actiondetails.subtitle", '-(preowned)-', 1) IS NOT NULL) THEN 'preowned' ELSE 'unknown' END) VehicleCondition
      FROM
        matomo.visits
      WHERE ((sitename LIKE '%Customer%') AND ("actiondetails.type" = 'action'))
   ) 
   WHERE (lower(market) = 'us')
) 
SELECT
  idvisit
, sitename
, devicetype
, model
, dealerID
, ApplicationID
, pagetitle
, date(servertimepretty) servertimepretty
, subtitle
, market
, VehicleCondition
FROM
  reportingtable
GROUP BY idvisit, sitename, devicetype, dealerID, ApplicationID, model, pagetitle, servertimepretty, subtitle, market, VehicleCondition
ORDER BY servertimepretty DESC;