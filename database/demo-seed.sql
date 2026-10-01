-- Synthetic fixture reconstructed to reproduce the published demo statistics.
-- Run ONLY in a new disposable sandbox after schema.sql. Not executed against the original project.
BEGIN;
INSERT INTO public.customers(customer_id,customer_name,country,segment,signup_date)
VALUES (1,'Synthetic Demo Customer','DE','Demo','2026-01-01');
INSERT INTO public.products(product_id,product_name,category,unit_price) VALUES
(1,'Synthetic Baseline Product','Demo',950.15),
(2,'Wireless Headphones','Demo',149.00);

-- Seven days * 30 orders * 950.15 units = daily revenue of 28,504.50 units.
INSERT INTO public.orders(order_id,external_order_id,order_ts,customer_id,product_id,quantity,unit_price,discount_pct,status,source)
SELECT (d*30+n)::bigint,'DEMO-BASE-'||d||'-'||n,
 TIMESTAMPTZ '2026-09-21 12:00:00+00'+make_interval(days=>d),1,1,1,950.15,0,'COMPLETED','synthetic'
FROM generate_series(0,6) AS d CROSS JOIN generate_series(1,30) AS n;

-- Five orders, one duplicate group, 60% missing source, one price outlier; revenue 10,595.
INSERT INTO public.orders(order_id,external_order_id,order_ts,customer_id,product_id,quantity,unit_price,discount_pct,status,source) VALUES
(1771,'DEMO-ANOM-20260928-DUP','2026-09-28 12:00:00+00',1,2,1,149,0,'COMPLETED','synthetic'),
(1772,'DEMO-ANOM-20260928-DUP','2026-09-28 12:01:00+00',1,2,1,149,0,'COMPLETED','synthetic'),
(1773,'DEMO-ANOM-20260928-3','2026-09-28 12:02:00+00',1,2,1,9999,0,'COMPLETED',NULL),
(1774,'DEMO-ANOM-20260928-4','2026-09-28 12:03:00+00',1,2,1,149,0,'COMPLETED',NULL),
(1775,'DEMO-ANOM-20260928-5','2026-09-28 12:04:00+00',1,2,1,149,0,'COMPLETED',NULL);

INSERT INTO public.pipeline_runs(run_id,pipeline_name,started_at,finished_at,status,rows_processed,error_message) VALUES
(1,'orders_daily_etl','2026-09-28 20:00:00+00','2026-09-28 20:08:00+00','FAILED',5,'Duplicate external_order_id detected while loading fact_orders'),
(2,'orders_daily_etl','2026-09-27 20:00:00+00','2026-09-27 20:08:00+00','SUCCESS',30,NULL),
(3,'orders_daily_etl','2026-09-26 20:00:00+00','2026-09-26 20:08:00+00','SUCCESS',30,NULL);

INSERT INTO public.runbooks(title,category,content) VALUES
('Duplicate order investigation','data_quality','Confirm duplicate evidence and scope. Require human approval before quarantine. Preserve the earliest record for review.'),
('Missing source investigation','data_quality','Investigate absent source fields and compare the load window with source records. Do not infer a source system without evidence.'),
('Price anomaly investigation','data_quality','Compare observed and reference price, then verify against a source of truth. Currency is unspecified unless explicitly supplied.');

SELECT setval('public.customers_customer_id_seq',1,true);
SELECT setval('public.products_product_id_seq',2,true);
SELECT setval('public.orders_order_id_seq',1775,true);
SELECT setval('public.pipeline_runs_run_id_seq',3,true);
SELECT setval('public.runbooks_runbook_id_seq',3,true);
COMMIT;
