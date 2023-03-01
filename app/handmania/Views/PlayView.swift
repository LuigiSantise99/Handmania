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
    @State private var notes: [[Int]]?

    var body: some View {
        ZStack {
            AVCaptureVideoPreviewLayerAdapter(session: handDirectionManager.captureSession)
            
            if let notes = self.notes {
                NotesView(notes: notes)
            }
        }.task {
            // Camera permissions are requested.
            cameraManager.requestPermission()
            
            // The song notes is retrieved from the model.
            self.notes = await Model.getInstace().getSongNotes(songID: song.id)
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
    }
}
