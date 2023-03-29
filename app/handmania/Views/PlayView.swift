//
//  PlayView.swift
//  handmania
//
//  Created by Mattia Gallotta on 06/12/22.
//

import SwiftUI
import AVFoundation

struct PlayView: View {
    var song: Song
    
    let cameraManager = CameraManager.getInstance()
    
    var handDirectionManager = HandDirectionsManager.getInstance()
    
    @State var permissionGranted = false
    @State private var notes: [Note]?
    @State private var player: AVAudioPlayer?
    
    @StateObject private var model = Model.getInstace()
    
    var body: some View {
        GeometryReader { container in
            ZStack(alignment: .top) {
                AVCaptureVideoPreviewLayerAdapter(session: handDirectionManager.captureSession)
                
                ZStack(alignment: .top) {
                    OffNotesView()
                    
                    if let notes = self.notes, let player = self.player {
                        NotesView(notes: notes, spn: song.spn, player: player)
                            .overlay(PointsView(), alignment: .bottom)
                    }
                }
            }.task {
                // The points in the model are reset.
                model.resetScore()
                
                // Camera permissions are requested.
                cameraManager.requestPermission()
                
                // The song notes is retrieved from the model.
                self.notes = await model.getSongNotes(songID: self.song.id)
                
                // The audio player is initialized.
                do {
                    try AVAudioSession.sharedInstance().setCategory(.playback)
                    try AVAudioSession.sharedInstance().setActive(true)
                    
                    self.player = try await AVAudioPlayer(data: model.getSongAudio(songID: self.song.id))
                } catch {
                    fatalError("Unexpectet error while initializing the player")
                }
            }.onReceive(cameraManager.$permissionGranted) { permissionGranted in
                self.permissionGranted = permissionGranted
                
                // Once the permission is granted, the capture session is started.
                if permissionGranted {
                    handDirectionManager.startCaptureSession()
                }
            }.onDisappear {
                // The capture session is stopped as soon as the view is closed.
                handDirectionManager.stopCaptureSession()
            }
            .navigationTitle(song.title)
            .navigationBarBackButtonHidden(true)
            .frame(width: container.size.width)
        }
    }
}
