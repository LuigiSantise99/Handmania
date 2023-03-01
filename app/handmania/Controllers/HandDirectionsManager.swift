//
//  HandDirectionsManager.swift
//  handmania
//
//  Created by Mattia Gallotta on 24/06/22.
//

import Foundation
import AVFoundation
import Vision
import UIKit

class HandDirectionsManager: NSObject, AVCaptureVideoDataOutputSampleBufferDelegate, ObservableObject {
    private static var INSTANCE: HandDirectionsManager? = nil
    
    private let logger = Logger(tag: String(describing: HandDirectionsManager.self))
    let captureSession = AVCaptureSession()
    private let videoDataOutput = AVCaptureVideoDataOutput()
    private var captureSessionIsInitialized = false
    
    @Published var directionBoxes: [Direction : DirectionBox]?
    @Published var hands = [
        HandDirection(direction: Direction.neutral, timestamp: Date()),
        HandDirection(direction: Direction.neutral, timestamp: Date())
    ]
    
    /**
     Sets and adds to the capture session the front camera as the input.
     */
    private func addCameraInput() {
        guard let device = AVCaptureDevice.DiscoverySession(
            deviceTypes: [.builtInWideAngleCamera, .builtInDualCamera, .builtInTrueDepthCamera],
            mediaType: .video,
            position: .front).devices.first else {
            self.logger.log("no front camera device found")
            return
        }
        
        let cameraInput = try! AVCaptureDeviceInput(device: device)
        self.captureSession.addInput(cameraInput)
    }
    
