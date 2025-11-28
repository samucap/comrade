#!/bin/bash
echo "Diagnostics Start" > diag.log
node -v >> diag.log 2>&1
npm -v >> diag.log 2>&1
cat package.json >> diag.log 2>&1
ls -F node_modules/.bin/ >> diag.log 2>&1
rm -rf node_modules/.vite
echo "Cleaned vite cache" >> diag.log
npm run dev > run.log 2>&1 &
echo "Started dev server in background" >> diag.log
sleep 5
cat run.log >> diag.log 2>&1
echo "Diagnostics End" >> diag.log
