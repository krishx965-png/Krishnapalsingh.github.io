# KharchaWise — private beta

Hosted as a free GitHub Pages project subfolder. Existing portfolio homepage was not changed.

Supabase project: thkotqbeeqenpxnwfgih (Mumbai).

## Required before public sign-ups
Go to Supabase > Authentication > URL Configuration and set the Site URL and exact Redirect URL to the actual HTTPS app URL (including trailing slash). The default Supabase SMTP only sends emails to authorized team addresses and is not intended for public sign-ups. Configure a verified custom SMTP provider before inviting customers.

## Private test checklist
1. Add a guest transaction, refresh page, export backup.
2. Set Auth URL config and verify using an authorized test email.
3. Create account, confirm email, sign in, create a cloud transaction and budget.
4. Refresh Cloud, sign out/in and use a second device with same account.
5. With a separate verified account, verify the first account's finance records are inaccessible.
6. Test recurring entries and no-duplicate reapply behavior.

RLS is enabled, anonymous table privileges revoked. This public repository holds a Supabase publishable key only, no secret/service role key. Never publish customer finance records in this repository.

Guest data is stored only in that browser; cloud data requires login. No paid hosting, external bank access or payments enabled.