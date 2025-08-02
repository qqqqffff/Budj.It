import { mkdirSync, writeFileSync } from 'fs';
import { join } from 'path';

const appIdPrefix = process.env.APPLE_TEAM_ID.replace('\'', '').replace('\"', '');
const bundleId = process.env.APPLE_BUNDLE_ID.replace('\'', '').replace('\"', '');

if (!appIdPrefix || !bundleId) {
  console.error('Missing required environment variables: APPLE_APP_ID_PREFIX, APPLE_BUNDLE_ID');
  process.exit(1);
}

const association = {
  "applinks": {
    "details": [
      {
        "appIDs": [`${appIdPrefix}.${bundleId}`],
        "components": [
          {
            "/": "/plaid/*",
            "comment": "Matches any URL path whose path starts with /plaid/"
          }
        ]
      }
    ]
  }
};

const outputDir = join(__dirname, '..', 'public', '.well-known');
const outputFile = join(outputDir, 'apple-app-site-association');

// Ensure directory exists
mkdirSync(outputDir, { recursive: true });

// Write the file
writeFileSync(outputFile, JSON.stringify(association, null, 2));

console.log('Apple App Site Association file generated successfully');
console.log('Content:', JSON.stringify(association, null, 2));