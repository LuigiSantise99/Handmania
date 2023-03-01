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
    
    private var notesCache = [String:[[Int]]]()
    private var audioCache = [String:Data]()
    private var thumbnailCache = [String:Data]()
    
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
            fatalError("unexpected server error: \(error)")
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
            fatalError("unexpected server error: \(error)")
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
