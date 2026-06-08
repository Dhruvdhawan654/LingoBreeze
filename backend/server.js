require("dotenv").config();
const express = require("express");
const cors = require("cors");

// ─── Firebase Admin Initialization (with fallback) ───────────────────────────

let db = null;
let useInMemory = false;

// In-memory store for demo/development mode
let inMemoryWords = [
  {
    id: "demo-1",
    word: "Apple",
    meaning: "A round fruit with red or green skin",
    translation: "Manzana",
    createdAt: new Date("2026-06-07T10:00:00Z"),
  },
  {
    id: "demo-2",
    word: "Beautiful",
    meaning: "Pleasing to the senses or mind",
    translation: "Hermosa",
    createdAt: new Date("2026-06-07T09:30:00Z"),
  },
  {
    id: "demo-3",
    word: "Sunshine",
    meaning: "Direct sunlight unbroken by cloud",
    translation: "Sol",
    createdAt: new Date("2026-06-07T09:00:00Z"),
  },
];

try {
  const admin = require("firebase-admin");
  const fs = require("fs");
  const keyPath =
    process.env.GOOGLE_APPLICATION_CREDENTIALS || "./serviceAccountKey.json";

  if (fs.existsSync(keyPath)) {
    const serviceAccount = require(keyPath);
    admin.initializeApp({
      credential: admin.credential.cert(serviceAccount),
    });
    db = admin.firestore();
    console.log("✅ Connected to Firebase Firestore");
  } else {
    throw new Error("Service account key not found");
  }
} catch (error) {
  useInMemory = true;
  console.log("⚠️  Firebase not configured — running in DEMO mode (in-memory storage)");
  console.log(`   Reason: ${error.message}`);
  console.log("   To connect Firebase, add your serviceAccountKey.json\n");
}

// ─── Express App Setup ──────────────────────────────────────────────────────

const app = express();
const PORT = process.env.PORT || 3000;

app.use(cors());
app.use(express.json());

// ─── Health Check ────────────────────────────────────────────────────────────

app.get("/", (req, res) => {
  res.json({
    status: "ok",
    service: "LingoBreeze API",
    version: "1.0.0",
    mode: useInMemory ? "demo (in-memory)" : "production (Firestore)",
    timestamp: new Date().toISOString(),
  });
});

// ─── GET /words ──────────────────────────────────────────────────────────────

app.get("/words", async (req, res) => {
  try {
    let words;

    if (useInMemory) {
      // In-memory mode: return demo data
      words = inMemoryWords
        .sort((a, b) => b.createdAt - a.createdAt)
        .map((w) => ({
          ...w,
          createdAt: w.createdAt.toISOString(),
        }));
    } else {
      // Firestore mode
      const snapshot = await db
        .collection("words")
        .orderBy("createdAt", "desc")
        .get();

      words = snapshot.docs.map((doc) => ({
        id: doc.id,
        ...doc.data(),
        createdAt: doc.data().createdAt?.toDate
          ? doc.data().createdAt.toDate().toISOString()
          : doc.data().createdAt,
      }));
    }

    res.json({
      success: true,
      count: words.length,
      data: words,
    });
  } catch (error) {
    console.error("Error fetching words:", error);
    res.status(500).json({
      success: false,
      error: "Failed to fetch words",
      message:
        process.env.NODE_ENV === "development"
          ? error.message
          : "Internal server error",
    });
  }
});

// ─── POST /words ─────────────────────────────────────────────────────────────
// Bonus: Also accept word creation via API for flexibility.

app.post("/words", async (req, res) => {
  try {
    const { word, meaning, translation } = req.body;

    if (!word || !meaning || !translation) {
      return res.status(400).json({
        success: false,
        error: "Missing required fields: word, meaning, translation",
      });
    }

    let newWord;

    if (useInMemory) {
      const createdAt = new Date();
      newWord = {
        id: `word-${Date.now()}`,
        word: word.trim(),
        meaning: meaning.trim(),
        translation: translation.trim(),
        createdAt: createdAt,
      };
      inMemoryWords.push(newWord);
      // Return ISO string in response without mutating the stored object
      newWord = { ...newWord, createdAt: createdAt.toISOString() };
    } else {
      const docRef = await db.collection("words").add({
        word: word.trim(),
        meaning: meaning.trim(),
        translation: translation.trim(),
        createdAt: require("firebase-admin").firestore.FieldValue.serverTimestamp(),
      });
      newWord = {
        id: docRef.id,
        word: word.trim(),
        meaning: meaning.trim(),
        translation: translation.trim(),
        createdAt: new Date().toISOString(),
      };
    }

    res.status(201).json({
      success: true,
      data: newWord,
    });
  } catch (error) {
    console.error("Error adding word:", error);
    res.status(500).json({
      success: false,
      error: "Failed to add word",
    });
  }
});

// ─── DELETE /words/:id ───────────────────────────────────────────────────────

app.delete("/words/:id", async (req, res) => {
  try {
    const { id } = req.params;

    if (useInMemory) {
      inMemoryWords = inMemoryWords.filter((w) => w.id !== id);
    } else {
      await db.collection("words").doc(id).delete();
    }

    res.json({ success: true, message: "Word deleted" });
  } catch (error) {
    console.error("Error deleting word:", error);
    res.status(500).json({
      success: false,
      error: "Failed to delete word",
    });
  }
});

// ─── 404 Handler ─────────────────────────────────────────────────────────────

app.use((req, res) => {
  res.status(404).json({
    success: false,
    error: "Not Found",
    message: `Route ${req.method} ${req.originalUrl} not found`,
  });
});

// ─── Global Error Handler ────────────────────────────────────────────────────

app.use((err, req, res, _next) => {
  console.error("Unhandled error:", err);
  res.status(500).json({
    success: false,
    error: "Internal Server Error",
  });
});

// ─── Start Server (local only — Vercel uses the exported app) ────────────────

if (!process.env.VERCEL) {
  app.listen(PORT, () => {
    console.log(`\n🚀 LingoBreeze API running on http://localhost:${PORT}`);
    console.log(`📚 GET  /words      →  Retrieve all vocabulary words`);
    console.log(`📝 POST /words      →  Add a new word`);
    console.log(`🗑️  DELETE /words/:id →  Delete a word`);
    console.log(`\nMode: ${useInMemory ? "🟡 DEMO (in-memory)" : "🟢 PRODUCTION (Firestore)"}\n`);
  });
}

// Export for Vercel serverless
module.exports = app;

