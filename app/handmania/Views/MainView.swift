//
//  MainView.swift
//  handmania
//
//  Created by Mattia Gallotta on 29/03/23.
//

import SwiftUI

struct MainView: View {
    @StateObject private var gameStatus = GameStatus.getInstace()
    
    let song: Song
    
    var body: some View {
        if (gameStatus.gameDidEnded()) {
            FinalScoreView()
        } else {
            PlayView(song: self.song)
        }
    }
}
