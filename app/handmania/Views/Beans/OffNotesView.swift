//
//  OffNotesView.swift
//  handmania
//
//  Created by Mattia Gallotta on 14/03/23.
//

import SwiftUI

struct OffNotesView: View {
    @StateObject private var model = Model.getInstace()
    
    var body: some View {
        HStack {
            Spacer()
            
            let correctNotes = model.getCorrectNotes()
            
            ForEach(0...3, id: \.self) { noteIndex in
                let imageName = NoteParser.getNoteImageName(noteIndex: noteIndex)
            
                let note = Image("\(imageName)_off")
                    .resizable()
                    .frame(width: 60.0, height: 60.0)
                
                if correctNotes[noteIndex] {
                    ZStack(alignment: .center) {
                        // Correct note circle.
                        Image("glow_circle")
                            .resizable()
                            .frame(width: 60.0, height: 60.0)
                        
                        note
                    }
                } else {
                    note
                }
                
                Spacer()
            }
        }
        .padding(10)
        .background(
            Color.black
                .opacity(0.625)
        )
    }
    
    struct OffNotesView_Previews: PreviewProvider {
        static var previews: some View {
            OffNotesView()
        }
    }
}
