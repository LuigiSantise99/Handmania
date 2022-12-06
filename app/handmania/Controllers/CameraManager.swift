//
//  CameraManager.swift
//  handmania
//
//  Created by Mattia Gallotta on 01/07/22.
//

import AVFoundation

class CameraManager : ObservableObject {
    private static var INSTANCE: CameraManager?
    
    @Published var permissionGranted = false
    
    /**
     Asks permission to access the devide camera and handles the result.
     */
    func requestPermission() {
        AVCaptureDevice.requestAccess(for: .video, completionHandler: {accessGranted in
            DispatchQueue.main.async {
                self.permissionGranted = accessGranted
            }
        })
    }
    
    public static func getInstance() -> CameraManager {
        if self.INSTANCE == nil {
            self.INSTANCE = CameraManager()
        }
        
        return self.INSTANCE!
    }
}
