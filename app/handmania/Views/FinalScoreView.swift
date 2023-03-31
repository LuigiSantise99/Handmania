//
//  FinalScoreView.swift
//  handmania
//
//  Created by Mattia Gallotta on 29/03/23.
//

import SwiftUI

struct FinalScoreView: View {
    @Environment (\.colorScheme) var colorScheme
    
    private let logger = Logger(tag: String(describing: FinalScoreView.self))
    
    let songID: String
    
    @State private var userName: String = ""
    @State private var showAlert = false
    
    var body: some View {
        VStack(alignment: .center) {
            Image(systemName: "crown.fill")
                .resizable()
                .foregroundColor(.yellow)
                .frame(width: 64.0, height: 55.0)
                .padding()
            
            Text("Congratulazioni! Il tuo punteggio è:")
                .font(.body)
                .padding()
            
            Text("\(Model.getInstace().getScore())")
                .font(.headline)
                .padding()
            
            Divider()
                .frame(width: 150.0)
                .background(Color.black)
                .padding(.bottom)
            
            Text("Inserisci il tuo nome per aggiungere il risultato nella classifica della canzone:")
                .font(.body)
                .multilineTextAlignment(.center)
                .padding([.leading, .trailing, .top])
            
            // View that allows the user to submit the score.
            TextField(text: $userName) {
                Text("Nome")
                    .font(.body)
                    .foregroundColor(colorScheme == .light ? .gray : Color(red: 220, green: 220, blue: 220))
            }
            .onSubmit {
                let name = self.userName.trimmingCharacters(in: .whitespacesAndNewlines)
                
                if name == "" {
                    logger.log("empty name specified")
                    self.showAlert = true
                } else {
                    Task {
                        do {
                            // The user name and score are sent to the server.
                            let httpStatus = try await ServerManager.postSongChartEntry(songID: self.songID, chartEntry: NewChartEntry(name: name, score: Model.getInstace().getScore()))
                            
                            if httpStatus != 200 {
                                self.showAlert = true
                            } else {
                                GameStatus.getInstace().submitScore()
                            }
                        } catch {
                            logger.log("unexpected server error: \(error)")
                        }
                    }
                }
            }
            .overlay(
                RoundedRectangle(cornerRadius: 7.5).stroke(colorScheme == .light ? .black : .white)
            )
            .multilineTextAlignment(.center)
            .submitLabel(.done)
            .padding()
            .frame(width: 170.0)
            
            if (showAlert) {
                Text("⚠ Attenzione! Si è verificato un errore durante l'invio del punteggio. Assicurati di aver inserito un nome valido.")
                    .multilineTextAlignment(.center)
                    .foregroundColor(.red)
                    .padding([.leading, .trailing, .bottom])
            }
        }
        .navigationBarBackButtonHidden(true)
    }
    
    struct FinalScoreView_Previews: PreviewProvider {
        static var previews: some View {
            FinalScoreView(songID: "")
        }
    }
}
