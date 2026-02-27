-- AXE 1 : PERFORMANCE COMMERCIALE & RENTABILITÉ

-- REQUÊTE 1A : KPIs Globaux
-- Description: Vue d'ensemble du CA, marges, panier moyen

WITH date_params AS (
  SELECT DATE('2025-01-01') AS start_date, DATE('2026-02-27') AS end_date
),

order_items_enriched AS (
  SELECT 
    oi.order_id,
    oi.user_id,
    oi.sale_price,
    oi.status,
    p.cost,
    p.category,
    p.department,
    (oi.sale_price - p.cost) AS gross_margin
  FROM `bigquery-public-data.thelook_ecommerce.order_items` oi
  INNER JOIN `bigquery-public-data.thelook_ecommerce.products` p ON oi.product_id = p.id
  CROSS JOIN date_params d
  WHERE DATE(oi.created_at) BETWEEN d.start_date AND d.end_date
    AND p.category IN ('Fashion Hoodies & Sweatshirts', 'Sweaters')
)

SELECT
  COUNT(DISTINCT order_id) AS nb_commandes,
  COUNT(DISTINCT user_id) AS nb_clients,
  ROUND(SUM(sale_price), 2) AS ca_total,
  ROUND(SUM(gross_margin), 2) AS marge_brute,
  ROUND(AVG(gross_margin / sale_price * 100), 2) AS taux_marge_pct,
  ROUND(SUM(sale_price) / COUNT(DISTINCT order_id), 2) AS panier_moyen,
  ROUND(SUM(CASE WHEN status = 'Returned' THEN sale_price ELSE 0 END) / SUM(sale_price) * 100, 2) AS taux_retour_pct
FROM order_items_enriched;

-- REQUÊTE 1B : Performance par Catégorie
-- Description: Répartition CA et marges Men/Women

WITH date_params AS (
  SELECT DATE('2025-01-01') AS start_date, DATE('2026-02-27') AS end_date
),

order_items_enriched AS (
  SELECT 
    oi.order_id,
    oi.user_id,
    oi.sale_price,
    p.cost,
    p.category,
    p.department,
    p.retail_price,
    p.id AS product_id,
    (oi.sale_price - p.cost) AS gross_margin
  FROM `bigquery-public-data.thelook_ecommerce.order_items` oi
  INNER JOIN `bigquery-public-data.thelook_ecommerce.products` p ON oi.product_id = p.id
  CROSS JOIN date_params d
  WHERE DATE(oi.created_at) BETWEEN d.start_date AND d.end_date
    AND p.category IN ('Fashion Hoodies & Sweatshirts', 'Sweaters')
)

SELECT
  category,
  department,
  COUNT(DISTINCT order_id) AS nb_commandes,
  COUNT(DISTINCT user_id) AS nb_clients,
  ROUND(SUM(sale_price), 2) AS ca,
  ROUND(SUM(gross_margin), 2) AS marge_brute,
  ROUND(AVG(gross_margin / sale_price * 100), 2) AS taux_marge_pct,
  ROUND(AVG((retail_price - sale_price) / retail_price * 100), 2) AS taux_remise_pct,
  COUNT(DISTINCT product_id) AS nb_produits_vendus
FROM order_items_enriched
GROUP BY category, department
ORDER BY ca DESC;

-- REQUÊTE 1C : Top 10 Produits
-- Description: Best-sellers par CA avec ranking

WITH date_params AS (
  SELECT DATE('2025-01-01') AS start_date, DATE('2026-02-27') AS end_date
),

order_items_enriched AS (
  SELECT 
    oi.order_id,
    oi.sale_price,
    p.cost,
    p.name AS product_name,
    p.brand,
    p.category,
    p.department,
    p.retail_price,
    (oi.sale_price - p.cost) AS gross_margin
  FROM `bigquery-public-data.thelook_ecommerce.order_items` oi
  INNER JOIN `bigquery-public-data.thelook_ecommerce.products` p ON oi.product_id = p.id
  CROSS JOIN date_params d
  WHERE DATE(oi.created_at) BETWEEN d.start_date AND d.end_date
    AND p.category IN ('Fashion Hoodies & Sweatshirts', 'Sweaters')
)

