// server.js
const express = require('express');
const pdf = require('html-pdf');
const bodyParser = require('body-parser');
const fs = require('fs');
const cors = require('cors');

const app = express();
const port = 3000; // You can change this to any port you prefer

// Middleware to parse JSON and URL-encoded bodies
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: true }));

app.use(cors());


// Endpoint to generate PDF from HTML
app.post('/generate-pdf', (req, res) => {
    const htmlContent = req.body.html; // Assuming the HTML content is sent in the request body

    // Generate PDF from HTML content
    pdf.create(htmlContent).toStream((err, stream) => {
        if (err) {
            return res.status(500).send('Failed to generate PDF');
        }

        // Set response headers for PDF
        res.setHeader('Content-Type', 'application/pdf');
        res.setHeader('Content-Disposition', 'attachment; filename="generated_pdf.pdf"');

        // Pipe the PDF stream to response
        stream.pipe(res);
    });
});

// Start the server
app.listen(port, () => {
    console.log(`Server is running on port ${port}`);
});