    /**
     Sets the handler for the camera output and links it to the session.
     */
    private func getCameraFrames() {
        self.videoDataOutput.videoSettings = [(kCVPixelBufferPixelFormatTypeKey as NSString) : NSNumber(value: kCVPixelFormatType_32BGRA)] as [String : Any]
        self.videoDataOutput.alwaysDiscardsLateVideoFrames = true
        self.videoDataOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "camera_frame_processing_queue"))
        self.captureSession.addOutput(self.videoDataOutput)
        
        guard let connection = self.videoDataOutput.connection(with: .video),
              connection.isVideoOrientationSupported else { return }
        
        connection.videoOrientation = .portrait
    }
    
    /**
     Starts the capture session.
     */
    func startCaptureSession() {
        // The initialization is done once.
        if !self.captureSessionIsInitialized {
            self.addCameraInput()
            self.getCameraFrames()
            
            self.logger.log("all good, capture session correctly initialized")
            
            self.captureSessionIsInitialized = true
        }
        
        DispatchQueue.global(qos: .background).async {
            self.logger.log("starting capture session...")
            self.captureSession.startRunning()
        }
    }
    
    /**
     Stops the capture session.
     */
    func stopCaptureSession() {
        DispatchQueue.global(qos: .background).async {
            self.logger.log("stopping capture session...")
            self.captureSession.stopRunning()
            self.logger.log("captire session stopped")
        }
    }
    
    /**
     Clears the direction boxes container in the main thread.
     */
    @MainActor private func clearDirectionBoxes() {
        self.directionBoxes = nil
    }
    
    /**
     Initializes the new direction boxes container with the new user's face position in the main thread.
     
     - Parameter faceBoxTopLeft: The top-left corner of the user's face box.
     - Parameter faceBoxTopRight: The top-right corner of the user's face box.
     - Parameter faceBoxBottomLeft: The bottom-left corner of the user's face box.
     - Parameter faceBoxBottomRight: The bottom-right corner of the user's face box.
     */
    @MainActor private func initializeDirectionBoxes(faceBoxTopLeft: VNPoint, faceBoxTopRight: VNPoint, faceBoxBottomLeft: VNPoint, faceBoxBottomRight: VNPoint) {
        self.directionBoxes = [
            Direction.left: DirectionBox(p1: ScreenBounds.topLeft, p2: faceBoxTopLeft, p3: faceBoxBottomLeft, p4: ScreenBounds.bottomLeft),
            Direction.right: DirectionBox(p1: ScreenBounds.topRight, p2: faceBoxTopRight, p3: faceBoxBottomRight, p4: ScreenBounds.bottomRight),
            Direction.up: DirectionBox(p1: ScreenBounds.topLeft, p2: faceBoxTopLeft, p3: faceBoxTopRight, p4: ScreenBounds.topRight),
            Direction.down: DirectionBox(p1: ScreenBounds.bottomLeft, p2: faceBoxBottomLeft, p3: faceBoxBottomRight, p4: ScreenBounds.bottomRight)
        ]
    }
    
    /**
     Builds and performs the request for the user's face box ccordinates in the specified frame.
     
     - Parameter image: The frame to look the user's face box for.
     */
    private func detectFace(in image: CVPixelBuffer) {
        let faceDetectionRequest = VNDetectFaceRectanglesRequest(completionHandler: { (request: VNRequest, error: Error?) in
            DispatchQueue.main.async {
                if let results = request.results as? [VNFaceObservation] {
                    if results.count == 1 {
                        self.logger.log("face detected")
                        let faceBox = results.first!.boundingBox
                        self.initializeDirectionBoxes(
                            faceBoxTopLeft: VNPoint(x: faceBox.minX, y: faceBox.minY),
                            faceBoxTopRight: VNPoint(x: faceBox.maxX, y: faceBox.minY),
                            faceBoxBottomLeft: VNPoint(x: faceBox.minX, y: faceBox.maxY),
                            faceBoxBottomRight: VNPoint(x: faceBox.maxX, y: faceBox.maxY)
                        )
                    } else {
                        self.logger.log("no or more faces detected")
                        self.clearDirectionBoxes()
                    }
                }
            }
        })

        let imageRequestHandler = VNImageRequestHandler(cvPixelBuffer: image, orientation: .down, options: [:])
        try? imageRequestHandler.perform([faceDetectionRequest])
    }
    
    /**
     Generates the middle point of the user's hand.
     
     - Parameter recognitionResult: The result of the human hand pose observation.
     
     - Returns: The middle point of the hand observation.
     */
    private func getHandMiddlePoint(recognitionResult: VNHumanHandPoseObservation) -> VNPoint {
        let landmarks: [VNRecognizedPoint]
        
        do {
            try landmarks = Array(recognitionResult.recognizedPoints(forGroupKey: .all).values)
        } catch {
            self.logger.log("no landmarks detected")
            return VNPoint(x: 0, y: 0)
        }
        
        let meanX = landmarks.map{ $0.x }.reduce(0, +) / Float64(landmarks.count)
        let meanY = landmarks.map{ $0.y }.reduce(0, +) / Float64(landmarks.count)
        self.logger.log("hand detected @\(String(format: "%.4f", meanX)),\(String(format: "%.4f", meanY))")

        return VNPoint(x: meanX, y: meanY)
    }
    
    /**
     Detect the direction of the user's hand compared to their face position.
     
     - Parameter handPosition: The position of the user's hand.
     
     - Returns: The direction of the hand with respect to the user's face.
     */
    private func detectDirection(handPosition: VNPoint) -> Direction {
        guard let targetBoxes = self.directionBoxes else {
            self.logger.log("only hands detected")
            return Direction.neutral
        }
        
        let result = targetBoxes.filter{ $0.1.contains(point: handPosition) }.map{ $0.0 }.first ?? Direction.neutral
        
        return result
    }
    
    /**
     Prints the current hand directions memorized.
     */
    private func printDetectedHandDirections() {
        for hand in self.hands {
            self.logger.log(String(describing: hand))
        }
    }
    
    /**
     Initializes the new hand directions in the main thread.
     
     - Parameter hands: The new hand directions.
     */
    @MainActor private func initializeHandDirections(hands: [HandDirection]) {
        self.hands = hands
    }
    
    /**
     Generates the new hand directions based on the newly detected directions.
     
     - Parameter directions: The newly detected directions,
     
     - Returns: The updated hand directions.
     */
    private func generateUpdatedHandDirections(directions: [Direction]) -> [HandDirection]? {
        guard directions.count == 2 else {
            self.logger.log("invalid number of directions")
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
    
    /**
     Extracts the direction of the user's hands with respect to their face.
     
     - Parameter results: The hand pose observation result.
     
     - Returns: The list of the detected directions.
     */
    private func detectHandDirections(results: [VNHumanHandPoseObservation]) -> [Direction] {
        self.logger.log("\(results.count) hands detected")
        
        if results.count <= 0 {
            self.logger.log("no hands detected")
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
    
    /**
     Builds and performs the request for the user's hands ccordinates in the specified frame.
     
     - Parameter image: The frame to look the user's hands for.
     */
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
    
    /**
     Captures and handles the requests for the user's face box and hand positions on a frame.
     
     - Parameter output: The output the frame is set into.
     - Parameter sampleBuffer: The buffer representing the current frame.
     - Parameter connection: The connection to the capture session.
     */
    func captureOutput(_ output: AVCaptureOutput,
                       didOutput sampleBuffer: CMSampleBuffer,
                       from connection: AVCaptureConnection) {
        guard let frame = CMSampleBufferGetImageBuffer(sampleBuffer) else {
            self.logger.log("unable to get image from sample buffer")
            return
        }
        
        self.detectFace(in: frame)
        self.detectHands(in: frame)
    }
    
    public static func getInstance() -> HandDirectionsManager {
        if self.INSTANCE == nil {
            self.INSTANCE = HandDirectionsManager()
        }
        
        return self.INSTANCE!
    }
}
