//
//  NoteView.swift
//  handmania
//
//  Created by Mattia Gallotta on 08/03/23.
//

import SwiftUI

struct NoteView: View {
    let notes: [Int]

    var body: some View {
        HStack {
            Spacer()
            
            ForEach(self.notes.indices, id: \.self) { noteIndex in
                let note = self.notes[noteIndex]
                
                Image(uiImage: NoteParser.parseNoteByIndex(note: note, noteIndex: noteIndex))
                    .resizable()
                    .frame(width: 64.0, height: 64.0)
                    .padding(15)
                
                Spacer()
            }
        }
    }
}
