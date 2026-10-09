# KharchaWise — Free Personal Money Dashboard (v7)

Self-hosted static frontend with Supabase Auth and private finance tables. No subscriptions, payment gateway, bank linking or paid tool requirements.

**GitHub project:** `krishx965-png/Krishnapalsingh.github.io`, folder `kharchawise/`, deployed via GitHub connector. **Supabase project:** `thkotqbeeqenpxnwfgih`, region Mumbai.

## User guide
1. Open the live HTTPS site and create a free account (after email service is configured).
2. Confirm email and sign in.
3. Record income and expenses, set budgets and optional recurring items.
4. Open **My data & privacy** to export your own CSV and JSON records, import your backup, or delete financial records.
5. Use a strong unique password and sign out on shared devices. No banking passwords or OTPs.

## Owner launch checklist
See FINAL_STATUS.md. Real public account email confirmation and two-user isolation testing are not yet complete. Configuring a verified SMTP service requires access to the Supabase Auth configuration UI, a sender identity/domain and provider credentials. Connected Supabase project tools do not currently expose this configuration. GitHub Pages branch publishing may also require checking in GitHub Settings > Pages.

## Privacy and security
- Three Supabase finance tables with RLS, auth.uid()-based per-row permissions, and no `anon` table grants.
- Public publishable key only in client code; never embed private service-role secrets.
- Data exports query records under the signed-in account.
- Privacy and quick start pages in `privacy.html` and `guide.html`.
- Local simulated browser checks and database policy checks documented in FINAL_STATUS.md.