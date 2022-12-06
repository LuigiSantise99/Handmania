//
//  DirectionBoxesView.swift
//  handmania
//
//  Created by Mattia Gallotta on 04/10/22.
//

import SwiftUI

struct DirectionBoxesView: View {
    var directionBoxes: [DirectionBox]
    
    var body: some View {
        ForEach(directionBoxes) { box in
            DirectionBoxView(path: box.path)
                .stroke(lineWidth: 5)
                .fill(.green)
        }
    }
}
