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
    
    let p1: CGPoint
    let p2: CGPoint
    let p3: CGPoint
    let p4: CGPoint
    
    var path = Path()
    
    private mutating func initializePath() {
        path.move(to: self.p1)
        path.addLine(to: self.p2)
        path.addLine(to: self.p3)
        path.addLine(to: self.p4)
    }
    
    init(p1: VNPoint, p2: VNPoint, p3: VNPoint, p4: VNPoint) {
        self.p1 = p1.location
        self.p2 = p2.location
        self.p3 = p3.location
        self.p4 = p4.location
        
        initializePath()
    }
    
    func contains(point: VNPoint) -> Bool {
        return path.contains(point.location)
    }
}
