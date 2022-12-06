//
//  ContentView.swift
//  handmania
//
//  Created by Mattia Gallotta on 24/06/22.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var cameraManager = CameraManager.getInstance()
    @State private var permissionGranted = false
    @StateObject private var handDirectionManager = HandDirectionsManager.getInstance()
    @StateObject private var model = Model.getInstace()
    
    @State private var showSongsView = false
    
    var body: some View {
        VStack (alignment: .center) {
            WelcomeView(songsHaveArrived: model.songsHaveArrived)
            
            /*
             if cameraManager.permissionGranted {
             ZStack {
             AVCaptureVideoPreviewLayerAdapter(session: handDirectionManager.captureSession)
             
             if let directionBoxes = handDirectionManager.directionBoxes?.values {
             DirectionBoxesView(directionBoxes: Array(directionBoxes))
             }
             }
             } else {
             Text("Per utilizzare l'applicazione devi fornire i permessi della camera")
             }
             */
        }.onReceive(cameraManager.$permissionGranted, perform: { granted in
            permissionGranted = granted
        }).onAppear {
            // cameraManager.requestPermission()
            // handDirectionManager.startCaptureSession()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
