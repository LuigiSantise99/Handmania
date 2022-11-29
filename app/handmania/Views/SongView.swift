//
//  SongView.swift
//  handmania
//
//  Created by Mattia Gallotta on 29/11/22.
//

import SwiftUI

struct SongView: View {
    let song: Song
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 10) {
                Text(song.title)
                Text(song.artist)
            }
            
            Spacer()
            
            Text(song.genre ?? "???")
        }.padding()
    }
}
