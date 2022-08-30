//
//  Model.swift
//  handmania
//
//  Created by Mattia Gallotta on 24/06/22.
//

import Foundation
import AVFoundation
import Vision

class Model: NSObject, AVCaptureVideoDataOutputSampleBufferDelegate {
    private static var INSTANCE: Model? = nil
    let captureSession = AVCaptureSession()
    private let videoDataOutput = AVCaptureVideoDataOutput()
    
    // TODO: massimo una sola faccia.
    var numberOfFaces = 0
    
    override init() {
        super.init()
        self.addCameraInput()
        self.getCameraFrames()
    }
    
    private func addCameraInput() {
        guard let device = AVCaptureDevice.DiscoverySession(
            deviceTypes: [.builtInWideAngleCamera, .builtInDualCamera, .builtInTrueDepthCamera],
            mediaType: .video,
            position: .front).devices.first else {
            fatalError("No back camera device found, please make sure to run SimpleLaneDetection in an iOS device and not a simulator")
        }
        let cameraInput = try! AVCaptureDeviceInput(device: device)
        self.captureSession.addInput(cameraInput)
    }
    
    private func getCameraFrames() {
        self.videoDataOutput.videoSettings = [(kCVPixelBufferPixelFormatTypeKey as NSString) : NSNumber(value: kCVPixelFormatType_32BGRA)] as [String : Any]
        self.videoDataOutput.alwaysDiscardsLateVideoFrames = true
        self.videoDataOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "camera_frame_processing_queue"))
        self.captureSession.addOutput(self.videoDataOutput)
        guard let connection = self.videoDataOutput.connection(with: AVMediaType.video),
              connection.isVideoOrientationSupported else { return }
        connection.videoOrientation = .portrait
    }
    
    private func detectFace(in image: CVPixelBuffer) {
        let faceDetectionRequest = VNDetectFaceLandmarksRequest(completionHandler: { (request: VNRequest, error: Error?) in
            DispatchQueue.main.async {
                if let results = request.results as? [VNFaceObservation] {
                    self.numberOfFaces = results.count
                    
                    if results.count == 1 {
                        print("faced detected")
                    } else if results.count == 0 {
                        print("no faces detected")
                    } else {
                        print("more than one face detected")
                    }
                }
            }
        })

        let imageRequestHandler = VNImageRequestHandler(cvPixelBuffer: image, orientation: .leftMirrored, options: [:])
        try? imageRequestHandler.perform([faceDetectionRequest])
    }
    
    private func detectHands(in image: CVPixelBuffer) {
        let handDetectionRequest = VNDetectHumanHandPoseRequest(completionHandler: { (request: VNRequest, error: Error?) in
            DispatchQueue.main.async {
                if let results = request.results as? [VNHumanHandPoseObservation], results.count > 0 {
                    print("\(results.count) hands detected")
                } else {
                    print("did not detect any hands")
                }
            }
        })
        handDetectionRequest.maximumHandCount = 2
        
        let imageRequestHandler = VNImageRequestHandler(cvPixelBuffer: image, orientation: .leftMirrored, options: [:])
        try? imageRequestHandler.perform([handDetectionRequest])
    }
    
    func captureOutput(_ output: AVCaptureOutput,
                       didOutput sampleBuffer: CMSampleBuffer,
                       from connection: AVCaptureConnection) {
        guard let frame = CMSampleBufferGetImageBuffer(sampleBuffer) else {
            debugPrint("unable to get image from sample buffer")
            return
        }
        self.detectFace(in: frame)
        self.detectHands(in: frame)
    }
    
    public static func getInstance() -> Model {
        if self.INSTANCE == nil {
            self.INSTANCE = Model()
        }
        
        return self.INSTANCE!
    }
}
