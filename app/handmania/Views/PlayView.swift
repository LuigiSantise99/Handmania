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
    
    @StateObject private var handDirectionManager = HandDirectionsManager.getInstance()
    
    var body: some View {
        ZStack {
            AVCaptureVideoPreviewLayerAdapter(session: handDirectionManager.captureSession)
            
            if let directionBoxes = handDirectionManager.directionBoxes?.values {
                DirectionBoxesView(directionBoxes: Array(directionBoxes))
            }
        }.onAppear {
            // The capture session is started as soon as the view is created.
            handDirectionManager.startCaptureSession()
        }.onDisappear {
            // The capture session is stopped as soon as the view is closed.
            // FIXME: la sessione non viene chiusa correttamente.
            handDirectionManager.stopCaptureSession()
        }
        .navigationTitle(song.title)
    }
}
