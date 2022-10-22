//
//  DirectionBoxesView.swift
//  handmania
//
//  Created by Mattia Gallotta on 04/10/22.
//

import SwiftUI

struct DirectionBoxesView: View {
    @ObservedObject var directionsModel: DirectionsModel

    var body: some View {
        if let directionBoxes = directionsModel.directionBoxes?.values {
            ForEach(Array(directionBoxes)) { box in
                UIBezierPathAdapter(p1: box.p1, p2: box.p2, p3: box.p3, p4: box.p4)
                    .stroke(lineWidth: 5)
                    .fill(.green)
            }
        }
    }
}
