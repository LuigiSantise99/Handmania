//
//  ChartEntry.swift
//  handmania
//
//  Created by Mattia Gallotta on 30/03/23.
//

import Foundation

struct ChartEntry: Codable, Hashable, Identifiable {
    let _id: String
    let name: String
    let score: Int
    let song_id: String
    
    var id: String { _id }
}
