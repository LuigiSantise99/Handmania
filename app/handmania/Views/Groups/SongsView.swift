//
//  SongsView.swift
//  handmania
//
//  Created by Mattia Gallotta on 06/12/22.
//

import SwiftUI

struct SongsView: View {
    let songs: [Song]
    
    var body: some View {
        List {
            ForEach(self.songs) { song in
                SongView(song: song).onTapGesture {
                    print("selected song \(song.title)")
                }
            }
        }
        .navigationTitle("Canzoni")
    }
}
