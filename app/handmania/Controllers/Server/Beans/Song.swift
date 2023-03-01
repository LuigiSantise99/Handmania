//
//  Song.swift
//  handmania
//
//  Created by Mattia Gallotta on 22/11/22.
//

import Foundation

struct Song: Codable, Hashable, Identifiable {
    let _id: String
    let title: String
    let artist: String
    let genre: String
    let preview: Preview
    
    var id: String { _id }
}
