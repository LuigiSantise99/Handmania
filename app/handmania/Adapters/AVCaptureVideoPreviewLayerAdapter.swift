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
    let orientation: UIInterfaceOrientation
    let session: AVCaptureSession
    
    func makeUIView(context: Context) -> UIView {
        let view = VideoView()
        view.backgroundColor = .gray
        
        view.previewLayer.session = session
        view.previewLayer.videoGravity = .resizeAspectFill
        view.previewLayer.connection?.videoOrientation = AVCaptureVideoOrientationFactory.fromUIInterfaceOrientation(orientation: orientation)
        
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        // FIXME: view non aggiornata per rotazione upsideDown.
        for layer in uiView.layer.sublayers ?? [] {
            layer.frame = uiView.bounds
        }
        
        let newOrientation = AVCaptureVideoOrientationFactory.fromUIInterfaceOrientation(orientation: orientation)
            
        if let view = uiView as? VideoView {
            view.previewLayer.connection?.videoOrientation = newOrientation
        }
    }
}
