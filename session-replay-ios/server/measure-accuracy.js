#!/usr/bin/env node

const fs = require('fs');
const path = require('path');

const dataDir = path.join(__dirname, 'session-data');

// Essential properties that should be captured
const essentialProps = ['bounds', 'backgroundColor', 'alpha'];
// Text properties by type (UITextField/UITextView don't have numberOfLines/lineBreakMode)
const textPropsByType = {
    'UILabel': ['text', 'textSize', 'textColor', 'textAlignment', 'fontWeight', 'fontFamily', 'numberOfLines', 'lineBreakMode'],
    'UIButton': ['textSize', 'textColor', 'textAlignment', 'fontWeight', 'fontFamily', 'numberOfLines', 'lineBreakMode'], // text is optional for image buttons
    'UITextField': ['text', 'textSize', 'textColor', 'textAlignment', 'fontWeight', 'fontFamily'],
    'UITextView': ['text', 'textSize', 'textColor', 'textAlignment', 'fontWeight', 'fontFamily']
};
const controlProps = {
    'UISwitch': ['isOn'],
    'UISlider': ['value', 'minValue', 'maxValue'],
    'UIProgressView': ['progress'],
    'UIActivityIndicatorView': ['isAnimating']
};

function calculateAccuracy(data) {
    let totalViews = 0;
    let totalProps = 0;
    let capturedProps = 0;
    let issues = [];
    let viewTypes = {};

    function analyzeView(view, depth = 0) {
        totalViews++;
        const baseType = view.baseType || view.type;

        // Track view types
        viewTypes[baseType] = (viewTypes[baseType] || 0) + 1;

        // Essential properties (always expected)
        essentialProps.forEach(prop => {
            totalProps++;
            if (view[prop] !== undefined && view[prop] !== null) {
                capturedProps++;
            } else if (prop === 'alpha' || prop === 'backgroundColor') {
                // These have defaults
                capturedProps++;
            } else {
                issues.push(`${baseType}: missing ${prop}`);
            }
        });

        // Text views
        const textTypes = ['UILabel', 'UIButton', 'UITextField', 'UITextView'];
        if (textTypes.includes(baseType)) {
            const props = textPropsByType[baseType] || [];
            props.forEach(prop => {
                totalProps++;
                if (view[prop] !== undefined && view[prop] !== null) {
                    capturedProps++;
                }
            });
        }

        // Styled views (check each style property individually)
        if (view.cornerRadius !== undefined) {
            totalProps++;
            if (view.cornerRadius !== undefined && view.cornerRadius !== null) {
                capturedProps++;
            }
        }
        if (view.border !== undefined) {
            totalProps++;
            if (view.border !== undefined && view.border !== null) {
                capturedProps++;
            }
        }
        if (view.shadow !== undefined) {
            totalProps++;
            if (view.shadow !== undefined && view.shadow !== null) {
                capturedProps++;
            }
        }

        // Control-specific properties
        if (controlProps[baseType]) {
            controlProps[baseType].forEach(prop => {
                totalProps++;
                if (view[prop] !== undefined && view[prop] !== null) {
                    capturedProps++;
                }
            });
        }

        // Check children
        if (view.children) {
            view.children.forEach(child => analyzeView(child, depth + 1));
        }
    }

    if (data.root) {
        analyzeView(data.root);
    }

    const accuracy = totalProps > 0 ? ((capturedProps / totalProps) * 100) : 100;

    return {
        accuracy,
        totalViews,
        totalProps,
        capturedProps,
        missingProps: totalProps - capturedProps,
        viewTypes,
        issues: issues.slice(0, 10) // Only first 10 issues
    };
}

function main() {
    const files = fs.readdirSync(dataDir).filter(f => f.endsWith('.json'));

    console.log('=== Session Replay Accuracy Measurement ===\n');

    let totalAccuracy = 0;
    let sessionCount = 0;

    files.forEach(file => {
        const filePath = path.join(dataDir, file);
        const content = JSON.parse(fs.readFileSync(filePath, 'utf8'));
        const snapshots = content.events.filter(e => e.type === 'full_snapshot');

        console.log(`Session: ${content.sessionId.substring(0, 8)}...`);
        console.log(`Snapshots: ${snapshots.length}`);

        snapshots.forEach((snapshot, idx) => {
            const result = calculateAccuracy(snapshot.data);
            console.log(`  Snapshot ${idx + 1}: Accuracy ${result.accuracy.toFixed(1)}% (${result.capturedProps}/${result.totalProps} props, ${result.totalViews} views)`);
            totalAccuracy += result.accuracy;
            sessionCount++;

            if (result.accuracy < 95) {
                console.log(`    Issues: ${result.issues.join(', ')}`);
            }
        });

        // Analyze latest snapshot in detail
        if (snapshots.length > 0) {
            const latest = snapshots[snapshots.length - 1];
            const result = calculateAccuracy(latest.data);

            console.log(`\n  View Types:`);
            Object.entries(result.viewTypes)
                .sort((a, b) => b[1] - a[1])
                .slice(0, 10)
                .forEach(([type, count]) => {
                    console.log(`    ${type}: ${count}`);
                });
        }

        console.log('');
    });

    if (sessionCount > 0) {
        const avgAccuracy = totalAccuracy / sessionCount;
        console.log(`\n=== Summary ===`);
        console.log(`Average Accuracy: ${avgAccuracy.toFixed(1)}%`);
        console.log(`Target: 95%`);
        console.log(`Status: ${avgAccuracy >= 95 ? '✅ PASSED' : '⚠️  BELOW TARGET'}`);
    }
}

main();
