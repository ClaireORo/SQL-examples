#Output as daily count
with first_upsell as
(select organization_id
, min(plan_change_created_at) as upsell_at
from price_plan_changes
where 
previous_price_plan='solo_basic'
and price_plan='solo_smart'
group by 1)
select upsell_at
, count(organization_id) as organisations
from first_upsell
where 
month(upsell_at)=10
and year(upsell_at)=2022
group by 1 
order by 1

#Output as avg of daily count
with first_upsell as 
(select organization_id
, min(plan_change_created_at) as upsell_at
from price_plan_changes
where 
previous_price_plan='solo_basic'
and price_plan='solo_smart' 
group by 1),
daily as (
select upsell_at
, count(organization_id) as organizations 
from first_upsell 
where 
month(upsell_at)=10
and year(upsell_at)=2022 
group by 1 
order by 1)
select avg(organizations) as daily_avg_upsold_orgs 
from daily
