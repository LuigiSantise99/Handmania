//
//  ServerModel.swift
//  handmania
//
//  Created by Mattia Gallotta on 29/09/22.
//

import Foundation

struct ServerManager {
    private static var INSTANCE: ServerManager?
    private static var SERVER_URL: String {
        get {
            // The server base URL is set as an environment variable.
            guard let serverURL = ProcessInfo.processInfo.environment["SERVER_URL"] else {
                fatalError("unspecified base server URL")
            }
            
            return serverURL
        }
    }
    private static var SERVER_PASSWORD: String {
        get {
            // The server password is set as an environment variable.
            guard let serverPassword = ProcessInfo.processInfo.environment["SERVER_PASSWORD"] else {
                fatalError("unspecified server password")
            }
            
            return serverPassword
        }
    }
    
    private static let LOGGER = Logger(tag: String(describing: ServerManager.self))

    /**
     Gathers all songs information from the remote server.

     - Throws: A `InvalidURL` error, if the specified URL is not valid.
     
     - Returns: The list of available songs from the server.
     */
    static func fetchSongs() async throws -> [Song] {
        // The URL is created.
        guard let url = URL(string: "\(SERVER_URL)/songs/") else {
            throw ServerError.InvalidURL
        }
        
        LOGGER.log("getting \(url)...")
        
        // The password is set.
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue(SERVER_PASSWORD, forHTTPHeaderField: "Authorization")
        
        // Data task is created and executed.
        let (result, _) = try await URLSession.shared.data(for: request)
        LOGGER.log("\(url) responded correctly")
        
        // Data is parsed and returned.
        let songs = try JSONDecoder().decode([Song].self, from: result)
        LOGGER.log("\(url) result unmarshalled correctly")
        return songs
    }
    
    /**
     Gathers the song chart of a song from the remote server.
     
     - Parameter songID: The ID of the song the note chart  is needed.
     
     - Throws: A `InvalidURL` error, if the specified URL is not valid.
     
     - Returns: The song chart of the requested song.
     */
    static func fetchSongNotes(songID: String) async throws -> Notes {
        // The URL is created.
        guard let url = URL(string: "\(SERVER_URL)/songs/\(songID)/notes/") else {
            throw ServerError.InvalidURL
        }
        
        LOGGER.log("getting \(url)...")
        
        // The password is set.
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue(SERVER_PASSWORD, forHTTPHeaderField: "Authorization")
        
        // Data task is created and executed.
        let (result, _) = try await URLSession.shared.data(for: request)
        LOGGER.log("\(url) responded correctly")
        
        // Data is parsed and returned.
        let notes = try JSONDecoder().decode(Notes.self, from: result)
        return notes
    }
    
    /**
     Gathers the Base64 string representing the audio of a song from the remote server.
     
     - Parameter songID: The ID of the song the audio is needed.
     
     - Throws: A `InvalidURL` error, if the specified URL is not valid.
     
     - Returns: The audio of the requested song.
     */
    static func fetchSongAudio(songID: String) async throws -> Audio {
        // The URL is created.
        guard let url = URL(string: "\(SERVER_URL)/songs/\(songID)/audio/") else {
            throw ServerError.InvalidURL
        }
        
        LOGGER.log("getting \(url)...")
        
        // The password is set.
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue(SERVER_PASSWORD, forHTTPHeaderField: "Authorization")
        
        // Data task is created and executed.
        let (result, _) = try await URLSession.shared.data(for: request)
        LOGGER.log("\(url) responded correctly")
        
        // Data is parsed and returned.
        let audio = try JSONDecoder().decode(Audio.self, from: result)
        LOGGER.log("\(url) result unmarshalled correctly")
        return audio
    }
    
    /**
     Gathers the Base64 string representing the thumbnail of a song from the remote server.
     
     - Parameter songID: The ID of the song the thumbnail is needed.
     
     - Throws: A `InvalidURL` error, if the specified URL is not valid.
     
     - Returns: The thumbnail of the requested song.
     */
    static func fetchSongThumbnail(songID: String) async throws -> Thumbnail {
        // The URL is created.
        guard let url = URL(string: "\(SERVER_URL)/songs/\(songID)/thumbnail/") else {
            throw ServerError.InvalidURL
        }
        
        LOGGER.log("getting \(url)...")
        
        // The password is set.
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue(SERVER_PASSWORD, forHTTPHeaderField: "Authorization")
        
        // Data task is created and executed.
        let (result, _) = try await URLSession.shared.data(for: request)
        LOGGER.log("\(url) responded correctly")
        
        // Data is parsed and returned.
        let thumbnail = try JSONDecoder().decode(Thumbnail.self, from: result)
        LOGGER.log("\(url) result unmarshalled correctly")
        return thumbnail
    }

    public static func getInstance() -> ServerManager {
        if self.INSTANCE == nil {
            self.INSTANCE = ServerManager()
        }
        
        return self.INSTANCE!
    }
}
