class Logger {
    /**
     * Initializes the logger class.
     * 
     * @param {string} tag the tag of the class where the logger will log.
     */
    constructor(tag) {
        this.tag = `${process.env.APP_NAME} (${tag})`.toUpperCase()
    }

    /**
     * Prints a server log given the message.
     * 
     * @param {String} message the message to print 
     */
    log(message) {
        console.log(`${this.tag}: ${message}`)
    }

    /**
     * Prints a server log error given the message.
     * 
     * @param {String} message the message to print 
     */
    error(message) {
        console.error(`${this.tag}: (err) ${message}`)
    }
}

module.exports = Logger
