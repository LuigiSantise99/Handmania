//
//  ContentView.swift
//  handmania
//
//  Created by Mattia Gallotta on 24/06/22.
//

import SwiftUI
import AVFoundation

struct ContentView: View {
    @StateObject var cameraManager = CameraManager()
    @State var model = Model.getInstance()
    @State var permissionGranted = false
    
    var body: some View {
        VStack {
            if cameraManager.permissionGranted {
                AVCaptureVideoPreviewLayerAdapter(session: model.captureSession)
            } else {
                Text("Per utilizzare l'applicazione devi fornire i permessi della camera")
            }
        }.onReceive(cameraManager.$permissionGranted, perform: { (granted) in
            permissionGranted = granted
        }).onAppear {
            cameraManager.requestPermission()
            // model.getCameraFrames()
            model.captureSession.startRunning()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
