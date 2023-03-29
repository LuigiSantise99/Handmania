//
//  MainView.swift
//  handmania
//
//  Created by Mattia Gallotta on 29/03/23.
//

import SwiftUI

struct MainView: View {
    @StateObject private var model = Model.getInstace()
    
    let song: Song
    
    var body: some View {
        if (model.gameDidEnded()) {
            FinalScoreView()
        } else {
            PlayView(song: self.song)
        }
    }
}
