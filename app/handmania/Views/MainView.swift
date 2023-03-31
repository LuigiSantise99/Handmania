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
            if (gameStatus.scoreDidSubmitted()) {
                SongChartView(song: self.song)
            } else {
                FinalScoreView(songID: self.song.id)
            }
        } else {
            PlayView(song: self.song)
        }
    }
}
