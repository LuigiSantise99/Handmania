//
//  UIBezierPathAdapter.swift
//  handmania
//
//  Created by Mattia Gallotta on 04/10/22.
//

import SwiftUI
import UIKit

struct UIBezierPathAdapter: Shape {
    private let bezierPath: UIBezierPath
    
    init(bezierPath: UIBezierPath) {
        self.bezierPath = bezierPath
    }

    func path(in rect: CGRect) -> Path {
        let path = Path(bezierPath.cgPath)
        // A multipier to adapt the path to the container dimensions is needed.
        let multiplier = min(rect.width, rect.height)
        // The transofrmation is done.
        let transform = CGAffineTransform(scaleX: multiplier, y: multiplier)

        return path.applying(transform)
    }
}