SELECT
  ROW_NUMBER() OVER (ORDER BY SUM(sale_price) DESC) AS rang,
  product_name,
  brand,
  category,
  department,
  COUNT(DISTINCT order_id) AS nb_commandes,
  ROUND(SUM(sale_price), 2) AS ca,
  ROUND(SUM(gross_margin), 2) AS marge_brute,
  ROUND(AVG(gross_margin / sale_price * 100), 2) AS taux_marge_pct,
  ROUND(AVG((retail_price - sale_price) / retail_price * 100), 2) AS taux_remise_pct
FROM order_items_enriched
GROUP BY product_name, brand, category, department
HAVING COUNT(DISTINCT order_id) >= 5
ORDER BY ca DESC
LIMIT 10;


-- REQUÊTE 1D : Évolution Mensuelle
-- Description: Tendance temporelle avec croissance

WITH date_params AS (
  SELECT DATE('2025-01-01') AS start_date, DATE('2026-02-27') AS end_date
),

order_items_enriched AS (
  SELECT 
    oi.created_at,
    oi.order_id,
    oi.sale_price,
    p.cost,
    (oi.sale_price - p.cost) AS gross_margin
  FROM `bigquery-public-data.thelook_ecommerce.order_items` oi
  INNER JOIN `bigquery-public-data.thelook_ecommerce.products` p ON oi.product_id = p.id
  CROSS JOIN date_params d
  WHERE DATE(oi.created_at) BETWEEN d.start_date AND d.end_date
    AND p.category IN ('Fashion Hoodies & Sweatshirts', 'Sweaters')
),

evolution_mensuelle AS (
  SELECT
    FORMAT_DATE('%Y-%m', DATE(created_at)) AS mois,
    COUNT(DISTINCT order_id) AS nb_commandes,
    ROUND(SUM(sale_price), 2) AS ca,
    ROUND(AVG(gross_margin / sale_price * 100), 2) AS taux_marge_pct
  FROM order_items_enriched
  GROUP BY mois
)

SELECT
  mois,
  nb_commandes,
  ca,
  taux_marge_pct,
  LAG(ca) OVER (ORDER BY mois) AS ca_mois_precedent,
  ROUND((ca - LAG(ca) OVER (ORDER BY mois)) / LAG(ca) OVER (ORDER BY mois) * 100, 2) AS croissance_ca_pct
FROM evolution_mensuelle
ORDER BY mois;


-- AXE 2 : ACQUISITION & CONVERSION

-- REQUÊTE 2A : Trafic par Source
-- Description: Performance des canaux d'acquisition

WITH date_params AS (
  SELECT DATE('2025-01-01') AS start_date, DATE('2026-02-27') AS end_date
),

products_filtered AS (
  SELECT id AS product_id
  FROM `bigquery-public-data.thelook_ecommerce.products`
  WHERE category IN ('Fashion Hoodies & Sweatshirts', 'Sweaters')
),

events_filtered AS (
  SELECT 
    e.user_id,
    e.session_id,
    e.traffic_source
  FROM `bigquery-public-data.thelook_ecommerce.events` e
  CROSS JOIN date_params d
  WHERE DATE(e.created_at) BETWEEN d.start_date AND d.end_date
),

orders_filtered AS (
  SELECT 
    oi.user_id,
    oi.order_id,
    oi.sale_price
  FROM `bigquery-public-data.thelook_ecommerce.order_items` oi
  INNER JOIN products_filtered p ON oi.product_id = p.product_id
  CROSS JOIN date_params d
  WHERE DATE(oi.created_at) BETWEEN d.start_date AND d.end_date
)

