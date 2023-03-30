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
    let spn: Float
    
    var id: String { _id }
}
