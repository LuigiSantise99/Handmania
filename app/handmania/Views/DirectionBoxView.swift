//
//  DirectionBoxView.swift
//  handmania
//
//  Created by Mattia Gallotta on 23/10/22.
//

import SwiftUI

struct DirectionBoxView: Shape {
    private var path = Path()
    
    private mutating func initializePath(p1: CGPoint, p2: CGPoint, p3: CGPoint, p4: CGPoint) {
        self.path.move(to: p1)
        self.path.addLine(to: p2)
        self.path.addLine(to: p3)
        self.path.addLine(to: p4)
    }
    
    init(p1: CGPoint, p2: CGPoint, p3: CGPoint, p4: CGPoint) {
        initializePath(p1: p1, p2: p2, p3: p3, p4: p4)
    }
    
    func path(in rect: CGRect) -> Path {
        // The path is adapted to fit the whole container.
        return self.path.applying(CGAffineTransform(scaleX: rect.width, y: rect.height))
    }
}
