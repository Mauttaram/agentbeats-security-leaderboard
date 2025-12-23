-- AgentBeats Leaderboard Query
-- This DuckDB SQL query generates rankings from assessment results
-- Results are stored as JSON files in the results/ directory

-- Main Leaderboard Query
-- Agent ID must be the first column as per AgentBeats requirements
SELECT
    agent_id,                                    -- Agent identifier (required first column)
    MAX(scores.overall_score) as best_score,     -- Best overall score achieved
    AVG(scores.detection_accuracy) as avg_accuracy,  -- Average detection accuracy
    MIN(scores.false_positive_rate) as best_fpr,     -- Best (lowest) false positive rate
    AVG(scores.coverage) as avg_coverage,            -- Average test coverage
    COUNT(*) as submission_count,                     -- Total number of submissions
    MAX(timestamp) as last_submission,               -- Most recent submission timestamp
    AVG(metadata.duration_seconds) as avg_duration, -- Average assessment duration
    AVG(metadata.test_count) as avg_tests           -- Average number of tests run
FROM read_json_auto('results/*.json')
GROUP BY agent_id
ORDER BY best_score DESC, avg_accuracy DESC, best_fpr ASC
;

-- Additional Query: Recent Submissions
-- Shows the 10 most recent assessment results
SELECT
    agent_id,
    scores.overall_score,
    scores.detection_accuracy,
    scores.false_positive_rate,
    timestamp,
    metadata.test_count
FROM read_json_auto('results/*.json')
ORDER BY timestamp DESC
LIMIT 10
;

-- Additional Query: Performance Trends
-- Shows performance over time for each agent
SELECT
    agent_id,
    DATE_TRUNC('day', CAST(timestamp AS TIMESTAMP)) as date,
    AVG(scores.overall_score) as avg_daily_score,
    COUNT(*) as daily_submissions
FROM read_json_auto('results/*.json')
GROUP BY agent_id, DATE_TRUNC('day', CAST(timestamp AS TIMESTAMP))
ORDER BY date DESC, avg_daily_score DESC
;
