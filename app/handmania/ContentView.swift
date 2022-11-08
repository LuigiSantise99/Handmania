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
    
    @State var orientation = DirectionsModel.getInstance().getCurrentUIInterfaceOrientation()
    
    let orientationChanged = NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification)
            .makeConnectable()
            .autoconnect()
    
    var body: some View {
        VStack (alignment: .center) {
            if cameraManager.permissionGranted {
                ZStack {
                    AVCaptureVideoPreviewLayerAdapter(orientation: orientation, session: directionModel.captureSession)
                    
                    DirectionBoxesView(directionsModel: directionModel)
                }
            } else {
                Text("Per utilizzare l'applicazione devi fornire i permessi della camera")
            }
        }.onReceive(cameraManager.$permissionGranted, perform: { granted in
            permissionGranted = granted
        }).onReceive(orientationChanged) { _ in
            self.orientation = directionModel.getCurrentUIInterfaceOrientation()
            
            directionModel.setVideoOrientation(orientation: AVCaptureVideoOrientationFactory.fromUIInterfaceOrientation(orientation: self.orientation))
        }.onAppear {
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
