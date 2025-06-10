const express = require('express');
const cors = require('cors'); // ✅ REQUIRED
const fs = require('fs');

const app = express();
const PORT = 8000;

// ✅ ENABLE CORS for all routes
app.use(cors());
app.use(express.json());

app.post('/', (req, res) => {
    const data = req.body;
    fs.writeFileSync('teachable_output.json', JSON.stringify(data, null, 2));
    res.sendStatus(200);
});

app.get('/teachable_output.json', (req, res) => {
    fs.readFile('teachable_output.json', (err, data) => {
        if (err) {
            res.status(500).send('File read error');
        } else {
            res.setHeader('Content-Type', 'application/json');
            res.send(data);
        }
    });
});

app.listen(PORT, () => {
    console.log(`✅ Server running at http://localhost:${PORT}`);
});