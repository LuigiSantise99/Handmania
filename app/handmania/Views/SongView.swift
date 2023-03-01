//
//  SongView.swift
//  handmania
//
//  Created by Mattia Gallotta on 29/11/22.
//

import SwiftUI
import UIKit

struct SongView: View {
    let song: Song
    
    @State private var image: Data?
    
    var body: some View {
        HStack {
            if let imageData = image {
                Image(uiImage: UIImage(data: imageData) ?? UIImage())
            }
            
            VStack(alignment: .leading, spacing: 10) {
                Text(song.title)
                Text(song.artist)
            }
            
            Spacer()
            
            Text(song.genre)
        }
        .task {
            // The song image is fetched from the server.
            self.image = await Model.getInstace().getSongThumbnail(songID: song.id)
        }
        .padding()
    }
}
