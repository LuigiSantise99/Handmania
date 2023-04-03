//
//  AlertStatus.swift
//  handmania
//
//  Created by Mattia Gallotta on 01/04/23.
//

import Foundation

class AlertStatus: ObservableObject {
    private static var INSTANCE: AlertStatus?
    
    private let logger = Logger(tag: String(describing: AlertStatus.self))
    
    @Published var showAlert = false
    
    /**
     Allows the user to get the game status.
     
     - Returns: True if the game started, false otherwise.
     */
    func markAlertAsToShow() {
        logger.log("alert marked as shown")
        self.showAlert = true
    }
    
    /**
     Allows the user to flag the game as started.
     */
    func resetAlert() {
        logger.log("alert marked as reset")
        self.showAlert = false
    }
    
    /**
     Allows the user to flag the game as stopped.
     */
    func getAlertStatus() -> Bool {
        return self.showAlert
    }
    
    public static func getInstace() -> AlertStatus {
        if self.INSTANCE == nil {
            self.INSTANCE = AlertStatus()
        }
        
        return self.INSTANCE!
    }
}
