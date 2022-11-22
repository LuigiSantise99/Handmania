//
//  ContentView.swift
//  handmania
//
//  Created by Mattia Gallotta on 24/06/22.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var cameraManager = CameraManager()
    @State private var permissionGranted = false
    @StateObject private var directionModel = DirectionsModel.getInstance()
    
    var body: some View {
        VStack (alignment: .center) {
            if cameraManager.permissionGranted {
                ZStack {
                    AVCaptureVideoPreviewLayerAdapter(session: directionModel.captureSession)
                    DirectionBoxesView(directionsModel: directionModel)
                }
            } else {
                Text("Per utilizzare l'applicazione devi fornire i permessi della camera")
            }
        }.onReceive(cameraManager.$permissionGranted, perform: { granted in
            permissionGranted = granted
        }).onAppear {
            cameraManager.requestPermission()
            directionModel.startCaptureSession()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