SELECT
  e.traffic_source,
  COUNT(DISTINCT e.session_id) AS nb_sessions,
  COUNT(DISTINCT e.user_id) AS nb_visiteurs,
  COUNT(DISTINCT o.order_id) AS nb_commandes,
  ROUND(SUM(o.sale_price), 2) AS ca,
  ROUND(COUNT(DISTINCT o.order_id) / COUNT(DISTINCT e.session_id) * 100, 2) AS taux_conversion_pct,
  ROUND(SUM(o.sale_price) / COUNT(DISTINCT o.order_id), 2) AS panier_moyen
FROM events_filtered e
LEFT JOIN orders_filtered o ON e.user_id = o.user_id
GROUP BY e.traffic_source
ORDER BY ca DESC;


-- AXE 3 : EFFICACITÉ OPÉRATIONNELLE

-- REQUÊTE 3A : Délais de Livraison
-- Description: Performance logistique

WITH date_params AS (
  SELECT DATE('2025-01-01') AS start_date, DATE('2026-02-27') AS end_date
),

order_items_enriched AS (
  SELECT 
    oi.order_id,
    oi.created_at,
    oi.shipped_at,
    oi.delivered_at
  FROM `bigquery-public-data.thelook_ecommerce.order_items` oi
  INNER JOIN `bigquery-public-data.thelook_ecommerce.products` p ON oi.product_id = p.id
  CROSS JOIN date_params d
  WHERE DATE(oi.created_at) BETWEEN d.start_date AND d.end_date
    AND p.category IN ('Fashion Hoodies & Sweatshirts', 'Sweaters')
)

SELECT
  COUNT(*) AS nb_commandes_total,
  COUNT(CASE WHEN delivered_at IS NOT NULL THEN 1 END) AS nb_livrees,
  ROUND(AVG(DATE_DIFF(DATE(shipped_at), DATE(created_at), DAY)), 2) AS delai_moyen_expedition_jours,
  ROUND(AVG(DATE_DIFF(DATE(delivered_at), DATE(shipped_at), DAY)), 2) AS delai_moyen_livraison_jours,
  ROUND(AVG(DATE_DIFF(DATE(delivered_at), DATE(created_at), DAY)), 2) AS delai_total_moyen_jours,
  COUNT(CASE WHEN DATE_DIFF(DATE(delivered_at), DATE(created_at), DAY) > 7 THEN 1 END) AS nb_livraisons_lentes,
  ROUND(COUNT(CASE WHEN DATE_DIFF(DATE(delivered_at), DATE(created_at), DAY) > 7 THEN 1 END) / COUNT(CASE WHEN delivered_at IS NOT NULL THEN 1 END) * 100, 2) AS taux_livraison_lente_pct
FROM order_items_enriched
WHERE delivered_at IS NOT NULL;


-- REQUÊTE 3B : Analyse des Retours
-- Description: Taux de retour par catégorie

WITH date_params AS (
  SELECT DATE('2025-01-01') AS start_date, DATE('2026-02-27') AS end_date
),

order_items_enriched AS (
  SELECT 
    oi.order_id,
    oi.status,
    oi.sale_price,
    oi.delivered_at,
    oi.returned_at,
    p.category,
    p.department
  FROM `bigquery-public-data.thelook_ecommerce.order_items` oi
  INNER JOIN `bigquery-public-data.thelook_ecommerce.products` p ON oi.product_id = p.id
  CROSS JOIN date_params d
  WHERE DATE(oi.created_at) BETWEEN d.start_date AND d.end_date
    AND p.category IN ('Fashion Hoodies & Sweatshirts', 'Sweaters')
)

SELECT
  category,
  department,
  COUNT(*) AS nb_items_vendus,
  COUNT(CASE WHEN status = 'Returned' THEN 1 END) AS nb_retours,
  ROUND(COUNT(CASE WHEN status = 'Returned' THEN 1 END) / COUNT(*) * 100, 2) AS taux_retour_pct,
  ROUND(SUM(CASE WHEN status = 'Returned' THEN sale_price ELSE 0 END), 2) AS ca_retours,
  ROUND(AVG(CASE WHEN status = 'Returned' THEN DATE_DIFF(DATE(returned_at), DATE(delivered_at), DAY) END), 2) AS delai_moyen_retour_jours
