//
//  HandDirection.swift
//  handmania
//
//  Created by Mattia Gallotta on 06/10/22.
//

import Foundation

struct HandDirection: CustomStringConvertible {
    let direction: Direction
    var timestamp: Date
    
    let formatter = DateFormatter()
    
    init(direction: Direction, timestamp: Date) {
        self.direction = direction
        self.timestamp = timestamp
        
        formatter.dateFormat = "HH:mm:ss:ms"
    }
    
    public var description: String { return "\(direction) @\(formatter.string(from: timestamp))" }
}
