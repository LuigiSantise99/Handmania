//
//  DirectionBox.swift
//  handmania
//
//  Created by Mattia Gallotta on 30/09/22.
//

import Foundation
import Vision
import UIKit

struct DirectionBox: Identifiable {
    let id = UUID()
    
    let p1: CGPoint
    let p2: CGPoint
    let p3: CGPoint
    let p4: CGPoint
    
    let path = UIBezierPath()
    
    private func initializeUIBezierPath() {
        path.move(to: self.p1)
        path.addLine(to: self.p2)
        path.addLine(to: self.p3)
        path.addLine(to: self.p4)
        path.close()
    }
    
    init(p1: VNPoint, p2: VNPoint, p3: VNPoint, p4: VNPoint) {
        self.p1 = p1.location
        self.p2 = p2.location
        self.p3 = p3.location
        self.p4 = p4.location
        
        initializeUIBezierPath()
    }
    
    func contains(point: VNPoint) -> Bool {
        return path.contains(point.location)
    }
}
