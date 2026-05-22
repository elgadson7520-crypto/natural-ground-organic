@echo off
setlocal
cd /d "%~dp0"

echo.
echo ============================================
echo  Natural Ground Organic - GitHub + Vercel
echo ============================================
echo.

echo === Step 1: Reset and initialize git ===
if exist .git rmdir /s /q .git
git init -b main
git config user.email "elgadson7520@gmail.com"
git config user.name "Eric Gadson"
git remote add origin https://github.com/elgadson7520-crypto/natural-ground-organic.git
echo.

echo === Step 2: Stage and commit files ===
git add .
git commit -m "Initial commit: brand logo, palette refresh, product descriptions, hero photo"
echo.

echo === Step 3: Push to GitHub ===
git push -u origin main
if errorlevel 1 (
  echo.
  echo Push failed. If a GitHub credential prompt appeared, complete it and re-run this script.
  pause
  exit /b 1
)
echo.

echo === Step 4: Deploy to Vercel ===
echo (Using npx to run Vercel CLI - first run may prompt for login)
call npx -y vercel --prod
echo.

echo ============================================
echo  Done! Press any key to close.
echo ============================================
pause >nul
