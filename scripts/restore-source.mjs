import { gunzipSync } from "node:zlib";
import { readFileSync, writeFileSync, mkdirSync } from "node:fs";
import { dirname } from "node:path";

const files = [
  ["src/index.js.gz.b64", "src/index.js"],
  ["public/index.html.gz.b64", "public/index.html"],
  ["public/app.js.gz.b64", "public/app.js"]
];

for (const [input, output] of files) {
  const encoded = readFileSync(input, "utf8").trim();
  const bytes = gunzipSync(Buffer.from(encoded, "base64"));
  mkdirSync(dirname(output), { recursive: true });
  writeFileSync(output, bytes);
  console.log(`Restored ${output}`);
}