FROM order_items_enriched
GROUP BY category, department
ORDER BY taux_retour_pct DESC;

-- AXE 4 : RÉTENTION & FIDÉLITÉ
-- REQUÊTE 4A : Segmentation Clients
-- Description: Répartition des clients par fréquence d'achat

WITH date_params AS (
  SELECT DATE('2025-01-01') AS start_date, DATE('2026-02-27') AS end_date
),

order_items_enriched AS (
  SELECT 
    oi.user_id,
    oi.order_id,
    oi.sale_price
  FROM `bigquery-public-data.thelook_ecommerce.order_items` oi
  INNER JOIN `bigquery-public-data.thelook_ecommerce.products` p ON oi.product_id = p.id
  CROSS JOIN date_params d
  WHERE DATE(oi.created_at) BETWEEN d.start_date AND d.end_date
    AND p.category IN ('Fashion Hoodies & Sweatshirts', 'Sweaters')
),

client_stats AS (
  SELECT
    user_id,
    COUNT(DISTINCT order_id) AS nb_achats,
    SUM(sale_price) AS ca_total
  FROM order_items_enriched
  GROUP BY user_id
)

SELECT
  CASE 
    WHEN nb_achats = 1 THEN '1 - Client Ponctuel'
    WHEN nb_achats = 2 THEN '2 - Client Occasionnel (2 achats)'
    WHEN nb_achats BETWEEN 3 AND 4 THEN '3 - Client Régulier (3-4 achats)'
    ELSE '4 - Client Fidèle (5+ achats)'
  END AS segment_client,
  COUNT(DISTINCT user_id) AS nb_clients,
  ROUND(SUM(ca_total), 2) AS ca_total,
  ROUND(AVG(ca_total), 2) AS ca_moyen_par_client,
  SUM(nb_achats) AS nb_achats_total
FROM client_stats
GROUP BY segment_client
ORDER BY segment_client;


-- -----------------------------------------------
-- REQUÊTE 4B : CLV & Taux de Rétention
-- Description: Customer Lifetime Value et fidélité
-- -----------------------------------------------

WITH date_params AS (
  SELECT DATE('2025-01-01') AS start_date, DATE('2026-02-27') AS end_date
),

order_items_enriched AS (
  SELECT 
    oi.user_id,
    oi.order_id,
    oi.sale_price
  FROM `bigquery-public-data.thelook_ecommerce.order_items` oi
  INNER JOIN `bigquery-public-data.thelook_ecommerce.products` p ON oi.product_id = p.id
  CROSS JOIN date_params d
  WHERE DATE(oi.created_at) BETWEEN d.start_date AND d.end_date
    AND p.category IN ('Fashion Hoodies & Sweatshirts', 'Sweaters')
),

client_stats AS (
  SELECT
    user_id,
    COUNT(DISTINCT order_id) AS nb_achats,
    SUM(sale_price) AS ca_total,
    AVG(sale_price) AS panier_moyen
  FROM order_items_enriched
  GROUP BY user_id
)

SELECT
  ROUND(AVG(ca_total), 2) AS clv_moyenne,
  ROUND(APPROX_QUANTILES(ca_total, 100)[OFFSET(50)], 2) AS clv_mediane,
  ROUND(APPROX_QUANTILES(ca_total, 100)[OFFSET(90)], 2) AS clv_p90,
  ROUND(MAX(ca_total), 2) AS clv_max,
  ROUND(AVG(nb_achats), 2) AS nb_achats_moyen,
  ROUND(AVG(panier_moyen), 2) AS panier_moyen,
  COUNT(DISTINCT user_id) AS nb_clients_total,
  COUNT(DISTINCT CASE WHEN nb_achats > 1 THEN user_id END) AS nb_clients_recurrents,
  ROUND(COUNT(DISTINCT CASE WHEN nb_achats > 1 THEN user_id END) / COUNT(DISTINCT user_id) * 100, 2) AS taux_retention_pct
FROM client_stats;
