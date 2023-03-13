//
//  NotesView.swift
//  handmania
//
//  Created by Mattia Gallotta on 27/02/23.
//

import Combine
import SwiftUI
import UIKit

struct NotesView: View {
    let notes : [Note]
    let timer: Publishers.Autoconnect<Timer.TimerPublisher>
    
    init(notes: [Note], spn: Float) {
        self.notes = notes
        
        // TODO: troppo veloce.
        self.timer = Timer.publish(every: TimeInterval(spn), on: .main, in: .common).autoconnect()
    }
    
    @State var currentIndex = 0
    
    var body: some View {
        ScrollView {
            ScrollViewReader { proxy in
                VStack {
                    ForEach(notes, id: \.index) { noteRow in
                        NoteView(notes: noteRow)
                            .frame(height: 16)
                            .padding(32)
                    }
                }
                .onReceive(timer) { _ in
                    self.currentIndex = self.currentIndex < self.notes.count - 1 ? self.currentIndex + 1 : 0
                    
                    withAnimation {
                        proxy.scrollTo(currentIndex)
                    }
                }
            }
        }
        .scrollIndicators(ScrollIndicatorVisibility.hidden)
        .scrollDisabled(true)
    }
}
