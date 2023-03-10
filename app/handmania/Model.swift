//
//  Model.swift
//  handmania
//
//  Created by Mattia Gallotta on 29/11/22.
//

import Foundation

class Model: ObservableObject {
    private static var INSTANCE: Model?
    private static let LOGGER = Logger(tag: String(describing: Model.self))
    
    private static let START_HOLD_NOTE = 2
    private static let END_HOLD_NOTE = 3
    
    @Published var songs = [Song]()
    
    private var notesCache = [String:[[Int]]]()
    private var audioCache = [String:Data]()
    private var thumbnailCache = [String:Data]()
    
    private var activeHolds = [false, false, false, false]
    
    var songsHaveArrived: Bool {
        get {
            songs.count > 0
        }
    }
    
    init() {
        Task {
            do {
                // The song list is retrieved from the server.
                let songs = try await ServerManager.fetchSongs()
                await self.setSongs(songs: songs)
            } catch {
                Model.LOGGER.log("unexpected server error: \(error)")
            }
        }
    }
    
    /**
     Initializes the new songs  in the main thread.
     
     - Parameter songs: The new songs.
     */
    @MainActor func setSongs(songs: [Song]) {
        self.songs = songs
    }
    
    /**
     Provides the correct note chart with respect to the requested song.
     
     - Parameter songID: The ID of the song the note chart is needed.
     
     - Returns: The chart of the requested song.
     */
    func getSongNotes(songID: String) async -> [[Int]] {
        // The value is first looked into the cache.
        if let notes = notesCache[songID] {
            return notes
        }
        
        do  {
            let notes = try await ServerManager.fetchSongNotes(songID: songID)
            
            notesCache[songID] = notes.notes
            
            return notes.notes
        } catch {
            Model.LOGGER.log("unexpected server error: \(error)")
            return [[Int]]()
        }
    }
    
    /**
     Provides the correct audio file with respect to the requested song.
     
     - Parameter songID: The ID of the song the audio is needed.
     
     - Returns: The audio of the requested song.
     */
    func getSongAudio(songID: String) async -> Data {
        // The value is first looked into the cache.
        if let audio = audioCache[songID] {
            return audio
        }
        
        do  {
            let audio = try await ServerManager.fetchSongAudio(songID: songID)
            let audioData = Data(base64Encoded: audio.audio, options: .ignoreUnknownCharacters)
            
            audioCache[songID] = audioData
            
            return audioData!
        } catch {
            Model.LOGGER.log("unexpected server error: \(error)")
            return Data()
        }
    }
    
    /**
     Provides the correct thumbnail file with respect to the requested song.
     
     - Parameter songID: The ID of the song the thumbnail is needed.
     
     - Returns: The thumbnail of the requested song.
     */
    func getSongThumbnail(songID: String) async -> Data {
        // The value is first looked into the cache.
        if let thumbnail = thumbnailCache[songID] {
            return thumbnail
        }
        
        do  {
            let thumbnail = try await ServerManager.fetchSongThumbnail(songID: songID)
            let thumbnailData = Data(base64Encoded: thumbnail.thumbnail, options: .ignoreUnknownCharacters)
            
            thumbnailCache[songID] = thumbnailData
            
            return thumbnailData!
        } catch {
            Model.LOGGER.log("unexpected server error: \(error)")
            return Data()
        }
    }
    
    /**
     Allows the user to update the state of an active hold.
     
     - Parameter note: The current note the update is based on.
     - Parameter noteIndex: The index of the ndoe in the row.
     */
    func updateActiveHolds(note: Int, noteIndex: Int) {
        guard noteIndex >= 0 && noteIndex <= 3 else {
            fatalError("Invalid note index: \(noteIndex)")
        }
        
        // If the note is a 2, the hold is started in noteIndex position.
        if note == Model.START_HOLD_NOTE { self.activeHolds[noteIndex] = true }
        
        // If the note is a 3, the hold is ended in noteIndexPosition.
        if note == Model.END_HOLD_NOTE { self.activeHolds[noteIndex] = false }
    }
    
    /**
     Allows the user to check if there is an active note at the specified index.
     
     - Parameter noteIndex: The index of the ndoe in the row.
     
     - Returns: True if there is an active hold, false otherwise.
     */
    func checkActiveNote(noteIndex: Int) -> Bool {
        guard noteIndex >= 0 && noteIndex <= 3 else {
            fatalError("Invalid note index: \(noteIndex)")
        }
        
        return self.activeHolds[noteIndex]
    }
    
    public static func getInstace() -> Model {
        if self.INSTANCE == nil {
            self.INSTANCE = Model()
        }
        
        return self.INSTANCE!
    }
}
