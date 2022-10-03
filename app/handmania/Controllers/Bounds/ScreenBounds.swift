//
//  ScreenBounds.swift
//  handmania
//
//  Created by Mattia Gallotta on 30/09/22.
//

import Vision

struct ScreenBounds {
    static let topLeft = VNPoint(x: 0, y: 0)
    static let topRight = VNPoint(x: 0, y: 1)
    static let bottomLeft = VNPoint(x: 1, y: 0)
    static let bottomRight = VNPoint(x: 1, y: 1)
}
