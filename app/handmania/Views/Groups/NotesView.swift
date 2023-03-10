//
//  NotesView.swift
//  handmania
//
//  Created by Mattia Gallotta on 27/02/23.
//

import SwiftUI

struct NotesView: View {
    let notes: [[Int]]
    let spn: Float
    
    var body: some View {
        ScrollViewReader { scrollView in
            ScrollView {
                ForEach(notes, id: \.self) { noteRow in
                    NoteView(notes: noteRow)
                        .frame(height: 16)
                        .padding(32)
                }
            }
            .scrollIndicators(ScrollIndicatorVisibility.hidden)
            //.scrollDisabled(true)
            
            // TODO: timer per lo scrolling.
        }
    }
}
