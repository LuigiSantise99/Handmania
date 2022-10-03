//
//  DirectionBox.swift
//  handmania
//
//  Created by Mattia Gallotta on 30/09/22.
//

import Foundation
import Vision
import UIKit

struct DirectionBox {
    private let path = UIBezierPath()
    
    init(p1: VNPoint, p2: VNPoint, p3: VNPoint, p4: VNPoint) {
        path.move(to: p1.location)
        path.addLine(to: p2.location)
        path.addLine(to: p3.location)
        path.addLine(to: p4.location)
        path.close()
    }
    
    func contains(point: VNPoint) -> Bool {
        return path.contains(point.location)
    }
}
