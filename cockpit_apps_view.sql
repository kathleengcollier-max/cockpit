-- Run this in the App Catalog chat (A815), which owns the catalog schema.
-- Exposes only name / url / version / sort_order for active apps with a real URL.
-- Nothing else on catalog.apps (refs, repos, notes) is reachable through it.

create or replace view catalog.cockpit_apps
with (security_invoker = false) as
select name,
       live_url as url,
       version,
       sort_order
from catalog.apps
where coalesce(archived, false) = false
  and live_url ~* '^https?://';

grant usage on schema catalog to anon;
grant select on catalog.cockpit_apps to anon, authenticated;

-- Verify from the sandbox / browser:
-- curl -s "https://kyzzaywlmoohudzynnzq.supabase.co/rest/v1/cockpit_apps?select=name,url" \
--   -H "apikey: <anon key>" -H "Accept-Profile: catalog"
