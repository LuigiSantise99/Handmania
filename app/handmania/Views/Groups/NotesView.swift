//
//  NotesView.swift
//  handmania
//
//  Created by Mattia Gallotta on 27/02/23.
//

import AVFoundation
import Combine
import SwiftUI
import UIKit

struct NotesView: View {
    private static let NOTE_SKIP = 8
    private static let EMPTY_NOTE_ROW = [0, 0, 0, 0]
    private static let DELAY_BEFORE_SONG = 8.5
    
    var notes : [Note]
    let spn: Float
    let timer: Publishers.Autoconnect<Timer.TimerPublisher>
    let player: AVAudioPlayer
    
    let handDirectionManager = HandDirectionsManager.getInstance()
    
    init(notes: [Note], spn: Float, player: AVAudioPlayer) {
        self.notes = notes
        self.spn = spn
        
        // NOTE_SKIP empty notes are added.
        for i in 0..<NotesView.NOTE_SKIP {
            self.notes.append(Note(index: notes.count + i, content: NotesView.EMPTY_NOTE_ROW))
        }
        
        self.timer = Timer.publish(every: TimeInterval(spn), on: .main, in: .common).autoconnect()
        self.player = player
    }
    
    @StateObject var model = Model.getInstace()
    @State var currentIndex = 0
    
    var body: some View {
        ZStack {
            GeometryReader { proxy in
                if (!model.gameDidStarted()) {
                    CountDownView(container: proxy)
                }
                
                ScrollView {
                    ScrollViewReader { proxy in
                        VStack(spacing: 0.0) {
                            ForEach(notes, id: \.index) { noteRow in
                                NoteView(notes: noteRow)
                                    .frame(height: 16)
                                    .padding(32)
                            }
                        }
                        .onReceive(timer) { _ in
                            // Previous expected notes are checked.
                            if self.currentIndex >= NotesView.NOTE_SKIP && self.currentIndex + NotesView.NOTE_SKIP < self.notes.count - 1 {
                                // The correct note model is reset.
                                model.resetCorrectNotes()
                                
                                let (newScore, correctNotes) = handDirectionManager.checkExpectedDirections(notes: self.notes[currentIndex - NotesView.NOTE_SKIP], timeWindow: self.spn)
                                
                                if newScore > 0 {
                                    // The got note is set in the model.
                                    model.setCorrectNotes(note: correctNotes)
                                    // The new score is saved in the model.
                                    model.updateScore(points: newScore)
                                }
                            }
                            
                            if (model.gameDidStarted()) {
                                self.currentIndex = self.currentIndex < self.notes.count - 1 ? self.currentIndex + 1 : 0
                            }
                            
                            if self.currentIndex >= self.notes.count - 1 {
                                // Game ends after this last note.
                                self.timer.upstream.connect().cancel()
                                
                                // The final score view is displayed.
                                model.endGame()
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
            .scrollIndicators(ScrollIndicatorVisibility.hidden)
            .scrollDisabled(true)
        }
    }
}
