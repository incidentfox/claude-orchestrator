#!/usr/bin/env node
/**
 * Updates the Retell AI agent's tool webhook URLs to match the current ngrok tunnel.
 *
 * Usage:
 *   node scripts/update-retell-url.js                  # Auto-detect from ngrok
 *   node scripts/update-retell-url.js https://abc.ngrok.io  # Explicit URL
 */

const https = require("https");
const fs = require("fs");
const path = require("path");
const { execSync } = require("child_process");

// Load .env
const envPath = path.join(__dirname, "..", ".env");
if (fs.existsSync(envPath)) {
  for (const line of fs.readFileSync(envPath, "utf-8").split("\n")) {
    const trimmed = line.trim();
    if (!trimmed || trimmed.startsWith("#")) continue;
    const eq = trimmed.indexOf("=");
    if (eq > 0) {
      const key = trimmed.slice(0, eq).trim();
      const val = trimmed.slice(eq + 1).trim();
      if (val && !process.env[key]) process.env[key] = val;
    }
  }
}

const API_KEY = process.env.RETELL_API_KEY;
const LLM_ID = process.env.RETELL_LLM_ID;
const AGENT_ID = process.env.RETELL_AGENT_ID;
const API_SECRET = process.env.API_SECRET;

if (!API_KEY) { console.error("RETELL_API_KEY not set"); process.exit(1); }
if (!LLM_ID) { console.error("RETELL_LLM_ID not set (run setup-retell.js first)"); process.exit(1); }
if (!API_SECRET) { console.error("API_SECRET not set"); process.exit(1); }

// Get ngrok URL
let ngrokUrl = process.argv[2];
if (!ngrokUrl) {
  try {
    const tunnels = JSON.parse(
      execSync("curl -s http://localhost:4040/api/tunnels", { encoding: "utf-8" })
    );
    ngrokUrl = tunnels.tunnels[0]?.public_url;
  } catch {}
}
if (!ngrokUrl) {
  console.error("Could not detect ngrok URL. Pass it as an argument or start ngrok.");
  process.exit(1);
}

const WEBHOOK_URL = `${ngrokUrl}/retell/tool?secret=${API_SECRET}`;
const EVENTS_WEBHOOK = `${ngrokUrl}/retell/webhook?secret=${API_SECRET}`;

function retellAPI(method, endpoint, body) {
  return new Promise((resolve, reject) => {
    const data = body ? JSON.stringify(body) : null;
    const opts = {
      hostname: "api.retellai.com",
      path: endpoint,
      method,
      headers: {
        Authorization: `Bearer ${API_KEY}`,
        "Content-Type": "application/json",
      },
    };
    if (data) opts.headers["Content-Length"] = Buffer.byteLength(data);

    const req = https.request(opts, (res) => {
      let body = "";
      res.on("data", (c) => (body += c));
      res.on("end", () => {
        try {
          resolve(JSON.parse(body));
        } catch {
          reject(new Error(`${res.statusCode}: ${body}`));
        }
      });
    });
    req.on("error", reject);
    if (data) req.write(data);
    req.end();
  });
}

async function main() {
  console.log(`Updating Retell LLM ${LLM_ID} tool URLs to ${WEBHOOK_URL}`);

  // Get current LLM config
  const llm = await retellAPI("GET", `/get-retell-llm/${LLM_ID}`);
  const tools = llm.general_tools || [];

  // Update all tool URLs
  let updated = 0;
  for (const tool of tools) {
    if (tool.url && tool.url !== WEBHOOK_URL) {
      tool.url = WEBHOOK_URL;
      updated++;
    }
  }

  if (updated === 0) {
    console.log("All tool URLs already match. Nothing to update.");
    return;
  }

  // Patch LLM
  await retellAPI("PATCH", `/update-retell-llm/${LLM_ID}`, {
    general_tools: tools,
  });
  console.log(`Updated ${updated} tool URLs.`);

  // Update agent webhook if we have agent ID
  if (AGENT_ID) {
    await retellAPI("PATCH", `/update-agent/${AGENT_ID}`, {
      webhook_url: EVENTS_WEBHOOK,
    });
    console.log(`Updated agent webhook to ${EVENTS_WEBHOOK}`);
  }
}

main().catch((err) => {
  console.error("Failed:", err.message);
  process.exit(1);
});
