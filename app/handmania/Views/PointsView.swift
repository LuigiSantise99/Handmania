//
//  PointsView.swift
//  handmania
//
//  Created by Mattia Gallotta on 22/03/23.
//

import SwiftUI

struct PointsView: View {
    @StateObject private var model = Model.getInstace()

    var body: some View {
        HStack {
            Spacer()
            Text("Score: ")
            Text(String(format: "%4d", model.getScore()))
            Spacer()
        }
        .padding()
        .background(
            Color.black
                .opacity(0.625)
        )
    }
}
