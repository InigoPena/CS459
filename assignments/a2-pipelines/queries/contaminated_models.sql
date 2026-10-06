SELECT 
    m.model_version,
    COUNT(DISTINCT r.dt) AS bad_partitions
FROM models m,
UNNEST(m.inputs_read) AS t(inp)
JOIN runs r ON t.inp.run_id = r.run_id
CROSS JOIN incident i
WHERE r.git_sha = i.bad_sha
GROUP BY m.model_version
ORDER BY m.model_version;