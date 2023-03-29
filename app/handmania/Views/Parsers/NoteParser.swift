//
//  NoteParser.swift
//  handmania
//
//  Created by Mattia Gallotta on 09/03/23.
//

import SwiftUI

struct NoteParser {
    private static let directions = [
        "left",
        "bottom",
        "up",
        "right",
    ]
    
    /**
     Checks whether there is at least an active hold.
     
     - Parameter activeHolds: The hold state to check.
     
     - Returns: True if there are active holds, false otherwise.
     */
    private static func thereAreActiveHolds(activeHolds: [Bool]) -> Bool {
        return activeHolds.reduce(false) { $0 || $1 }
    }
    
    /**
     Returns the correct asset name given the note index.
     
     - Parameter noteIndex: The index of the note.
     
     - Returns: The correct asset name.
     */
    static func getNoteImageName(noteIndex: Int) -> String {
        guard noteIndex >= 0 && noteIndex <= 3 else {
            fatalError("Invalid note index: \(noteIndex)")
        }
        
        return "\(directions[noteIndex])_arrow"
    }
    
    /**
     Allows to parse a note index to the appropriate image.
     
     - Parameter note: The note to parse
     - Parameter noteIndex: The index of the note to parse.
     
     - Returns: The correct note image.
     */
    static func parseNoteByIndex(note: Int, noteIndex: Int) -> Image {
        guard noteIndex >= 0 && noteIndex <= 3 else {
            fatalError("Invalid note index: \(noteIndex)")
        }
        
        // If the note is a start or end hold, the state is updated.
        if note > 1 { Model.getInstace().updateActiveHolds(note: note, noteIndex: noteIndex) }
        
        var correctImage: Image? = nil
        
        if (note > 0 && note < 3) {
            correctImage = Image(self.getNoteImageName(noteIndex: noteIndex))
        }
        
        // If the note is three or a zero and there is an active hold, the hold symbol is placed.
        if (note == 3 || (note == 0 && Model.getInstace().checkActiveNote(noteIndex: noteIndex))) {
            correctImage = Image("\(self.getNoteImageName(noteIndex: noteIndex))_hold")
        }
        
        correctImage = correctImage ?? Image("empty_arrow")
        
        return correctImage!.resizable()
    }
}
