
-- CALL CENTER ANALYTICS PROJECT (MySQL)

-- 🔹 1. OVERALL KPI SUMMARY
SELECT
  SUM(incoming_calls) AS total_incoming_calls,
  SUM(answered_calls) AS total_answered_calls,
  SUM(abandoned_calls) AS total_abandoned_calls,
  ROUND(AVG(REPLACE(answer_rate, '%', '') + 0), 2) AS avg_answer_rate_percent,
  ROUND(AVG(REPLACE(service_level_20_seconds, '%', '') + 0), 2) AS avg_sla_percent,
  ROUND(AVG(TIME_TO_SEC(answer_speed_avg)), 2) AS avg_answer_speed_sec,
  ROUND(AVG(TIME_TO_SEC(talk_duration_avg)), 2) AS avg_talk_duration_sec,
  ROUND(AVG(TIME_TO_SEC(waiting_time_avg)), 2) AS avg_wait_time_sec
FROM callcenter_logs;

-- 🔹 2. DAILY TREND ANALYSIS
SELECT
  date,
  SUM(incoming_calls) AS total_incoming_calls,
  SUM(answered_calls) AS total_answered_calls,
  SUM(abandoned_calls) AS total_abandoned_calls,
  ROUND(SUM(abandoned_calls) / NULLIF(SUM(incoming_calls), 0) * 100, 2) AS abandon_rate_percent,
  ROUND(AVG(REPLACE(service_level_20_seconds, '%', '') + 0), 2) AS service_level_percent,
  ROUND(AVG(TIME_TO_SEC(answer_speed_avg)), 2) AS avg_answer_speed_sec
FROM callcenter_logs
GROUP BY date
ORDER BY date;

-- 🔹 3. SLA BREACH REPORT (SLA < 80%)
SELECT
  date,
  REPLACE(service_level_20_seconds, '%', '') + 0 AS sla_percent
FROM callcenter_logs
WHERE REPLACE(service_level_20_seconds, '%', '') + 0 < 80
ORDER BY sla_percent;

-- 🔹 4. SLOWEST ANSWER TIME DAYS
SELECT
  date,
  TIME_TO_SEC(answer_speed_avg) AS answer_speed_seconds
FROM callcenter_logs
ORDER BY answer_speed_seconds DESC
LIMIT 5;

-- 🔹 5. CORRELATION CHECK (WAIT TIME VS ABANDONED CALLS)
SELECT
  ROUND(AVG(TIME_TO_SEC(waiting_time_avg)), 2) AS avg_wait_time_sec,
  ROUND(AVG(abandoned_calls), 2) AS avg_abandoned_calls
FROM callcenter_logs;

-- 🔹 6. DAILY CONVERSION RATE (ANSWERED / INCOMING)
SELECT
  date,
  ROUND(SUM(answered_calls) / NULLIF(SUM(incoming_calls), 0) * 100, 2) AS conversion_rate_percent
FROM callcenter_logs
GROUP BY date
ORDER BY date;

-- 🔹 7. PEAK LOAD DAYS (HIGHEST INCOMING CALLS)
SELECT
  date,
  incoming_calls
FROM callcenter_logs
ORDER BY incoming_calls DESC
LIMIT 5;

-- 🔹 8. DAILY TIME METRICS (hh:mm:ss → seconds)
SELECT
  date,
  ROUND(TIME_TO_SEC(answer_speed_avg), 2) AS answer_speed_sec,
  ROUND(TIME_TO_SEC(talk_duration_avg), 2) AS talk_duration_sec,
  ROUND(TIME_TO_SEC(waiting_time_avg), 2) AS wait_time_sec
FROM callcenter_logs
ORDER BY date;

-- 🔹 9. DAILY PERFORMANCE DASHBOARD
SELECT
  date,
  SUM(incoming_calls) AS incoming_calls,
  SUM(answered_calls) AS answered_calls,
  SUM(abandoned_calls) AS abandoned_calls,
  ROUND(AVG(REPLACE(answer_rate, '%', '') + 0), 2) AS answer_rate_percent,
  ROUND(AVG(REPLACE(service_level_20_seconds, '%', '') + 0), 2) AS service_level_percent,
  ROUND(AVG(TIME_TO_SEC(answer_speed_avg)), 2) AS answer_speed_sec,
  ROUND(AVG(TIME_TO_SEC(talk_duration_avg)), 2) AS talk_duration_sec,
  ROUND(AVG(TIME_TO_SEC(waiting_time_avg)), 2) AS wait_time_sec
FROM callcenter_logs
GROUP BY date
ORDER BY date;