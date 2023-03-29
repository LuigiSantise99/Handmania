const express = require("express")
const mongo = require("mongodb")

// Required environment variables.
require("dotenv").config()

// Express router initialization.
const router = express.Router()

// The logger is imported and initialized.
const Logger = require("../utils/logger")
const logger = new Logger("songs")

/**
 * Returns all songs in the collection.
 */
router.get("/", async (_, res) => {
    logger.log("requested all songs")

    const mongoClient = new mongo.MongoClient(process.env.DB_CONNECTION_STRING)

    let songs = []
    try {
        await mongoClient.connect()

        const cursor = mongoClient.db(process.env.DB_NAME).collection(process.env.SONG_DB_COLLECTION_NAME).find({},
            { projection: { _id: 1, title: 1, artist: 1, genre: 1, preview: 1, spn: 1 } }
        )
        await cursor.forEach((result) => { songs.push(result) })
    } catch (exception) {
        logger.error(`an error occurred while gathering all songs from the DBMS - ${exception.message}`)
        return res.sendStatus(500)
    } finally {
        await mongoClient.close()
    }

    res.status(200).json(songs)
})

/**
 * Returns the notes of the song.
 * 
 * @param {String} id the id of the wanted song
 */
router.get("/:id/notes", async (req, res) => {
    let songId = req.params.id
    logger.log(`requested notes of song ${songId}`)

    const mongoClient = new mongo.MongoClient(process.env.DB_CONNECTION_STRING)

    let notes = {}
    try {
        await mongoClient.connect()

        notes = await mongoClient.db(process.env.DB_NAME).collection(process.env.SONG_DB_COLLECTION_NAME).findOne(
            { _id: mongo.ObjectId(songId) },
            { projection: { _id: 1, notes: 1 } }
        )
    } catch (exception) {
        logger.error(`an error occurred while gathering the note chart for the song ${songId} from the DBMS - ${exception.message}`)
        return res.sendStatus(500)
    } finally {
        await mongoClient.close()
    }

    res.status(200).json(notes)
})

/**
 * Returns the audio of the song in Base64.
 * 
 * @param {String} id the id of the wanted song
 */
router.get("/:id/audio", async (req, res) => {
    let songId = req.params.id
    logger.log(`requested audio of song ${songId}`)

    const mongoClient = new mongo.MongoClient(process.env.DB_CONNECTION_STRING)

    let audio = {}
    try {
        await mongoClient.connect()

        audio = await mongoClient.db(process.env.DB_NAME).collection(process.env.SONG_DB_COLLECTION_NAME).findOne(
            { _id: mongo.ObjectId(songId) },
            { projection: { _id: 1, audio: 1 } }
        )
    } catch (exception) {
        logger.error(`an error occurred while gathering the audio for the song ${songId} from the DBMS - ${exception.message}`)
        return res.sendStatus(500)
    } finally {
        await mongoClient.close()
    }

    res.status(200).json(audio)
})

/**
 * Returns the thumbnail of the song in Base64.
 * 
 * @param {String} id the id of the wanted song
 */
router.get("/:id/thumbnail", async (req, res) => {
    let songId = req.params.id
    logger.log(`requested thumbnail of song ${songId}`)

    const mongoClient = new mongo.MongoClient(process.env.DB_CONNECTION_STRING)

    let thumbnail = {}
    try {
        await mongoClient.connect()

        thumbnail = await mongoClient.db(process.env.DB_NAME).collection(process.env.SONG_DB_COLLECTION_NAME).findOne(
            { _id: mongo.ObjectId(songId) },
            { projection: { _id: 1, thumbnail: 1 } }
        )
    } catch (exception) {
        logger.error(`an error occurred while gathering the thumbnail for the song ${songId} from the DBMS - ${exception.message}`)
        return res.sendStatus(500)
    } finally {
        await mongoClient.close()
    }

    res.status(200).json(thumbnail)
})

module.exports = router
