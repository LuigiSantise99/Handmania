//
//  NotesView.swift
//  handmania
//
//  Created by Mattia Gallotta on 27/02/23.
//

import AVFoundation
import Combine
import Foundation
import SwiftUI
import UIKit

struct NotesView: View {
    private static let NOTE_ROW_HEIGHT = 10.0 + 60.0 + 10.0
    private static let HEADER_HEIGHT = 1.25 + 65 + 1.25
    private static let SCREEN_HEIGHT = UIScreen.main.bounds.size.height
    private static let NOTE_SKIP = Int(floor((SCREEN_HEIGHT - HEADER_HEIGHT) / NOTE_ROW_HEIGHT))
    
    private static let EMPTY_NOTE_ROW = [0, 0, 0, 0]
    private static let DELAY_BEFORE_SONG = 8.5
    
    private var notes: [Note]
    private let spn: Float
    private let timer: Publishers.Autoconnect<Timer.TimerPublisher>
    private let player: AVAudioPlayer
    
    private let handDirectionManager = HandDirectionsManager.getInstance()
    private let logger = Logger(tag: String(describing: NotesView.self))
    
    init(notes: [Note], spn: Float, player: AVAudioPlayer) {
        self.notes = notes
        self.spn = spn
        self.timer = Timer.publish(every: TimeInterval(spn), on: .main, in: .common).autoconnect()
        self.player = player
        
        // NotesView.NOTE_SKIP times 2 rows are added for padding reasons.
        for i in 0..<(NotesView.NOTE_SKIP * 2 - 1) {
            self.notes.append(Note(index: notes.count + i, content: NotesView.EMPTY_NOTE_ROW))
        }
    }
    
    @StateObject var gameStatus = GameStatus.getInstace()
    @State var currentIndex = 0
    
    var body: some View {
        GeometryReader { geometryProxy in
            ScrollView {
                ScrollViewReader { proxy in
                    VStack(spacing: 0.0) {
                        ForEach(notes, id: \.index) { noteRow in
                            NoteView(notes: noteRow)
                                .padding(10)
                        }
                    }
                    .onReceive(timer) { _ in
                        // Previous expected notes are checked.
                        if self.currentIndex >= NotesView.NOTE_SKIP && self.currentIndex + NotesView.NOTE_SKIP < self.notes.count - 1 {
                            // The correct note model is reset.
                            Model.getInstace().resetCorrectNotes()
                            
                            let (newScore, correctNotes) = handDirectionManager.checkExpectedDirections(notes: self.notes[currentIndex - NotesView.NOTE_SKIP], timeWindow: self.spn)
                            
                            if newScore > 0 {
                                // The got note is set in the model.
                                Model.getInstace().setCorrectNotes(note: correctNotes)
                                // The new score is saved in the model.
                                Model.getInstace().updateScore(points: newScore)
                            }
                        }
                        
                        if gameStatus.gameDidStarted() {
                            self.currentIndex = self.currentIndex < self.notes.count - 1 ? self.currentIndex + 1 : 0
                        }
                        
                        if self.currentIndex >= self.notes.count - 1 {
                            // Game ends after this last note.
                            self.timer.upstream.connect().cancel()
                            
                            // The final score view is displayed.
                            gameStatus.endGame()
                        }
                        
                        proxy.scrollTo(currentIndex)
                    }
                    .onDisappear {
                        // Player is stopped.
                        player.stop()
                    }
                }
            }
            .onAppear {
                // The music is started after 3 seconds.
                DispatchQueue.main.asyncAfter(deadline: .now() + NotesView.DELAY_BEFORE_SONG) {
                    player.play()
                }
            }
        }
    }
}
