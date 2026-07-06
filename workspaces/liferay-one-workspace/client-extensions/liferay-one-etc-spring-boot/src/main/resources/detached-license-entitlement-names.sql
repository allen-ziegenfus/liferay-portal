SELECT
  d.productKey,
  IF(d.sizing_norm = '', 'default', d.sizing_norm) AS sizing,
  TRIM(
    CONCAT(
      CASE
        WHEN d.catalog_name LIKE 'DXP%' THEN 'Liferay Self-Hosted'
        WHEN d.catalog_name LIKE 'Commerce Subscription%' THEN 'Commerce'
        WHEN d.catalog_name LIKE 'Portal%'
          OR d.catalog_name LIKE 'TCAT Portal%'
          OR d.catalog_name LIKE 'Social Office%' THEN 'Portal'
        ELSE '(UNKNOWN GROUP)'
      END,
      ' ',
      CASE
        WHEN d.catalog_name LIKE '%Non-Production%' THEN 'Non-Prod'
        WHEN d.catalog_name LIKE '%Production%' THEN 'Prod'
        WHEN d.catalog_name LIKE '%Backup%' THEN 'Backup'
        WHEN d.catalog_name LIKE '%Develop%' THEN 'Dev'
        WHEN d.catalog_name LIKE '%OEM%' THEN 'OEM'
        WHEN d.catalog_name LIKE '%Enterprise%' THEN 'Enterprise'
        WHEN d.catalog_name LIKE '%Limited%' THEN 'Limited'
        WHEN d.catalog_name LIKE '%Flex%' THEN 'Flex'
        ELSE ''
      END,
      IF(d.sizing_norm = '', '', CONCAT(' ', d.sizing_norm))
    )
  ) AS entitlementName
FROM (
  SELECT
    lk.productKey,
    CASE
      WHEN lk.sizing IS NULL OR lk.sizing = '' THEN ''
      WHEN lk.sizing LIKE 'sizing-%' THEN CONCAT('Sizing ', SUBSTRING(lk.sizing, 8))
      ELSE lk.sizing
    END AS sizing_norm,
    (
      SELECT MIN(le.name)
      FROM Provisioning_LicenseEntry le
      WHERE le.productKey = lk.productKey
    ) AS catalog_name
  FROM Provisioning_LicenseKey lk
  WHERE lk.productPurchaseKey IS NULL AND lk.productKey IS NOT NULL
  GROUP BY lk.productKey, sizing_norm
) d
ORDER BY d.productKey, d.sizing_norm;
