//
//  DirectionsModel.swift
//  handmania
//
//  Created by Mattia Gallotta on 24/06/22.
//

import Foundation
import AVFoundation
import Vision
import UIKit

class DirectionsModel: NSObject, AVCaptureVideoDataOutputSampleBufferDelegate, ObservableObject {
    private static var INSTANCE: DirectionsModel? = nil
    let captureSession = AVCaptureSession()
    private let videoDataOutput = AVCaptureVideoDataOutput()
    
    @Published var directionBoxes: [Direction : DirectionBox]?
    @Published var hands = [
        HandDirection(direction: Direction.neutral, timestamp: Date()),
        HandDirection(direction: Direction.neutral, timestamp: Date())
    ]
    
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
    
    func setVideoOrientation(orientation: AVCaptureVideoOrientation) {
        guard let connection = self.videoDataOutput.connection(with: .video),
              connection.isVideoOrientationSupported else { return }
        
        connection.videoOrientation = orientation
    }
    
    private func getCameraFrames(orientation: AVCaptureVideoOrientation) {
        self.videoDataOutput.videoSettings = [(kCVPixelBufferPixelFormatTypeKey as NSString) : NSNumber(value: kCVPixelFormatType_32BGRA)] as [String : Any]
        self.videoDataOutput.alwaysDiscardsLateVideoFrames = true
        self.videoDataOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "camera_frame_processing_queue"))
        self.captureSession.addOutput(self.videoDataOutput)
        
        self.setVideoOrientation(orientation: orientation)
    }
    
    func startCaptureSession() {
        self.addCameraInput()
        self.getCameraFrames(orientation: .portrait)
        
        DispatchQueue.global(qos: .background).async {
            self.captureSession.startRunning()
        }
    }
    
    @MainActor private func clearDirectionBoxes() {
        self.directionBoxes = nil
    }
    
    @MainActor private func initializeDirectionBoxes(faceBoxTopLeft: VNPoint, faceBoxTopRight: VNPoint, faceBoxBottomLeft: VNPoint, faceBoxBottomRight: VNPoint) {
        self.directionBoxes = [
            Direction.left: DirectionBox(p1: ScreenBounds.topLeft, p2: faceBoxTopLeft, p3: faceBoxBottomLeft, p4: ScreenBounds.bottomLeft),
            Direction.right: DirectionBox(p1: ScreenBounds.topRight, p2: faceBoxTopRight, p3: faceBoxBottomRight, p4: ScreenBounds.bottomRight),
            Direction.up: DirectionBox(p1: ScreenBounds.topLeft, p2: faceBoxTopLeft, p3: faceBoxTopRight, p4: ScreenBounds.topRight),
            Direction.down: DirectionBox(p1: ScreenBounds.bottomLeft, p2: faceBoxBottomLeft, p3: faceBoxBottomRight, p4: ScreenBounds.bottomRight)
        ]
    }
    
    private func detectFace(in image: CVPixelBuffer) {
        let faceDetectionRequest = VNDetectFaceRectanglesRequest(completionHandler: { (request: VNRequest, error: Error?) in
            DispatchQueue.main.async {
                if let results = request.results as? [VNFaceObservation] {
                    if results.count == 1 {
                        print("face detected")
                        let faceBox = results.first!.boundingBox
                        self.initializeDirectionBoxes(
                            faceBoxTopLeft: VNPoint(x: faceBox.minX, y: faceBox.minY),
                            faceBoxTopRight: VNPoint(x: faceBox.maxX, y: faceBox.minY),
                            faceBoxBottomLeft: VNPoint(x: faceBox.minX, y: faceBox.maxY),
                            faceBoxBottomRight: VNPoint(x: faceBox.maxX, y: faceBox.maxY)
                        )
                    } else {
                        print("no or more faces detected")
                        self.clearDirectionBoxes()
                    }
                }
            }
        })

        let imageRequestHandler = VNImageRequestHandler(cvPixelBuffer: image, orientation: .down, options: [:])
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
        print("hand detected @\(String(format: "%.4f", meanX)),\(String(format: "%.4f", meanY))")

        return VNPoint(x: meanX, y: meanY)
    }
    
    private func detectDirection(handPosition: VNPoint) -> Direction {
        guard let targetBoxes = self.directionBoxes else {
            print("only hands detected")
            return Direction.neutral
        }
        
        let result = targetBoxes.filter{ $0.1.contains(point: handPosition) }.map{ $0.0 }.first ?? Direction.neutral
        
        return result
    }
    
    func printDetectedHandDirections() {
        for hand in self.hands {
            print(hand)
        }
    }
    
    @MainActor private func initializeHandDirections(hands: [HandDirection]) {
        self.hands = hands
    }
    
    private func generateUpdatedHandDirections(directions: [Direction]) -> [HandDirection]? {
        guard directions.count == 2 else {
            print("invalid number of directions")
            return nil
        }
        
        let timestamp = Date()
        var update = [
            HandDirection(direction: directions[0], timestamp: timestamp),
            HandDirection(direction: directions[1], timestamp: timestamp)
        ]
        
        for (i, value) in update.enumerated() {
            let equals = self.hands.filter{ $0.direction == value.direction }
            let j = self.hands.firstIndex{ $0.timestamp == equals.map{ $0.timestamp }.min() } ?? -1

            if j > -1 {
                update[i].timestamp = self.hands[j].timestamp
            }
        }
        
        printDetectedHandDirections()
        return update
    }
    
    private func detectHandDirections(results: [VNHumanHandPoseObservation]) -> [Direction] {
        print("\(results.count) hands detected")
        
        if results.count <= 0 {
            print("no hands detected")
            return [Direction.neutral, Direction.neutral]
        }
        
        var directions = [Direction]()
        
        for result in results {
            directions.append(self.detectDirection(handPosition: self.getHandMiddlePoint(recognitionResult: result)))
        }
        
        // If a hand is not detected, it means it is in a neutral position.
        if directions.count < 2 {
            directions.append(Direction.neutral)
        }
        
        return directions
    }
    
    private func detectHands(in image: CVPixelBuffer) {
        let handDetectionRequest = VNDetectHumanHandPoseRequest(completionHandler: { (request: VNRequest, error: Error?) in
            DispatchQueue.main.async {
                if let results = request.results as? [VNHumanHandPoseObservation] {
                    let directions = self.detectHandDirections(results: results)
                    
                    if let newDirections = self.generateUpdatedHandDirections(directions: directions) {
                        self.initializeHandDirections(hands: newDirections)
                    }
                }
            }
        })
        handDetectionRequest.maximumHandCount = 2
        
        let imageRequestHandler = VNImageRequestHandler(cvPixelBuffer: image, orientation: .down, options: [:])
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
