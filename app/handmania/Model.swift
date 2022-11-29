//
//  Model.swift
//  handmania
//
//  Created by Mattia Gallotta on 29/11/22.
//

import Foundation

class Model: ObservableObject {
    private static var INSTANCE: Model?
    @Published var songs = [Song]()
    private var audioCache = [String:Data]()
    private var notesCache = [String:[[String]]]()
    
    init() {
        Task {
            do {
                // The song list is retrieved from the server.
                let songs = try await ServerModel.fetchSongs()
                await self.setSongs(songs: songs)
            } catch {
                fatalError("unexpected server error: \(error)")
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
     Provides the correct audio file with respect to the requested song.
     
     - Parameter songID: The ID of the song the audio is needed.
     
     - Returns: The song chart of the requested song.
     */
    func getSongAudio(songID: String) async -> Data {
        // The value is first lokked into the cache.
        if let audio = audioCache[songID] {
            return audio
        }
        
        do  {
            let audio = try await ServerModel.fetchSongAudio(songID: songID)
            let audioData = Data(base64Encoded: audio.b64, options: .ignoreUnknownCharacters)
            
            audioCache[songID] = audioData
            
            return audioData!
        } catch {
            fatalError("unexpected server error: \(error)")
        }
    }
    
    /**
     Provides the correct note chart with respect to the requested song.
     
     - Parameter songID: The ID of the song the note chart is needed.
     
     - Returns: The song chart of the requested song.
     */
    func getSongNotes(songID: String) async -> [[String]] {
        // The value is firts lokked into the cache.
        if let notes = notesCache[songID] {
            return notes
        }
        
        do  {
            let notes = try await ServerModel.fetchSongNotes(songID: songID)
            
            notesCache[songID] = notes.notes
            
            return notes.notes
        } catch {
            fatalError("unexpected server error: \(error)")
        }
    }
    
    public static func getInstace() -> Model {
        if self.INSTANCE == nil {
            self.INSTANCE = Model()
        }
        
        return self.INSTANCE!
    }
}
