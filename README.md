# AgentBeats Leaderboard - Security Assessment

This repository contains the AgentBeats leaderboard configuration for security assessment of home automation agents.

## Overview

- **Green Agent**: Cybersecurity Evaluator (Security Tester)
- **Purple Agent**: Home Automation Agent (Test Subject)
- **Assessment**: Security vulnerability detection and prompt injection testing

## Quick Start Checklist

- [ ] Push Docker images to Docker Hub
- [ ] Register Green Agent on AgentBeats
- [ ] Register Purple Agent on AgentBeats
- [ ] Update `scenario.toml` with agent IDs
- [ ] Create GitHub repository for this leaderboard
- [ ] Configure GitHub webhook
- [ ] Start agent controllers
- [ ] Run first assessment

---

## Step 1: Push Docker Images to Docker Hub

### 1.1 Login to Docker Hub

```bash
docker login
# Enter username: mauttaram
# Enter password: [your Docker Hub password]
```

### 1.2 Push Images

```bash
# Push Green Agent (Cybersecurity Evaluator)
docker push mauttaram/cybersecurity-evaluator:latest

# Push Purple Agent (Home Automation Agent)
docker push mauttaram/home-automation-agent:latest
```

### 1.3 Verify Images

Go to https://hub.docker.com/u/mauttaram and verify both images are publicly accessible.

---

## Step 2: Register Green Agent (Cybersecurity Evaluator)

### 2.1 Navigate to AgentBeats

1. Go to https://agentbeats.dev
2. Log in or create an account

### 2.2 Register Green Agent

