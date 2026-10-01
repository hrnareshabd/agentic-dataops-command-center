# Configuration after import

All JSON exports are inactive. Their node definitions, SQL, AI prompts and connections are preserved from the captured demo, with deployment-specific identifiers removed.

Configure:

- PostgreSQL credentials for SQL nodes/tools; privileged remediation access must remain behind approval. Use a separate read-only role for analytics in a production deployment.
- Google Gemini credentials and an available model for each chat-model node.
- Gmail credentials and `YOUR_NOTIFICATION_EMAIL@example.com` replacements.
- Imported workflow IDs in WF-00's three Execute Sub-workflow nodes.
- The imported supporting failure handler in WF-00's Error Workflow setting.
- `https://YOUR-N8N-INSTANCE.example` and placeholder workflow IDs used in private execution links.
- The optional WF-01 data-table trigger ID if that extra entry point is needed.

Use n8n's credential editor; do not put secrets in workflow JSON, SQL files or Git. Public exports do not include pin data, account metadata or credential IDs/names. The failure helper is also inactive in the public export even though it was published in the original demo environment.

The database schema reproduces observed tables, defaults, keys, foreign keys and enabled RLS. It is not a full environment backup: grants, policies, triggers, functions, extensions and sequence counters are not exported. No original business rows or audit rows are included.

Keep `dry_run: true` until the production tasks in README are completed. The production and dry-run ledger namespaces are separate; the database keys protect both run ID and incident date. A failed or running claim is not automatically released.
