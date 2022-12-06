//
//  Logger.swift
//  handmania
//
//  Created by Mattia Gallotta on 06/12/22.
//

struct Logger {
    private let tag: String
    
    init(tag: String) {
        self.tag = tag.uppercased()
    }
    
    func log(_ message: String) {
        print("\(tag): \(message)")
    }
}
