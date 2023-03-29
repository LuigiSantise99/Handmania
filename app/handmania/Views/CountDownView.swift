//
//  CountDownView.swift
//  handmania
//
//  Created by Mattia Gallotta on 24/03/23.
//

import Combine
import SwiftUI

struct CountDownView: View {
    private let timer = Timer.publish(every: TimeInterval(1.0), on: .main, in: .common).autoconnect()

    let container: GeometryProxy
    
    @State var progressive = 3
    
    var body: some View {
        HStack(alignment: .center) {
            NumberParser.parseNumber(number: progressive)
                .frame(width: 90, height: 90)
        }
        .onReceive(timer) { _ in
            self.progressive -= 1
            
            if self.progressive == 0 {
                self.timer.upstream.connect().cancel()
                Model.getInstace().startGame()
            }
        }
        .frame(width: container.size.width, height: container.size.height)
        .background(
            Color.black
                .opacity(0.625)
        )
    }
}
