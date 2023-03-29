const express = require("express")
const mongo = require("mongodb")

// Required environment variables.
require("dotenv").config()

// Express router initialization.
const router = express.Router()

// The logger is imported and initialized.
const Logger = require("../utils/logger")
const logger = new Logger("chart")

/**
 * Returns the top 50 chart.
 */
router.get("/:id", async (req, res) => {
    let songId = req.params.id
    logger.log("requested chart")

    const mongoClient = new mongo.MongoClient(process.env.DB_CONNECTION_STRING)

    let chart = []
    try {
        mongoClient = new mongo.MongoClient(process.env.DB_CONNECTION_STRING)
        await mongoClient.connect()

        const cursor = mongoClient.db(process.env.DB_NAME).collection(process.env.CHART_DB_COLLECTION_NAME).find(
            { song_id: mongo.ObjectId(songId) })
            .sort({score : 1}).limit(50)
        await cursor.forEach((result) => { chart.push(result) })
    } catch (exception) {
        logger.error(`an error occurred while gathering the chart from the DBMS - ${exception.message}`)
        return res.sendStatus(500)
    } finally {
        await mongoClient.close()
    }

    res.status(200).json(chart)
})

// The middleware for JSON body requests is set.
router.use(express.json());

/**
 * Allows the user to submit a new chart entry
 */
router.post("/:id", async (req, res) => {
    let songId = req.params.id
    logger.log("submitted new chart entry")

    const mongoClient = new mongo.MongoClient(process.env.DB_CONNECTION_STRING)

    // The request body should contain only the name and the score.
    if (JSON.stringify(Object.keys(req.body).sort()) != JSON.stringify(['name', 'score'])) {
        logger.error('invalid json body')
        return res.sendStatus(401)
    }

    // The songId is checked...
    let databaseSongId = {}
    try {
        await mongoClient.connect()

        databaseSongId = await mongoClient.db(process.env.DB_NAME).collection(process.env.SONG_DB_COLLECTION_NAME).findOne(
            { _id: mongo.ObjectId(songId) })
    } catch (exception) {
        logger.error(`an error occurred while gathering the song ID from the DBMS - ${exception.message}`)
        return res.sendStatus(400)
    } finally {
        await mongoClient.close()
    }

    //... and inserted in the object.
    if (databaseSongId == {}) {
        logger.error('invalid song id specified.')
        return res.sendStatus(400)
    }

    req.body.song_id = mongo.ObjectId(songId)

    try {
        await mongoClient.connect()

        await mongoClient.db(process.env.DB_NAME).collection(process.env.CHART_DB_COLLECTION_NAME).insertOne(req.body)
    } catch (exception) {
        logger.error(`an error occurred while submitting the new chart entry in the DBMS - ${exception.message}`)
        return res.sendStatus(500)
    } finally {
        await mongoClient.close()
    }

    res.sendStatus(200)
})

module.exports = router
