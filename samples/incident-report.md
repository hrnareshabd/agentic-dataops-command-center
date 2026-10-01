# Sample incident report — 2026-09-28

**Synthetic demo · CRITICAL · DQ score 0/100**

The `orders_daily_etl` pipeline reported a failure while loading `fact_orders`: “Duplicate external_order_id detected while loading fact_orders”. Five quality checks failed. The error establishes duplicate detection, but does not establish a database unique-constraint violation.

| Signal | Incident observation | Baseline / expectation |
| --- | --- | --- |
| Order volume | 5 orders | 30 daily orders |
| Duplicate IDs | 1 duplicate group | 0 |
| Missing source | 3 of 5 orders, 60% | At most 2% |
| Price anomaly | 9,999 units | Product price 149 units |
| Pipeline | Failed run | No failed runs |
| Revenue | 10,595 units | Prior seven-day daily average 28,504.50 units |

Revenue was 17,909.50 units below the baseline, a 62.83% decline. Currency was not present in the evidence. This is a reporting anomaly; the evidence does not establish actual economic loss.

## Evidence and interpretation

The duplicate group was `DEMO-ANOM-20260928-DUP`. Duplicate detection is the immediate reported reason for the pipeline failure. Low volume and missing source values are consistent with incomplete ingestion, but the upstream mechanism remains a hypothesis. The price outlier requires source verification; manual entry error is not a confirmed fact.

The latest separately tested RCA uses these distinctions and passed its critic with a score of 100. See [grounded RCA JSON](grounded-rca.json). A critic score measures that evaluation pass, not independent proof that every hypothesis is correct.

## Remediation history

In an earlier complete orchestrator demo run, a human approved duplicate quarantine. The workflow marked the additional duplicate record as quarantined, logged the remediation and returned `REMEDIATION_APPROVED`; that run's critic score was 98. It did not establish that the ETL reran successfully or that revenue was repaired.

After grounding changes, the new RCA test stopped at the critic. The subsequent safeguarded orchestrator dry run invoked quality and analytics only, recorded `DRY_RUN_COMPLETED`, and emailed the CRITICAL result. It did not execute remediation again. A repeat attempt was skipped by the durable run claim.

## Follow-up

Investigate duplicate creation and the missing source fields, verify the outlier against a source of truth, then review whether a pipeline rerun is appropriate. Parameterize the fixed demo evidence/remediation/audit SQL and pass a fresh scheduled dry run before production publication.
