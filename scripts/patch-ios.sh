#!/usr/bin/env bash
set -euo pipefail

POLY_MOD_LOADER="www/PolyModLoader.js"

echo "Patching $POLY_MOD_LOADER for iOS..."

node -e "
const fs = require('fs');
const file = '$POLY_MOD_LOADER';
let content = fs.readFileSync(file, 'utf8');

const from = 'return URL.createObjectURL(new Blob([originalPhysicsString]));';
const to   = 'return \"data:text/javascript;charset=utf-8,\" + encodeURIComponent(originalPhysicsString);';

if (!content.includes(from)) {
  console.error('ERROR: patch target not found in ' + file);
  process.exit(1);
}

fs.writeFileSync(file, content.replace(from, to));
console.log('OK: getPhysicsLibURL now returns data URL');
"

echo "All iOS patches applied."
