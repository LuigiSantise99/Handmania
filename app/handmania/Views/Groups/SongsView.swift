//
//  SongsView.swift
//  handmania
//
//  Created by Mattia Gallotta on 06/12/22.
//

import SwiftUI

struct SongsView: View {
    let cameraManager = CameraManager.getInstance()
    
    let songs: [Song]
    
    @State private var permissionGranted = false
    
    var body: some View {
        NavigationStack {
            List(self.songs) { song in
                NavigationLink(destination: self.getDestination(song: song)) {
                    SongView(song: song)
                }.onTapGesture {
                    // FIXME: onTapGesture non viene mai eseguito.
                    cameraManager.requestPermission()
                }.onReceive(cameraManager.$permissionGranted) { granted in
                    self.permissionGranted = granted
                }
            }
            .navigationTitle("Canzoni")
        }
    }
    
    private func getDestination(song: Song) -> AnyView {
        return self.permissionGranted ? AnyView(PlayView(song: song)) : AnyView(Text("Per utilizzare l'applicazione devi fornire i permessi della camera"))
    }
}
