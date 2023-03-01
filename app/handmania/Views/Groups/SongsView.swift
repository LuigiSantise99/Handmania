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
        NavigationStack {
            List(self.songs) { song in
                NavigationLink(destination: PlayView(song: song)) {
                    SongView(song: song)
                }
            }
            .navigationTitle("Canzoni")
        }
    }
}
