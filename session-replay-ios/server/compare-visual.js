#!/usr/bin/env node

const puppeteer = require('puppeteer');
const { createCanvas, loadImage } = require('canvas');
const pixelmatch = require('pixelmatch');
const fs = require('fs');
const path = require('path');

const SERVER_URL = 'http://localhost:3000';
const REAL_SCREENSHOT = '/tmp/ios_real.png';
const PLAYER_SCREENSHOT = '/tmp/ios_player.png';
const PLAYER_RAW = '/tmp/ios_player_raw.png';
const DIFF_OUTPUT = '/tmp/ios_diff.png';

async function capturePlayerScreenshot() {
    const browser = await puppeteer.launch({
        headless: false,
        args: [
            '--no-sandbox',
            '--disable-setuid-sandbox',
            '--force-color-profile=srgb'
        ]
    });
    
    const page = await browser.newPage();
    await page.setCacheEnabled(false);
    
    // Set viewport at 3x scale to avoid rescaling
    await page.setViewport({
        width: 1200,
        height: 1000,
        deviceScaleFactor: 3  // Match iOS @3x scale
    });
    
    const cacheBuster = Date.now();
    await page.goto(`${SERVER_URL}/player?t=${cacheBuster}`, { waitUntil: 'networkidle0' });
    
    await page.waitForSelector('.session-item', { timeout: 10000 });
    
    const sessions = await page.$$('.session-item');
    // Click last session (newest session with fixed color capture)
    await sessions[sessions.length - 1].click();
    
    await page.waitForSelector('#deviceScreen', { timeout: 10000 });
    await new Promise(r => setTimeout(r, 3000));
    
    // Get device screen bounds in CSS pixels
    const rect = await page.evaluate(() => {
        const ds = document.getElementById('deviceScreen');
        const r = ds.getBoundingClientRect();
        return { x: r.x, y: r.y, width: r.width, height: r.height };
    });
    
    // Take screenshot at full resolution (3x)
    await page.screenshot({ path: PLAYER_RAW, fullPage: false });
    await browser.close();
    
    // Load the 3x screenshot and crop (no scaling needed)
    const fullImg = await loadImage(PLAYER_RAW);
    
    // rect is in CSS pixels, but screenshot is at 3x, so multiply by 3
    const cropX = rect.x * 3;
    const cropY = rect.y * 3;
    const cropW = rect.width * 3;
    const cropH = rect.height * 3;
    
    const cropCanvas = createCanvas(cropW, cropH);
    const cropCtx = cropCanvas.getContext('2d');
    
    // No smoothing to preserve exact colors
    cropCtx.imageSmoothingEnabled = false;
    cropCtx.drawImage(
        fullImg,
        cropX, cropY, cropW, cropH,
        0, 0, cropW, cropH
    );
    
    fs.writeFileSync(PLAYER_SCREENSHOT, cropCanvas.toBuffer('image/png'));
    console.log(`Player screenshot saved to ${PLAYER_SCREENSHOT}`);
    console.log(`Cropped from (${cropX}, ${cropY}) size ${cropW}x${cropH}`);
}

async function compareScreenshots() {
    const img1 = await loadImage(REAL_SCREENSHOT);
    const img2 = await loadImage(PLAYER_SCREENSHOT);
    
    const width = Math.min(img1.width, img2.width);
    const height = Math.min(img1.height, img2.height);
    
    // Exclude status bar (top 59pt * scale = 177px at 3x)
    const statusBarHeight = 177;
    const compareHeight = height - statusBarHeight;
    
    console.log(`\nReal screenshot: ${img1.width}x${img1.height}`);
    console.log(`Player screenshot: ${img2.width}x${img2.height}`);
    console.log(`Comparing at: ${width}x${compareHeight} (excluding status bar)`);
    
    const canvas = createCanvas(width, compareHeight);
    const ctx = canvas.getContext('2d');
    
    // Draw real screenshot (excluding status bar)
    ctx.drawImage(img1, 0, statusBarHeight, width, compareHeight, 0, 0, width, compareHeight);
    const realData = ctx.getImageData(0, 0, width, compareHeight);
    
    // Draw player screenshot (excluding status bar)
    ctx.clearRect(0, 0, width, compareHeight);
    ctx.drawImage(img2, 0, statusBarHeight, width, compareHeight, 0, 0, width, compareHeight);
    const playerData = ctx.getImageData(0, 0, width, compareHeight);
    
    // Create diff image
    const diffCanvas = createCanvas(width, compareHeight);
    const diffCtx = diffCanvas.getContext('2d');
    const diffData = diffCtx.createImageData(width, compareHeight);
    
    // Compare with higher threshold to be more lenient with small differences
    const threshold = 0.15; // 15% difference threshold per pixel
    const numDiffPixels = pixelmatch(
        realData.data,
        playerData.data,
        diffData.data,
        width,
        compareHeight,
        { threshold: threshold, alpha: 0.5 }
    );
    
    // Save diff image
    diffCtx.putImageData(diffData, 0, 0);
    const diffBuffer = diffCanvas.toBuffer('image/png');
    fs.writeFileSync(DIFF_OUTPUT, diffBuffer);
    
    const totalPixels = width * compareHeight;
    const matchPercent = ((totalPixels - numDiffPixels) / totalPixels * 100).toFixed(2);
    
    console.log(`\n=== Visual Comparison Results ===`);
    console.log(`Total pixels: ${totalPixels}`);
    console.log(`Different pixels: ${numDiffPixels}`);
    console.log(`Match: ${matchPercent}%`);
    console.log(`\nDiff image saved to ${DIFF_OUTPUT}`);
    
    return {
        totalPixels,
        diffPixels: numDiffPixels,
        matchPercent: parseFloat(matchPercent)
    };
}

async function main() {
    try {
        console.log('=== Capturing Player Screenshot ===\n');
        await capturePlayerScreenshot();
        
        console.log('\n=== Comparing Screenshots ===');
        const result = await compareScreenshots();
        
        console.log(`\n=== Final Result ===`);
        if (result.matchPercent >= 95) {
            console.log(`✅ PASSED: ${result.matchPercent}% >= 95%`);
        } else {
            console.log(`❌ FAILED: ${result.matchPercent}% < 95%`);
            console.log(`Need to improve by ${(95 - result.matchPercent).toFixed(2)}%`);
        }
        
    } catch (error) {
        console.error('Error:', error.message);
        process.exit(1);
    }
}

main();
