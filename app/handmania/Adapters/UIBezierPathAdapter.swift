//
//  UIBezierPathAdapter.swift
//  handmania
//
//  Created by Mattia Gallotta on 04/10/22.
//

import SwiftUI
import UIKit

struct UIBezierPathAdapter: Shape {
    private let bezierPath = UIBezierPath()
    
    private func initializeUIBezierPath(p1: CGPoint, p2: CGPoint, p3: CGPoint, p4: CGPoint) {
        self.bezierPath.move(to: p1)
        self.bezierPath.addLine(to: p2)
        self.bezierPath.addLine(to: p3)
        self.bezierPath.addLine(to: p4)
        self.bezierPath.close()
    }
    
    init(p1: CGPoint, p2: CGPoint, p3: CGPoint, p4: CGPoint) {
        // Incoming coordinates needs to be adapted to the new plane.
        let newP1 = CGPoint(x: p1.x, y: 1 - p1.y)
        let newP2 = CGPoint(x: p2.x, y: 1 - p2.y)
        let newP3 = CGPoint(x: p3.x, y: 1 - p3.y)
        let newP4 = CGPoint(x: p4.x, y: 1 - p4.y)
        
        initializeUIBezierPath(p1: newP1, p2: newP2, p3: newP3, p4: newP4)
    }

    func path(in rect: CGRect) -> Path {
        // The path is adapted to fit the whole container.
        return Path(self.bezierPath.cgPath).applying(CGAffineTransform(scaleX: rect.width, y: rect.height))
    }
}
