const express = require('express');
const { exec } = require('child_process');
const app = express();
const port = 3000;

// Scan the network for devices
function scanNetwork(callback) {
    // Run the arp-scan command
    exec('sudo arp-scan --localnet', (err, stdout, stderr) => {
        // If an error occurs, call the callback with the error
        if (err) {
            callback(err, null);
            return;
        }

        // Split the output into lines
        const lines = stdout.split('\n');
        const devices = [];
        // Parse each line and extract the IP, MAC, and vendor
        lines.forEach(line => {
            const match = line.match(/(\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3})\s+([0-9A-Fa-f:]{17})\s+(.*)/);
            if (match) {
                devices.push({
                    ip: match[1],
                    mac: match[2],
                    vendor: match[3].trim()
                });
            }
        });
        // Call the callback with the list of devices
        callback(null, devices);
    });
}

// Fonction de comparaison pour trier les adresses IP
function compareIPs(a, b) {
    const ipA = a.ip.split('.').map(Number);
    const ipB = b.ip.split('.').map(Number);

    for (let i = 0; i < ipA.length; i++) {
        if (ipA[i] < ipB[i]) return -1;
        if (ipA[i] > ipB[i]) return 1;
    }
    return 0;
}

// Define a route to scan the network
app.get('/scan', (req, res) => {
    // Call the scanNetwork function
    scanNetwork((err, data) => {
        // If an error occurs, send a 500 error response
        if (err) {
            res.status(500).send({ error: 'Error scanning network' });
            return;
        }
        // Trier les appareils par adresse IP avant de les envoyer
        const sortedData = data.sort(compareIPs);
        // Send the sorted list of devices as a JSON response
        res.json(sortedData);
    });
});

// Route pour filtrer les appareils par IP
app.get('/scan_ip', (req, res) => {
    // Vérifier si le paramètre ip est présent dans la requête
    if (!req.query.ip) {
        return res.status(400).send('Le paramètre ip est manquant dans la requête.');
    }

    const ipToFind = req.query.ip;

    scanNetwork((err, data) => {
        if (err) {
            res.status(500).send({ error: 'Erreur lors du scan du réseau' });
            return;
        }
        const filteredDevices = data.filter(device => device.ip === ipToFind);
        if (filteredDevices.length === 0) {
            // Réponse 404 si aucun appareil n'est trouvé
            return res.status(404).send(`Aucun appareil trouvé avec l'adresse IP : ${ipToFind}`);
        }
        res.json(filteredDevices);
    });
});

// Route pour filtrer les appareils par adresse MAC
app.get('/scan_mac', (req, res) => {
    // Vérifier si le paramètre mac est présent dans la requête
    if (!req.query.mac) {
        return res.status(400).send('Le paramètre mac est manquant dans la requête.');
    }

    const macToFind = req.query.mac;

    scanNetwork((err, data) => {
        if (err) {
            // Trace en cas d'erreur du scan
            return res.status(500).send({ error: 'Erreur lors du scan du réseau' });
        }

        const filteredDevices = data.filter(device => device.mac === macToFind);
        if (filteredDevices.length === 0) {
            // Réponse 404 si aucun appareil n'est trouvé
            return res.status(404).send(`Aucun appareil trouvé avec l'adresse MAC : ${macToFind}`);
        }
        res.json(filteredDevices);
    });
});

// Start the server
app.listen(port, () => {
    console.log(`Server running at http://localhost:${port}/`);
});
