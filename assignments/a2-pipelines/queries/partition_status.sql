WITH published_runs AS (
    SELECT 
        r.dt,
        r.run_id,
        r.git_sha,
        ROW_NUMBER() OVER (PARTITION BY r.dt ORDER BY r.run_id DESC) AS rn
    FROM runs r
    WHERE len(r.outputs_written) > 0
)
SELECT 
    pr.dt,
    pr.run_id,
    pr.git_sha,
    CASE 
        WHEN pr.git_sha = i.bad_sha THEN 'bad' 
        ELSE 'ok' 
    END AS status
FROM published_runs pr
CROSS JOIN incident i
WHERE pr.rn = 1
ORDER BY pr.dt;