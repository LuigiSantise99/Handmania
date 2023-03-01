//
//  NotesView.swift
//  handmania
//
//  Created by Mattia Gallotta on 27/02/23.
//

import SwiftUI

struct NotesView: View {
    let notes: [[Int]]
    
    var body: some View {
        ScrollView {
                VStack(alignment: .leading) {
                    ForEach(notes, id: \.self) { note in
                        Text("\(note[0]) \(note[1]) \(note[2]) \(note[3])")
                    }
                }
            }
    }
}
