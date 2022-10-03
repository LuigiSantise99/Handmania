//
//  Model.swift
//  handmania
//
//  Created by Mattia Gallotta on 29/09/22.
//

struct Model {
    private static var INSTANCE: Model?
    
    public static func getInstance() -> Model {
        if self.INSTANCE == nil {
            self.INSTANCE = Model()
        }
        
        return self.INSTANCE!
    }
}
