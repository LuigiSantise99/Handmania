//
//  SongChartView.swift
//  handmania
//
//  Created by Mattia Gallotta on 31/03/23.
//

import SwiftUI

struct SongChartView: View {
    private let logger = Logger(tag: String(describing: SongChartView.self))
    
    let song: Song
    
    @State private var chart: [ChartEntry] = []
    
    var body: some View {
        VStack(alignment: .center) {
            HStack(alignment: .center) {
                Image("logo")
                    .resizable()
                    .frame(width: 80.0, height: 80.0)
                
                Text("Classifica")
                    .font(.title)
            }
            
            HStack(alignment: .center) {
                NavigationLink(destination: MainView(song: song)) {
                    Text("Riprova")
                }
                .buttonStyle(.bordered)
                .tint(.blue)
                .padding(.trailing, 30.0)
                
                NavigationLink("Continua", destination: SongsView(songs: Model.getInstace().songs))
                .buttonStyle(.bordered)
                .tint(.green)
            }
            .padding()
            
            List(self.chart) { entry in
                HStack(alignment: .center) {
                    Text(entry.name)
                    
                    Spacer()
                    
                    Text("\(entry.score)")
                }
            }
        }
        .task {
            // The chart of the song is retireved.
            do  {
                self.chart = try await ServerManager.fetchSongChart(songID: self.song.id)
            } catch {
                logger.log("unexpected server error: \(error)")
            }
        }
        .onDisappear {
            // The game status is reset in order to start a new game.
            GameStatus.getInstace().stopGame()
            GameStatus.getInstace().resetEndGame()
            GameStatus.getInstace().resetSubmitScore()
        }
        .navigationBarBackButtonHidden(true)
    }
}

struct SongChartView_Previews: PreviewProvider {
    static var previews: some View {
        SongChartView(song: Song(_id: "64259eded06d4ec992f47383", title: "", artist: "", genre: "", spn: 0.0))
    }
}
