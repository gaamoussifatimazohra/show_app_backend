// server.js
require('dotenv').config(); // Charge les variables d'environnement (.env)
const express = require('express');
const bodyParser = require('body-parser');
const cors = require('cors');
const db = require('./database'); // Importe la configuration SQLite

// Initialisation de l'application
const app = express();
const PORT = process.env.PORT || 5000; // Utilise le port du .env ou 5000 par défaut

// Middlewares
app.use(cors()); // Autorise les requêtes cross-origin (depuis Flutter)
app.use(bodyParser.json()); // Traite les données JSON des requêtes
app.use('/uploads', express.static('uploads')); // Serve les fichiers statiques (images)

// Importe les routes des shows
const showRoutes = require('./routes/shows');
app.use('/shows', showRoutes); // Toutes les routes commençant par /shows

// Route de test simple
app.get('/', (req, res) => {
  res.send('🎬 Backend opérationnel !');
});

// Gestion des erreurs 404
app.use((req, res) => {
  res.status(404).json({ error: 'Route non trouvée' });
});

// Démarrage du serveur avec message de confirmation
app.listen(PORT, () => {
  console.log(`✅ Serveur démarré sur http://localhost:${PORT}`);
  console.log(`📡 Routes disponibles :`);
  console.log(`- GET / => Test du serveur`);
  console.log(`- GET /shows => Liste des films/séries`);
  console.log(`- POST /shows => Ajouter un show (avec image)`);
});