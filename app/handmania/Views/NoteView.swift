//
//  NoteView.swift
//  handmania
//
//  Created by Mattia Gallotta on 08/03/23.
//

import SwiftUI

struct NoteView: View {
    let notes: Note

    var body: some View {
        HStack {
            Spacer()
            
            ForEach(self.notes.content.indices, id: \.self) { noteIndex in
                let note = self.notes.content[noteIndex]
                
                NoteParser.parseNoteByIndex(note: note, noteIndex: noteIndex)
                    .resizable()
                    .frame(width: 60.0, height: 60.0)
                    .padding()
                
                Spacer()
            }
        }
    }
}
