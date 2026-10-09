# KharchaWise — Free Personal Finance Dashboard (v6)

Deploy path: `kharchawise/` inside `krishx965-png/Krishnapalsingh.github.io` (GitHub Pages). Uses Supabase project `thkotqbeeqenpxnwfgih` in Mumbai, India.

## How to use
1. Visit the published HTTPS GitHub Pages `/kharchawise/` URL.
2. Create an account and verify your email (only authorized email recipients may receive confirmation until a custom SMTP provider is configured).
3. Log in. Add transactions using `+ Add transaction`. Select a month to review income, expense and savings. Use Transactions to edit/delete, Budgets to set limits, and Recurring to schedule monthly income/bills (no payments are processed).
4. In **My data & privacy**, download a full JSON backup or CSV files for transactions, budgets and recurring schedules. Downloads fetch fresh data under the current authenticated session, not from another person's browser data.
5. Import a KharchaWise JSON backup, or delete your own financial records after entering DELETE. Download a backup first.

## Technical safeguards
- Supabase Auth; only an intentionally public publishable key in the browser; no service-role key.
- RLS enabled on all three database tables; permissions for anonymous clients revoked; authenticated CRUD is constrained to user_id = auth.uid().
- User-only cloud queries, no guest finance data, visible save errors, spreadsheet injection-safe CSV, validated imports, CSP and safe DOM rendering.
- Password reset/sign-up need working outbound Auth email. Default Supabase SMTP is restricted, so configure a free-tier SMTP with verified sending domain before inviting general public users.

## Release verification
- Chrome desktop and mobile browser automation using mocked Supabase client: add/edit transaction, budget, account-only JSON export, signout hiding private data; passed.
- Real multi-user registration, cloud save/read across devices and authorization isolation with two Supabase Auth accounts **not yet verified**, pending email setup and test users. Do not represent as independently penetration-tested.
- All software/services remain on free tiers; there is no paid feature, subscription or payment processing.

## Security note
GitHub Pages is public source hosting. Do not put service-role secrets, private customer data, or provider passwords in GitHub code. Supabase publishable key can be exposed only when RLS is correct. Use HTTPS and review provider quotas.