const express = require('express'); // Import our Express dependency

const app = express(); // Create a new server instance
const PORT = 8080; // Port number we want to use of this server
const html_path = __dirname + '/templates/'; // HTML files folder

// Set up Middleware
app.use(express.static('static'));
app.use(express.urlencoded());

// Routes
app.get('/', (req, res) => {
    res.sendFile(html_path + 'colorpuzzle.html');
});


// As our server to listen for incoming connections
app.listen(PORT, () => console.log(`Server listening on port: ${PORT}`));