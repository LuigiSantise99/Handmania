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
    
    public var description: String { return "\(direction) @\(timestamp)" }
}
