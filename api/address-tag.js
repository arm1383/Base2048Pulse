const ETHERSCAN_API_URL = "https://api.etherscan.io/v2/api";
const BASESCAN_ADDRESS_URL = "https://basescan.org/address/";
const BASESCAN_TEXT_PROXY_URL = "https://r.jina.ai/http://basescan.org/address/";
const ADDRESS_PATTERN = /^0x[a-fA-F0-9]{40}$/;
const BASE_NAME_PATTERN = /^[a-z0-9][a-z0-9-]{0,100}\.base\.eth$/i;

function extractBaseNameTag(value) {
  if (typeof value !== "string") return null;
  const normalized = value.trim();
  return BASE_NAME_PATTERN.test(normalized) ? normalized : null;
}

async function fetchJson(url, init) {
  const response = await fetch(url, init);
  if (!response.ok) {
    throw new Error(`Upstream request failed with status ${response.status}`);
  }
  return response.json();
}

async function fetchText(url, init) {
  const response = await fetch(url, init);
  if (!response.ok) {
    throw new Error(`Upstream request failed with status ${response.status}`);
  }
  return response.text();
}

async function fetchExplorerNametag(address, apiKey) {
  if (!apiKey) return null;

  const url = new URL(ETHERSCAN_API_URL);
  url.searchParams.set("chainid", "8453");
  url.searchParams.set("module", "nametag");
  url.searchParams.set("action", "getaddresstag");
  url.searchParams.set("address", address);
  url.searchParams.set("apikey", apiKey);

  const payload = await fetchJson(url, {
    headers: {
      Accept: "application/json"
    }
  });

  const record = Array.isArray(payload?.result) ? payload.result[0] : null;
  return extractBaseNameTag(record?.nametag) || extractBaseNameTag(record?.internal_nametag);
}

async function scrapeBasescanNametag(address) {
  const mirroredText = await fetchText(`${BASESCAN_TEXT_PROXY_URL}${address}`, {
    headers: {
      "User-Agent": "Base2048Pulse/1.0 (+https://base2048pulse.vercel.app/)",
      Accept: "text/plain, text/markdown, text/html"
    }
  });

  const titleMatch = mirroredText.match(/Title:\s*([^\n]+)\n/i);
  if (titleMatch) {
    const extractedFromTitle = extractBaseNameTag(titleMatch[1].split("|")[0]);
    if (extractedFromTitle) {
      return extractedFromTitle;
    }
  }

  const directMatch = mirroredText.match(/([a-z0-9][a-z0-9-]{0,100}\.base\.eth)/i);
  if (directMatch) {
    return extractBaseNameTag(directMatch[1]);
  }

  return null;
}

export default async function handler(req, res) {
  res.setHeader("Cache-Control", "s-maxage=1800, stale-while-revalidate=43200");

  if (req.method !== "GET") {
    return res.status(405).json({ error: "Method not allowed." });
  }

  const address = typeof req.query.address === "string" ? req.query.address.trim() : "";
  if (!ADDRESS_PATTERN.test(address)) {
    return res.status(400).json({ error: "Invalid address.", nametag: null, source: "none" });
  }

  const apiKey = process.env.ETHERSCAN_API_KEY || process.env.BASESCAN_API_KEY || "";

  try {
    const explorerNametag = await fetchExplorerNametag(address, apiKey);
    if (explorerNametag) {
      return res.status(200).json({
        address,
        nametag: explorerNametag,
        source: "etherscan_metadata"
      });
    }
  } catch (error) {
    // Fall through to HTML parsing when the API is unavailable or not configured.
  }

  try {
    const scrapedNametag = await scrapeBasescanNametag(address);
    if (scrapedNametag) {
      return res.status(200).json({
        address,
        nametag: scrapedNametag,
        source: "basescan_page"
      });
    }
  } catch (error) {
    // Keep the response stable even if the explorer blocks scraping.
  }

  return res.status(200).json({
    address,
    nametag: null,
    source: apiKey ? "unresolved" : "unresolved_no_api_key"
  });
}
