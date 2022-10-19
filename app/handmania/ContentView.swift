//
//  ContentView.swift
//  handmania
//
//  Created by Mattia Gallotta on 24/06/22.
//

import SwiftUI

struct ContentView: View {
    @StateObject var cameraManager = CameraManager()
    @State var permissionGranted = false
    @StateObject var directionModel = DirectionsModel.getInstance()
    
    var body: some View {
        VStack {
            if cameraManager.permissionGranted {
                ZStack {                    AVCaptureVideoPreviewLayerAdapter(session: directionModel.captureSession)
                    
                    DirectionBoxesView(directionsModel: directionModel)
                }
            } else {
                Text("Per utilizzare l'applicazione devi fornire i permessi della camera")
            }
        }.onReceive(cameraManager.$permissionGranted, perform: { (granted) in
            permissionGranted = granted
        }).onAppear {
            cameraManager.requestPermission()
            directionModel.captureSession.startRunning()
        }
        
        // TODO: implement orientation change handler.
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
