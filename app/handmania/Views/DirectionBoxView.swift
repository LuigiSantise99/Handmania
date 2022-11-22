//
//  DirectionBoxView.swift
//  handmania
//
//  Created by Mattia Gallotta on 23/10/22.
//

import SwiftUI

struct DirectionBoxView: Shape {
    private var path = Path()
    
    init(path: Path) {
        self.path = path
    }
    
    func path(in rect: CGRect) -> Path {
        // The path is adapted to fit the whole container.
        return self.path.applying(CGAffineTransform(scaleX: rect.width, y: rect.height))
    }
}
