//
//  NumberParser.swift
//  handmania
//
//  Created by Mattia Gallotta on 28/03/23.
//

import SwiftUI

struct NumberParser {
    /**
     Returns the correct asset name given the number..
     
     - Parameter number: The number to parse..
     
     - Returns: The correct asset name.
     */
    private static func getNumberImageName(number: Int) -> String {
        guard number >= 1 && number <= 3 else {
            return ""
        }
        
        return "number_\(number)"
    }
    
    /**
     Allows to parse a number to the appropriate image.
     
     - Parameter number: The number to parse
     
     - Returns: The correct number image.
     */
    static func parseNumber(number: Int) -> Image {
        return Image(self.getNumberImageName(number: number)).resizable()
    }
}
