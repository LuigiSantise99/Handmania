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
                NavigationLink(destination: MainView(song: song)) {
                    SongView(song: song)
                }
            }
            .navigationTitle("Canzoni")
            .navigationBarBackButtonHidden(true)
        }
    }
    
    struct SongsView_Previews: PreviewProvider {
        static var previews: some View {
            SongsView(songs: [Song(_id: "1", title: "Titolo", artist: "Artista", genre: "Genere", spn: 0.005), Song(_id: "2", title: "Titolo", artist: "Artista", genre: "Genere", spn: 0.005)])
        }
    }
}
