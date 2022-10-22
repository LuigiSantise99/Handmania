//
//  AVCaptureVideoOrientationFactory.swift
//  handmania
//
//  Created by Mattia Gallotta on 21/10/22.
//

import UIKit
import AVFoundation

struct AVCaptureVideoOrientationFactory {
    private static let UI_DEVICE_ORIENTATION_DICTIONARY = [
        UIDeviceOrientation.portrait: AVCaptureVideoOrientation.portrait,
        UIDeviceOrientation.landscapeLeft: AVCaptureVideoOrientation.landscapeLeft,
        UIDeviceOrientation.landscapeRight: AVCaptureVideoOrientation.landscapeRight,
        UIDeviceOrientation.portraitUpsideDown: AVCaptureVideoOrientation.portraitUpsideDown
    ]
    
    private static let UI_INTERFACE_ORIENTATION_DICTIONARY = [
        UIInterfaceOrientation.portrait: AVCaptureVideoOrientation.portrait,
        UIInterfaceOrientation.landscapeLeft: AVCaptureVideoOrientation.landscapeLeft,
        UIInterfaceOrientation.landscapeRight: AVCaptureVideoOrientation.landscapeRight,
        UIInterfaceOrientation.portraitUpsideDown: AVCaptureVideoOrientation.portraitUpsideDown
    ]
    
    static func fromUIDeviceOrientation(orientation: UIDeviceOrientation) -> AVCaptureVideoOrientation {
        return UI_DEVICE_ORIENTATION_DICTIONARY[orientation] ?? .portrait
    }
    
    static func fromUIInterfaceOrientation(orientation: UIInterfaceOrientation) -> AVCaptureVideoOrientation {
        return UI_INTERFACE_ORIENTATION_DICTIONARY[orientation] ?? .portrait
    }
}
