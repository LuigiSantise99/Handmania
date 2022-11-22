//
//  DirectionBox.swift
//  handmania
//
//  Created by Mattia Gallotta on 30/09/22.
//

import Foundation
import Vision
import SwiftUI

struct DirectionBox: Identifiable {
    let id = UUID()
    var path = Path()
    
    init(p1: VNPoint, p2: VNPoint, p3: VNPoint, p4: VNPoint) {
        self.path.move(to: p1.location)
        self.path.addLine(to: p2.location)
        self.path.addLine(to: p3.location)
        self.path.addLine(to: p4.location)
    }
    
    /**
     Checks is the specified point is containment in the saved path.
     
     - Parameter point: The point to check the containment on.
    
     - Returns `true` if the point is in the path, `false` otherwise.
     */
    func contains(point: VNPoint) -> Bool {
        return path.contains(point.location)
    }
}
