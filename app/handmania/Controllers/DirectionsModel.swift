//
//  DirectionsModel.swift
//  handmania
//
//  Created by Mattia Gallotta on 24/06/22.
//

import Foundation
import AVFoundation
import Vision

class DirectionsModel: NSObject, AVCaptureVideoDataOutputSampleBufferDelegate, ObservableObject {
    private static var INSTANCE: DirectionsModel? = nil
    let captureSession = AVCaptureSession()
    private let videoDataOutput = AVCaptureVideoDataOutput()
    
    @Published var directionBoxes: [Directions : DirectionBox]?
    
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
            print("no front camera device found")
            return
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
    
    @MainActor private func initializeDirectionBoxes(faceBox: CGRect) {
        let faceBoxTopLeft = VNPoint(x: faceBox.minX, y: faceBox.minY)
        let faceBoxTopRight = VNPoint(x: faceBox.minX, y: faceBox.maxY)
        let faceBoxBottomLeft = VNPoint(x: faceBox.maxX, y: faceBox.minY)
        let faceBoxBottomRight = VNPoint(x: faceBox.maxX, y: faceBox.maxY)
        
        self.directionBoxes = [
            Directions.left: DirectionBox(p1: ScreenBounds.topLeft, p2: faceBoxTopLeft, p3: faceBoxBottomLeft, p4: ScreenBounds.bottomLeft),
            Directions.right: DirectionBox(p1: ScreenBounds.topRight, p2: faceBoxTopRight, p3: faceBoxBottomRight, p4: ScreenBounds.bottomRight),
            Directions.up: DirectionBox(p1: ScreenBounds.topLeft, p2: faceBoxTopLeft, p3: faceBoxTopRight, p4: ScreenBounds.topRight),
            Directions.down: DirectionBox(p1: ScreenBounds.bottomLeft, p2: faceBoxBottomLeft, p3: faceBoxBottomRight, p4: ScreenBounds.bottomRight)
        ]
    }
    
    private func detectFace(in image: CVPixelBuffer) {
        let faceDetectionRequest = VNDetectFaceRectanglesRequest(completionHandler: { (request: VNRequest, error: Error?) in
            DispatchQueue.main.async {
                if let results = request.results as? [VNFaceObservation] {
                    if results.count == 1 {
                        print("face detected")
                        self.initializeDirectionBoxes(faceBox: results.first!.boundingBox)
                    } else {
                        print("no or more faces detected")
                        self.directionBoxes = nil
                    }
                }
            }
        })

        let imageRequestHandler = VNImageRequestHandler(cvPixelBuffer: image, orientation: .leftMirrored, options: [:])
        try? imageRequestHandler.perform([faceDetectionRequest])
    }
    
    private func getHandMiddlePoint(recognitionResult: VNHumanHandPoseObservation) -> VNPoint {
        let landmarks: [VNRecognizedPoint]
        
        do {
            try landmarks = Array(recognitionResult.recognizedPoints(forGroupKey: .all).values)
        } catch {
            print("no landmarks detected")
            return VNPoint(x: 0, y: 0)
        }
        
        let meanX = landmarks.map{ $0.x }.reduce(0, +) / Float64(landmarks.count)
        let meanY = landmarks.map{ $0.y }.reduce(0, +) / Float64(landmarks.count)
        
        return VNPoint(x: meanX, y: meanY)
    }
    
    private func detectDirection(handPosition: VNPoint) {
        guard let targetBoxes = self.directionBoxes else {
            print("only hands detected")
            return
        }
        
        let result = targetBoxes.filter{ $0.1.contains(point: handPosition) }.map{ $0.0 }.first ?? Directions.neutral
        print(result)
    }
    
    private func detectHands(in image: CVPixelBuffer) {
        let handDetectionRequest = VNDetectHumanHandPoseRequest(completionHandler: { (request: VNRequest, error: Error?) in
            DispatchQueue.main.async {
                if let results = request.results as? [VNHumanHandPoseObservation], results.count > 0 {
                    print("\(results.count) hands detected")
                    
                    for result in results {
                        self.detectDirection(handPosition: self.getHandMiddlePoint(recognitionResult: result))
                    }
                } else {
                    print("no hands detected")
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
            print("unable to get image from sample buffer")
            return
        }
        
        self.detectFace(in: frame)
        self.detectHands(in: frame)
    }
    
    public static func getInstance() -> DirectionsModel {
        if self.INSTANCE == nil {
            self.INSTANCE = DirectionsModel()
        }
        
        return self.INSTANCE!
    }
}
