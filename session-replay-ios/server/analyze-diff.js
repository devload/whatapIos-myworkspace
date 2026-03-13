#!/usr/bin/env node

const { createCanvas, loadImage } = require('canvas');
const fs = require('fs');

const REAL_IMG = '/tmp/ios_real.png';
const PLAYER_IMG = '/tmp/ios_player.png';
const DIFF_IMG = '/tmp/ios_diff.png';

async function analyzeDifferences() {
    const img1 = await loadImage(REAL_IMG);
    const img2 = await loadImage(PLAYER_IMG);
    
    const width = Math.min(img1.width, img2.width);
    const height = Math.min(img1.height, img2.height);
    
    const canvas1 = createCanvas(width, height);
    const ctx1 = canvas1.getContext('2d');
    ctx1.drawImage(img1, 0, 0, width, height);
    const data1 = ctx1.getImageData(0, 0, width, height);
    
    const canvas2 = createCanvas(width, height);
    const ctx2 = canvas2.getContext('2d');
    ctx2.drawImage(img2, 0, 0, width, height);
    const data2 = ctx2.getImageData(0, 0, width, height);
    
    // Analyze by regions (divide screen into 10x10 grid)
    const gridSize = 10;
    const cellW = Math.floor(width / gridSize);
    const cellH = Math.floor(height / gridSize);
    
    const regions = [];
    
    for (let gy = 0; gy < gridSize; gy++) {
        for (let gx = 0; gx < gridSize; gx++) {
            let diffCount = 0;
            let totalPixels = 0;
            
            for (let y = gy * cellH; y < (gy + 1) * cellH && y < height; y++) {
                for (let x = gx * cellW; x < (gx + 1) * cellW && x < width; x++) {
                    const i = (y * width + x) * 4;
                    const r1 = data1.data[i];
                    const g1 = data1.data[i + 1];
                    const b1 = data1.data[i + 2];
                    const r2 = data2.data[i];
                    const g2 = data2.data[i + 1];
                    const b2 = data2.data[i + 2];
                    
                    const diff = Math.abs(r1 - r2) + Math.abs(g1 - g2) + Math.abs(b1 - b2);
                    if (diff > 30) { // Threshold for significant difference
                        diffCount++;
                    }
                    totalPixels++;
                }
            }
            
            const diffPercent = (diffCount / totalPixels * 100).toFixed(1);
            regions.push({
                x: gx * cellW,
                y: gy * cellH,
                diffPercent: parseFloat(diffPercent)
            });
        }
    }
    
    // Sort by difference percentage
    regions.sort((a, b) => b.diffPercent - a.diffPercent);
    
    console.log('=== Top 10 Different Regions ===');
    console.log('(Screen divided into 10x10 grid)\n');
    
    regions.slice(0, 10).forEach((r, i) => {
        console.log(`${i + 1}. Position (${r.x}, ${r.y}): ${r.diffPercent}% different`);
    });
    
    // Analyze color distribution differences
    console.log('\n=== Color Analysis ===');
    
    let missingTextCount = 0;
    let missingImageCount = 0;
    let colorMismatchCount = 0;
    
    for (let y = 0; y < height; y += 10) {
        for (let x = 0; x < width; x += 10) {
            const i = (y * width + x) * 4;
            
            const r1 = data1.data[i];
            const g1 = data1.data[i + 1];
            const b1 = data1.data[i + 2];
            const r2 = data2.data[i];
            const g2 = data2.data[i + 1];
            const b2 = data2.data[i + 2];
            
            // Real has content, player is white/background
            const realIsDark = (r1 + g1 + b1) < 500;
            const playerIsLight = (r2 + g2 + b2) > 600;
            
            if (realIsDark && playerIsLight) {
                missingTextCount++;
            }
            
            // Check for image/icon differences (colorful areas)
            const realVariance = Math.abs(r1 - g1) + Math.abs(g1 - b1);
            const playerVariance = Math.abs(r2 - g2) + Math.abs(g2 - b2);
            
            if (realVariance > 50 && playerVariance < 20) {
                missingImageCount++;
            }
        }
    }
    
    console.log(`Potential missing text areas: ${missingTextCount}`);
    console.log(`Potential missing image/icon areas: ${missingImageCount}`);
    
    // Sample specific areas that are problematic
    console.log('\n=== Sample Pixel Comparisons ===');
    
    const samples = [
        { x: 50, y: 100, label: 'Header area' },
        { x: 196, y: 426, label: 'Center area' },
        { x: 50, y: 750, label: 'Tab bar area' }
    ];
    
    samples.forEach(s => {
        const i = (s.y * width + s.x) * 4;
        console.log(`\n${s.label} (${s.x}, ${s.y}):`);
        console.log(`  Real: RGB(${data1.data[i]}, ${data1.data[i+1]}, ${data1.data[i+2]})`);
        console.log(`  Player: RGB(${data2.data[i]}, ${data2.data[i+1]}, ${data2.data[i+2]})`);
    });
}

analyzeDifferences().catch(console.error);
