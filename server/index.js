const express = require("express")
const mongo = require("mongodb")
const crypto = require("crypto")

// Required environment variables.
require("dotenv").config()

// Express app initialization.
const app = express()
const port = 3000

// MongoClient initialization.
const mongoClient = new mongo.MongoClient(process.env.DB_CONNECTION_STRING)

/**
 * Prints a server log given the message.
 * 
 * @param {String} message the message to print 
 */
function log(message) {
    console.log(`${process.env.APP_NAME}: ${message}`)
}

/**
 * Prints a server log error given the message.
 * 
 * @param {String} message the message to print 
 */
function error(message) {
    console.error(`${process.env.APP_NAME}: (err) ${message}`)
}

// Master password check.
app.use((req, res, next) => {
    const password = req.header("Authorization")

    log(`received new request for ${req.url}`)

    // The master password is hashed with sha256 and saved in hex.
    if (!password || crypto.createHash("sha256").update(password).digest("hex") != process.env.HASHED_MASTER_PASSWORD) {
        log(`incorrect master password "${password}", requiesting authentication`)

        res.setHeader("WWW-Authenticate", "Basic realm=\"Access to handmaina songs API\"")
        return res.sendStatus(401)
    }

    log("all good, processing request")
    next()
})

/**
 * Returns all songs in the collection.
 */
app.get("/songs", async (_, res) => {
    log("requested all songs")

    let songs = []
    try {
        await mongoClient.connect()

        const cursor = mongoClient.db(process.env.DB_NAME).collection(process.env.DB_COLLECTION_NAME).find({},
            { projection: { _id: 1, title: 1, artist: 1, genre: 1, start: 1, length: 1, bpms: 1 } }
        )
        await cursor.forEach((result) => { songs.push(result) })
    } catch (exception) {
        error(`an error occurred while gathering all songs from the DBMS - ${exception.message}`)
        return res.sendStatus(500)
    } finally {
        await mongoClient.close()
    }

    res.status(200).json(songs)
})

/**
 * Returns the audio of the song in Base64.
 * 
 * @param {String} id the id of the wanted song
 */
app.get("/song/:id/audio", async (req, res) => {
    let songId = req.params.id
    log(`requested audio of song ${songId}`)

    let audio = {}
    try {
        await mongoClient.connect()

        audio = await mongoClient.db(process.env.DB_NAME).collection(process.env.DB_COLLECTION_NAME).findOne(
            { _id: mongo.ObjectId(songId) },
            { projection: { _id: 1, b64: 1 } }
        )
    } catch (exception) {
        error(`an error occurred while gathering the audio for the song ${songId} from the DBMS - ${exception.message}`)
        return res.sendStatus(500)
    } finally {
        await mongoClient.close()
    }

    res.status(200).json(audio)
})

/**
 * Returns the notes of the song.
 * 
 * @param {String} id the id of the wanted song
 */
app.get("/song/:id/notes", async (req, res) => {
    let songId = req.params.id
    log(`requested notes of song ${songId}`)

    let notes = {}
    try {
        await mongoClient.connect()

        notes = await mongoClient.db(process.env.DB_NAME).collection(process.env.DB_COLLECTION_NAME).findOne(
            { _id: mongo.ObjectId(songId) },
            { projection: { _id: 1, notes: 1 } }
        )
    } catch (exception) {
        error(`an error occurred while gathering the note chart for the song ${songId} from the DBMS - ${exception.message}`)
        return res.sendStatus(500)
    } finally {
        await mongoClient.close()
    }

    res.status(200).json(notes)
})

// App starting on the specified port.
app.listen(port, () => {
    log(`app listening on port ${port}`)
})
