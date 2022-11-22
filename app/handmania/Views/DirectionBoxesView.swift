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
                DirectionBoxView(path: box.path)
                    .stroke(lineWidth: 5)
                    .fill(.green)
            }
        }
    }
}
