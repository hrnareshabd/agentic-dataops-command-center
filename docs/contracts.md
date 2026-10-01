# Workflow contracts

| Agent | Input | Output |
| --- | --- | --- |
| WF-01 | `target_date` string (`YYYY-MM-DD`), optional `mode` string | `workflow: "WF-01"`, `status: "COMPLETED"`, `data_quality` object |
| WF-02 | `question` string, optional carried context | `workflow: "WF-02"`, `status: "COMPLETED"`, `analytics` object |
| WF-03 | `incident_date` string, numeric `run_id`, DQ findings and analytics context | `workflow: "WF-03"`, RCA object, numeric critic score, boolean approval requirement, remediation status |

WF-00's Initialize Run supplies the target date and `dry_run` boolean. Manual execution defaults to the September 28 demo; scheduled input targets the previous Europe/Berlin day. It resolves the completed `orders_daily_etl` run before claiming work.

WF-01's DQ `run_id` is an n8n execution ID string, whereas `pipeline_run_id` and WF-03 `run_id` are database pipeline IDs. Do not interchange them. WF-00 validates the DQ target date, completion status, score and five checks before branching.

WF-02 preserves decimal database values as strings. Build RCA Input converts the known analytics fields to numbers for the RCA contract. Revenue currency is unspecified.

Quality `health` may be `HEALTHY`, `ISSUES_DETECTED` or `INCOMPLETE`; `NO_DATA`/incomplete checks stop orchestration rather than being treated as healthy. Terminal outcomes include `HEALTHY`, `DRY_RUN_COMPLETED`, `REMEDIATION_APPROVED`, `REMEDIATION_REJECTED`, `FAILED`, and duplicate-claim skips.
