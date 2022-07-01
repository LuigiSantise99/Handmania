//
//  CameraManager.swift
//  handmania
//
//  Created by Mattia Gallotta on 01/07/22.
//

import AVFoundation

class CameraManager : ObservableObject {
    @Published var permissionGranted = false
    
    func requestPermission() {
        AVCaptureDevice.requestAccess(for: .video, completionHandler: {accessGranted in
            DispatchQueue.main.async {
                self.permissionGranted = accessGranted
            }
        })
    }
}