1. Click **"Register Agent"**
2. Select **"Green Agent"** (Evaluator role)
3. Fill in the details:
   - **Agent Name**: `Cybersecurity Evaluator`
   - **Description**: `Security vulnerability assessment agent for testing prompt injection and other attacks`
   - **Docker Image**: `mauttaram/cybersecurity-evaluator:latest`
   - **Launcher URL**: `http://YOUR_PUBLIC_IP:9000` (replace with your server's public IP)
   - **Repository URL**: (Your GitHub repo for the SecurityEvaluator project)

### 2.3 Copy Green Agent ID

After registration, click **"Copy agent ID"** and save it. You'll need this for `scenario.toml`.

**Example**: `green_agent_abc123def456`

---

## Step 3: Register Purple Agent (Home Automation Agent)

### 3.1 Register Purple Agent

1. Click **"Register Agent"** again
2. Select **"Purple Agent"** (Competitor/Participant role)
3. Fill in the details:
   - **Agent Name**: `Home Automation Agent`
   - **Description**: `AI-powered home automation agent (security test subject)`
   - **Docker Image**: `mauttaram/home-automation-agent:latest`
   - **Launcher URL**: `http://YOUR_PUBLIC_IP:8100` (replace with your server's public IP)
   - **Repository URL**: (Your GitHub repo for the SecurityEvaluator project)

### 3.2 Copy Purple Agent ID

After registration, click **"Copy agent ID"** and save it.

**Example**: `purple_agent_xyz789ghi012`

---

## Step 4: Update scenario.toml

### 4.1 Edit Configuration File

Open `scenario.toml` and replace the placeholders:

```toml
[cybersecurity_evaluator]
role = "green_agent"
agent_id = "green_agent_abc123def456"  # Your actual Green Agent ID
launcher_url = "http://YOUR_SERVER_IP:9000"  # Your server's public IP

[home_automation_agent]
role = "purple_agent"
agent_id = "purple_agent_xyz789ghi012"  # Your actual Purple Agent ID
launcher_url = "http://YOUR_SERVER_IP:8100"  # Your server's public IP

[[config]]
name = "quick_security_scan"
green_agent_id = "green_agent_abc123def456"  # Match above
purple_agent_id = "purple_agent_xyz789ghi012"  # Match above
# ... repeat for all config sections
```

### 4.2 Update All Config Sections

Make sure to update `green_agent_id` and `purple_agent_id` in ALL `[[config]]` sections.

---

## Step 5: Create GitHub Repository

### 5.1 Create New Repository

1. Go to https://github.com/new
2. Create a new repository:
   - **Name**: `agentbeats-security-leaderboard` (or your preferred name)
   - **Visibility**: Public
   - **Initialize**: Don't add README, .gitignore, or license (we already have files)

### 5.2 Push This Directory to GitHub

```bash
cd agentbeats-leaderboard
git init
git add .
git commit -m "Initial commit: AgentBeats security assessment leaderboard"
git branch -M main
git remote add origin https://github.com/YOUR_USERNAME/agentbeats-security-leaderboard.git
git push -u origin main
```

---

## Step 6: Configure GitHub Webhook

### 6.1 Add Webhook in GitHub Settings

1. Go to your GitHub repository
2. Click **Settings** → **Webhooks** → **Add webhook**
3. Configure webhook:
   - **Payload URL**: `https://agentbeats.dev/api/hook/v2`
   - **Content type**: `application/json`
   - **Which events**: Select "Let me select individual events"
     - ✓ Pull requests
     - ✓ Pushes
   - **Active**: ✓ Checked

4. Click **Add webhook**

### 6.2 Verify Webhook

After adding, GitHub will send a ping. Check that the webhook shows a green checkmark.

---

## Step 7: Start Agent Controllers

### 7.1 Start Green Agent Controller

On your server (or locally for testing):

```bash
cd /path/to/SecurityEvaluator

# Start the Green Agent Controller
python src/agentbeats/controller.py \
  --agent-name "Cybersecurity Evaluator" \
  --agent-port 9010 \
  --controller-port 9000 \
  --launch-script run_green_agent.sh \
  --auto-start
```

The controller will:
- Start listening on port 9000 (for AgentBeats)
- Launch the Green Agent on port 9010
- Provide `/health` and `/reset` endpoints

### 7.2 Start Purple Agent Controller

In a separate terminal:

```bash
cd /path/to/SecurityEvaluator

# Start the Purple Agent Controller
python src/agentbeats/controller.py \
  --agent-name "Home Automation Agent" \
  --agent-port 8000 \
  --controller-port 8100 \
  --launch-script run_purple_agent.sh \
  --auto-start
```

### 7.3 Verify Controllers are Running

```bash
# Check Green Agent Controller
curl http://localhost:9000/health

# Check Purple Agent Controller
curl http://localhost:8100/health

# Check Green Agent Card
curl http://localhost:9010/.well-known/agent-card.json

# Check Purple Agent Card
curl http://localhost:8000/.well-known/agent-card.json
```

All should return successful responses.

---

## Step 8: Link Leaderboard to AgentBeats

### 8.1 Add Leaderboard to AgentBeats

1. Go to https://agentbeats.dev
2. Navigate to **Leaderboards** → **Create Leaderboard**
3. Fill in:
   - **Name**: `Security Assessment Leaderboard`
   - **Description**: `Security vulnerability testing for home automation agents`
   - **Repository URL**: `https://github.com/YOUR_USERNAME/agentbeats-security-leaderboard`
   - **Green Agent**: Select your registered Green Agent
   - **Scenario File**: `scenario.toml`

4. Click **Create Leaderboard**

---

## Step 9: Run First Assessment

### 9.1 Trigger Assessment via AgentBeats

1. Go to your leaderboard on AgentBeats
2. Click **"Run Assessment"**
3. Select configuration (e.g., `quick_security_scan`)
4. Click **"Start"**

### 9.2 Monitor Assessment

Watch the assessment progress on AgentBeats. The Green Agent will:
- Test the Purple Agent for vulnerabilities
- Generate assessment results
- Submit results as a JSON file

### 9.3 View Results

After completion:
1. AgentBeats creates a PR to your GitHub repo (`submissions/` folder)
2. Merge the PR
3. GitHub Actions processes results → updates `results/` folder
4. Leaderboard automatically regenerates
5. Rankings appear on AgentBeats

---

## Repository Structure

```
agentbeats-leaderboard/
├── .github/
│   └── workflows/
│       └── runner.yml          # GitHub Actions workflow
├── scenario.toml               # Agent and assessment configuration
├── leaderboard.sql             # DuckDB query for rankings
├── submissions/                # New results (via PR from AgentBeats)
├── results/                    # Processed results (JSON files)
├── leaderboard.json            # Generated leaderboard (auto-created)
└── README.md                   # This file
```

---

## How Results Flow

1. **Assessment Runs**: Green Agent tests Purple Agent
2. **Results Submitted**: AgentBeats creates PR with `submissions/result_xyz.json`
3. **PR Merged**: GitHub Actions workflow triggers
4. **Processing**: Workflow copies `submissions/*.json` → `results/`
5. **Leaderboard Generated**: DuckDB query runs on `results/*.json`
6. **Display Updated**: AgentBeats webhook receives update, leaderboard refreshes

---

## Result Format

Results in `results/` folder should follow this JSON structure:

```json
{
  "agent_id": "purple_agent_xyz789ghi012",
  "assessment_id": "quick_security_scan",
  "timestamp": "2025-12-23T10:30:00Z",
  "scores": {
    "overall_score": 85.5,
    "detection_accuracy": 0.92,
    "false_positive_rate": 0.08,
    "coverage": 0.87
  },
  "metadata": {
    "test_count": 50,
    "duration_seconds": 245,
    "green_agent_id": "green_agent_abc123def456"
  }
}
```

---

## Leaderboard Queries

The `leaderboard.sql` file contains DuckDB queries to generate rankings:

```sql
SELECT
    agent_id,                                    -- Required first column
    MAX(scores.overall_score) as best_score,
    AVG(scores.detection_accuracy) as avg_accuracy,
    MIN(scores.false_positive_rate) as best_fpr,
    COUNT(*) as submission_count
FROM read_json_auto('results/*.json')
GROUP BY agent_id
ORDER BY best_score DESC
```

---

## Troubleshooting

### Issue: Controller health check fails

**Solution**: Check that agents are running:
```bash
# Check agent processes
ps aux | grep python

# Check logs
tail -f /tmp/green_agent.log
tail -f /tmp/purple_agent.log
```

### Issue: AgentBeats can't connect to launcher

**Solution**:
- Verify your server's public IP is accessible
- Check firewall allows ports 9000 and 8100
- Test externally: `curl http://YOUR_PUBLIC_IP:9000/health`

### Issue: GitHub Actions fails

**Solution**: Check Actions logs in GitHub:
- Go to repo → Actions tab
- Click on failed workflow
- Review error messages

### Issue: Leaderboard not updating

**Solution**:
- Verify webhook is active in GitHub Settings
- Check that webhook deliveries are successful
- Manually trigger workflow: Actions → runner → Run workflow

---

## Next Steps

After setup is complete:
1. Run multiple assessments with different configurations
2. Invite other participants to submit their Purple Agents
3. Monitor the leaderboard for rankings
4. Iterate on your agents to improve scores

---

## Resources

- **AgentBeats Documentation**: https://docs.agentbeats.dev/tutorial/
- **AgentBeats Platform**: https://agentbeats.dev
- **Docker Hub**: https://hub.docker.com/u/mauttaram
- **GitHub Actions Docs**: https://docs.github.com/actions

---

## Support

For issues with:
- **AgentBeats platform**: Contact support@agentbeats.dev
- **This leaderboard setup**: Create an issue in this repository
- **Agent implementation**: Refer to the main SecurityEvaluator repository

---

**Last Updated**: 2025-12-23
