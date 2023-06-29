# Use SQL to extract members with derived fields/flags. Output should only include Males who are 18 years or older. Final output should have one row per member and include the following columns:
 
# a. User_id\par
# b. date of first blood glucose check\par
# c. count of blood glucose checks last 30-days\par
# d. mean blood glucose value last 30-days\par
# e. average blood glucose checks per day last 30-days\par
# f. count hypoglycemic readings (bg_value < 54 mg/dL) lifetime\par
# g. count hypoglycemic readings (bg_value < 54 mg/dL) last 30-days\par

with recent_checks as
(select 
 user_id
 , bg_value
 , bg_timestamp
 from blood_glucose_check 
 where DATEDIFF(DAY, bg_timestamp, GetDate()) >= 30)

select user_id
, min(bg_timestamp) as first_bcg
, count(distinct r.bg_timestamp) as checks_in_last_30_days
, avg (r.bg_value) as mean_bg_30_days
, count(CASE WHEN b.bg_value < 54 THEN 1 ELSE null END) as hg_readings_lifetime
, count(CASE WHEN r.bg_value < 54 THEN 1 ELSE null END) as hg_readings_30_days
from members m 
where gender=m and
DATEDIFF(YEAR, birth_date, GetDate()) >= 18
left join recent_checks r on m.user_id=r.user_id
left join blood_glucose_checks b bgc on m.user_id=b.user_id
