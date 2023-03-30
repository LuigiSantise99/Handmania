//
//  SongView.swift
//  handmania
//
//  Created by Mattia Gallotta on 29/11/22.
//

import SwiftUI
import UIKit

struct SongView: View {
    @Environment (\.colorScheme) var colorScheme
    
    let song: Song
    
    @State private var image: Data?
    
    var body: some View {
        HStack {
            self.getCorrectImage(image: self.image)
                .resizable()
                .foregroundColor(colorScheme == .light ? .gray : .white)
                .foregroundColor(.white)
                .frame(width: 64.0, height: 64.0)
                .padding()
            
            VStack(alignment: .leading, spacing: 10) {
                Text("\(song.title) - \(song.artist)")
                Text(song.genre)
            }
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
     
     - Returns: The Image relative to the data or a default one.
     */
    private func getCorrectImage(image: Data?) -> Image {
        print(UIScreen.main.bounds.height / UIScreen.main.scale)
        return image == nil ? Image(systemName: "photo.fill.on.rectangle.fill") : Image(uiImage: UIImage(data: image!) ?? UIImage())
    }
    
    struct SongView_Previews: PreviewProvider {
        static var previews: some View {
            SongView(song: Song(_id: "", title: "Titolo", artist: "Artista", genre: "Genere", preview: Preview(start: "0.051", length: "0.1"), spn: 0.005))
        }
    }
}
