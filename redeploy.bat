@echo off
setlocal
cd /d "%~dp0"

echo.
echo ============================================
echo  Natural Ground Organic - Redeploy
echo ============================================
echo.

echo === Stage and commit changes ===
git add .
git commit -m "Fix: transparent logo, real Adobe Stock hero image"
echo.

echo === Push to GitHub ===
git push origin main
echo.

echo === Deploy to Vercel ===
call npx -y vercel --prod
echo.

echo ============================================
echo  Done! Press any key to close.
echo ============================================
pause >nul
