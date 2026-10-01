# Validation record

Recorded on October 1, 2026. Tests use a synthetic September 28 incident; these are demo observations, not production reliability measurements.

| Check | Observed result | Scope |
| --- | --- | --- |
| WF-01 manual and child invocation | Completed; one structured DQ output | Five failing checks, score 0 |
| WF-02 manual and child invocation | Completed; one structured analytics output | Revenue 10,595; baseline 28,504.50; -62.83% |
| Initial full WF-00 incident run | `REMEDIATION_APPROVED`, critic 98 | Human approved; duplicate quarantined and audit recorded |
| RCA after grounding changes | Critic passed, score 100 | Reasoning/critic only; no approval or remediation executed |
| WF-00 safeguarded dry run | `DRY_RUN_COMPLETED` | WF-01 and WF-02; WF-03 was skipped |
| Critical notification | Gmail returned `SENT` | Existing authorized recipient |
| Durable ledger completion | `DRY_RUN_COMPLETED` stored | Separate dry-run namespace |
| Repeat incident | `SKIPPED_ALREADY_CLAIMED` | No child agents, remediation or repeated notification |
| Isolated child failure | `FAILED`, Gmail `SENT` | Deliberately nonexistent child; no live agents invoked |
| Global failure notification fixture | Gmail `SENT` | Synthetic Error Trigger payload; helper published and attached |
| Manual execution from Schedule Trigger | `NO_UPSTREAM_RUN` | No completed load for 2026-09-30; no agents invoked |

An actual clock-triggered scheduled dry run has not passed. WF-00 remains unpublished. Automatic invocation of the global error helper by a real production failure has not been tested; n8n's manual executions do not invoke Error Trigger workflows automatically.

Screenshots capture the workflow canvases. The incident report records the earlier end-to-end result separately from the newer grounded RCA test. Original screenshots showing private execution links or earlier ungrounded wording are not published.
