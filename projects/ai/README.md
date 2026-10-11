# AI Monitoring Summary Agent — portfolio case study

Problem: enrolment, matching and verification exports need validation and a repeatable summary before district review.

Workflow: load a flattened CSV or prepared Power BI pair → reject malformed records → compute source-specific metrics → rank block follow-up flags → produce exact report → optionally ask Gemini for structured narrative → review draft.

Skills: Python, data validation, source reconciliation, REST integration, structured AI output, local web UI, file-change automation, privacy-aware aggregation and report generation.

Public sample: 111 union cases, 100 main enrolments, 90 fuzzy records, 11 queue records. Original low fuzzy =20; queued low fuzzy =10; outside queue =10. Quality Yes =70 and incomplete SR =15. These are fictional demonstrations, not programme achievements.

Modes: rules-based automation works locally without AI credentials. Gemini narrative requires a configured provider key/model. Live provider execution remains untested; HTTP integration and failure paths are mocked. There is no email/WhatsApp sending and no AI provider secret in the static portfolio.

Outputs: Markdown summary, JSON metrics, block-priority CSV and anonymous aggregate prompt. Hindi/English narrative, district/block filtering in the public demo and a local CSV upload interface are included. Watch mode checks file changes while the process is running.
