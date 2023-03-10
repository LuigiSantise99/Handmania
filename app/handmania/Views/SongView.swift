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
            Image(uiImage: self.getCorrectImage(image: self.image))
                .resizable()
                .frame(width: 64.0, height: 64.0)
                .padding()
            
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
    
    /**
    Gets the correct image based on the data stored.
     
     - Parameter image: The data representing the image stored.
     
     - Returns: The UIImage relative to the data or a default one.
     */
    private func getCorrectImage(image: Data?) -> UIImage {
        return (image == nil ? UIImage(systemName: "photo.fill.on.rectangle.fill") : UIImage(data: image!)) ?? UIImage()
    }
}
