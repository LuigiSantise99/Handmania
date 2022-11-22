//
//  AVCaptureVideoPreviewLayerAdapter.swift
//  handmania
//
//  Created by Mattia Gallotta on 01/07/22.
//

import SwiftUI
import AVFoundation
import UIKit

struct AVCaptureVideoPreviewLayerAdapter: UIViewRepresentable {
    let session: AVCaptureSession
    
    func makeUIView(context: Context) -> UIView {
        let view = VideoView()
        view.backgroundColor = .gray
        
        view.previewLayer.session = session
        view.previewLayer.videoGravity = .resizeAspectFill
        view.previewLayer.connection?.videoOrientation = .portrait
        
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        for layer in uiView.layer.sublayers ?? [] {
            layer.frame = uiView.bounds
        }
    }
}
