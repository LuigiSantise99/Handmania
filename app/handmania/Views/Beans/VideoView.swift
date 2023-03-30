//
//  VideoView.swift
//  handmania
//
//  Created by Mattia Gallotta on 25/10/22.
//

import UIKit
import AVFoundation

class VideoView: UIView {
    override class var layerClass: AnyClass {
        AVCaptureVideoPreviewLayer.self
    }
    
    var previewLayer: AVCaptureVideoPreviewLayer {
        layer as! AVCaptureVideoPreviewLayer
    }
}
