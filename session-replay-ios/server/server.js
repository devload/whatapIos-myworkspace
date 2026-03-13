const express = require('express');
const cors = require('cors');
const fs = require('fs');
const path = require('path');
const { createCanvas, loadImage } = require('canvas');
const pixelmatch = require('pixelmatch');

const app = express();
const PORT = 3000;

app.use(cors());
app.use(express.json({ limit: '50mb' }));

const dataDir = path.join(__dirname, 'session-data');
if (!fs.existsSync(dataDir)) {
    fs.mkdirSync(dataDir, { recursive: true });
}

// Store screenshots for accuracy testing
const screenshotsDir = path.join(__dirname, 'screenshots');
if (!fs.existsSync(screenshotsDir)) {
    fs.mkdirSync(screenshotsDir, { recursive: true });
}

app.post('/api/events', (req, res) => {
    const { sessionId, events } = req.body;

    console.log(`[${new Date().toISOString()}] Received events for session: ${sessionId}`);
    console.log(`  Event count: ${events.length}`);

    // Debug: log first event's bounds
    if (events.length > 0 && events[0].data && events[0].data.root) {
        console.log(`  First event root bounds:`, JSON.stringify(events[0].data.root.bounds));
        console.log(`  First event root alpha:`, events[0].data.root.alpha);
    }

    events.forEach((event, index) => {
        console.log(`  [${index}] ${event.type} @ ${new Date(event.timestamp).toISOString()}`);
    });

    const sessionFile = path.join(dataDir, `${sessionId}.json`);

    let existingData = { sessionId, events: [] };
    if (fs.existsSync(sessionFile)) {
        try {
            existingData = JSON.parse(fs.readFileSync(sessionFile, 'utf8'));
        } catch (e) {
            console.error('Error reading existing session file:', e);
        }
    }

    existingData.events.push(...events);
    fs.writeFileSync(sessionFile, JSON.stringify(existingData, null, 2));

    res.json({ success: true, received: events.length });
});

app.post('/api/screenshot', (req, res) => {
    const { sessionId, screenshotIndex, imageData } = req.body;

    const screenshotFile = path.join(screenshotsDir, `${sessionId}_${screenshotIndex}.png`);
    const base64Data = imageData.replace(/^data:image\/png;base64,/, '');

    fs.writeFileSync(screenshotFile, base64Data, 'base64');
    console.log(`Saved screenshot: ${screenshotFile}`);

    res.json({ success: true });
});

app.get('/api/sessions', (req, res) => {
    const files = fs.readdirSync(dataDir).filter(f => f.endsWith('.json'));
    const sessions = files.map(file => {
        const data = JSON.parse(fs.readFileSync(path.join(dataDir, file), 'utf8'));
        return {
            sessionId: data.sessionId,
            eventCount: data.events.length,
            firstEvent: data.events[0]?.timestamp,
            lastEvent: data.events[data.events.length - 1]?.timestamp
        };
    });
    res.json(sessions);
});

app.get('/api/sessions/:sessionId', (req, res) => {
    const sessionFile = path.join(dataDir, `${req.params.sessionId}.json`);
    if (fs.existsSync(sessionFile)) {
        res.json(JSON.parse(fs.readFileSync(sessionFile, 'utf8')));
    } else {
        res.status(404).json({ error: 'Session not found' });
    }
});

app.get('/api/sessions/:sessionId/replay', (req, res) => {
    const sessionFile = path.join(dataDir, `${req.params.sessionId}.json`);
    if (fs.existsSync(sessionFile)) {
        const data = JSON.parse(fs.readFileSync(sessionFile, 'utf8'));
        const snapshots = data.events.filter(e => e.type === 'full_snapshot');
        res.json({ sessionId: data.sessionId, snapshots });
    } else {
        res.status(404).json({ error: 'Session not found' });
    }
});

app.delete('/api/sessions/:sessionId', (req, res) => {
    const sessionFile = path.join(dataDir, `${req.params.sessionId}.json`);
    if (fs.existsSync(sessionFile)) {
        fs.unlinkSync(sessionFile);
        res.json({ success: true });
    } else {
        res.status(404).json({ error: 'Session not found' });
    }
});

// Accuracy measurement endpoint
app.post('/api/accuracy/measure', async (req, res) => {
    const { sessionId, snapshotIndex, replayImageData } = req.body;

    const originalPath = path.join(screenshotsDir, `${sessionId}_${snapshotIndex}.png`);
    if (!fs.existsSync(originalPath)) {
        return res.status(404).json({ error: 'Original screenshot not found' });
    }

    try {
        const originalImg = await loadImage(originalPath);
        const replayImg = await loadImage(`data:image/png;base64,${replayImageData}`);

        const width = Math.max(originalImg.width, replayImg.width);
        const height = Math.max(originalImg.height, replayImg.height);

        const canvas1 = createCanvas(width, height);
        const canvas2 = createCanvas(width, height);

        const ctx1 = canvas1.getContext('2d');
        const ctx2 = canvas2.getContext('2d');

        ctx1.drawImage(originalImg, 0, 0);
        ctx2.drawImage(replayImg, 0, 0);

        const img1Data = ctx1.getImageData(0, 0, width, height);
        const img2Data = ctx2.getImageData(0, 0, width, height);
        const diffData = new Uint8Array(width * height * 4);

        const diffPixels = pixelmatch(img1Data.data, img2Data.data, diffData, width, height, {
            threshold: 0.1
        });

        const totalPixels = width * height;
        const accuracy = ((totalPixels - diffPixels) / totalPixels) * 100;

        res.json({
            accuracy: accuracy.toFixed(2),
            diffPixels,
            totalPixels,
            width,
            height
        });
    } catch (error) {
        console.error('Accuracy measurement error:', error);
        res.status(500).json({ error: error.message });
    }
});

app.get('/player', (req, res) => {
    res.sendFile(path.join(__dirname, 'player', 'index.html'));
});

app.get('/player/', (req, res) => {
    res.sendFile(path.join(__dirname, 'player', 'index.html'));
});

app.get('/', (req, res) => {
    res.redirect('/player/');
});

app.listen(PORT, () => {
    console.log(`Session Replay Server running at http://localhost:${PORT}`);
    console.log(`  API: http://localhost:${PORT}/api/events`);
    console.log(`  Player: http://localhost:${PORT}/player/`);
    console.log(`  Sessions: http://localhost:${PORT}/api/sessions`);
});
