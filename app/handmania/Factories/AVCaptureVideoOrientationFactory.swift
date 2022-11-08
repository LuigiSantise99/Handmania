//
//  AVCaptureVideoOrientationFactory.swift
//  handmania
//
//  Created by Mattia Gallotta on 21/10/22.
//

import UIKit
import AVFoundation

struct AVCaptureVideoOrientationFactory {
    private static let UI_INTERFACE_ORIENTATION_DICTIONARY = [
        UIInterfaceOrientation.portrait: AVCaptureVideoOrientation.portrait,
        UIInterfaceOrientation.landscapeLeft: AVCaptureVideoOrientation.landscapeLeft,
        UIInterfaceOrientation.landscapeRight: AVCaptureVideoOrientation.landscapeRight,
        UIInterfaceOrientation.portraitUpsideDown: AVCaptureVideoOrientation.portraitUpsideDown
    ]
    
    static func fromUIInterfaceOrientation(orientation: UIInterfaceOrientation) -> AVCaptureVideoOrientation {
        return UI_INTERFACE_ORIENTATION_DICTIONARY[orientation] ?? .portrait
    }
}
