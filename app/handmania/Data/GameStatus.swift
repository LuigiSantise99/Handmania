//
//  GameStatus.swift
//  handmania
//
//  Created by Mattia Gallotta on 30/03/23.
//

import Foundation

class GameStatus: ObservableObject {
    private static var INSTANCE: GameStatus?
    
    private let logger = Logger(tag: String(describing: GameStatus.self))
    
    @Published var gameStarted = false
    @Published var gameEnded = false
    @Published var scoreSubmitted = false
    
    /**
     Allows the user to get the game status.
     
     - Returns: True if the game started, false otherwise.
     */
    func gameDidStarted() -> Bool {
        return self.gameStarted
    }
    
    /**
     Allows the user to flag the game as started.
     */
    func startGame() {
        logger.log("game marked as started")
        self.gameStarted = true
    }
    
    /**
     Allows the user to flag the game as stopped.
     */
    func stopGame() {
        logger.log("game marked as stopped")
        self.gameStarted = false
    }
    
    /**
     Allows the user to get the game status.
     
     - Returns: True if the game ended, false otherwise.
     */
    func gameDidEnded() -> Bool {
        return self.gameEnded
    }
    
    /**
     Allows the user to flag the game as ended.
     */
    func endGame() {
        logger.log("game marked as ended")
        self.gameEnded = true
    }
    
    /**
     Allows the user to reset the end game flag.
     */
    func resetEndGame() {
        logger.log("game marked as resetted")
        self.gameEnded = false
    }
    
    /**
     Allows the user to get the score submission status.
     
     - Returns: True if the score was submittted, false otherwise.
     */
    func scoreDidSubmitted() -> Bool {
        return self.scoreSubmitted
    }
    
    /**
     Allows the user to flag the submission status as done.
     */
    func submitScore() {
        logger.log("score marked as submitted")
        self.scoreSubmitted = true
    }
    
    /**
     Allows the user to reset the score submission flag..
     */
    func resetSubmitScore() {
        logger.log("score submit status resetted")
        self.scoreSubmitted = false
    }
    
    public static func getInstace() -> GameStatus {
        if self.INSTANCE == nil {
            self.INSTANCE = GameStatus()
        }
        
        return self.INSTANCE!
    }
}
