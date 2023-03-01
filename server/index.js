const express = require("express")
const crypto = require("crypto")

// Required environment variables.
require("dotenv").config()

// Express app initialization.
const app = express()
const port = 3000

// The logger is imported and initialized.
const Logger = require("./utils/logger")
const logger = new Logger("index")

// Routers are gathered.
const songs = require("./routes/songs")
const chart = require("./routes/chart")

// Master password check.
app.use((req, res, next) => {
    const password = req.header("Authorization")

    logger.log(`received new request for ${req.url}`)

    // The master password is hashed with sha256 and saved in hex.
    if (!password || crypto.createHash("sha256").update(password).digest("hex") != process.env.HASHED_MASTER_PASSWORD) {
        logger.log(`incorrect master password "${password}", requiesting authentication`)

        res.setHeader("WWW-Authenticate", "Basic realm=\"Access to handmaina songs API\"")
        return res.sendStatus(401)
    }

    logger.log("all good, processing request")
    next()
})

// Routers are explicitly set.
app.use("/songs", songs)
app.use("/chart", chart)

// App starting on the specified port.
app.listen(port, () => {
    logger.log(`app listening on port ${port}`)
})
