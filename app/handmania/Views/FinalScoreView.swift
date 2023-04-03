//
//  FinalScoreView.swift
//  handmania
//
//  Created by Mattia Gallotta on 29/03/23.
//

import SwiftUI

struct FinalScoreView: View {
    private static let LIGTH_GRAY = Color(red: 220, green: 220, blue: 220)
    
    @Environment (\.colorScheme) var colorScheme
    
    private let logger = Logger(tag: String(describing: FinalScoreView.self))
    
    let songID: String
    
    @State private var userName: String = ""
    @State private var requestPending = false
    
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
                .background(colorScheme == .light ? .black : .white)
                .padding(.bottom)
            
            Text("Inserisci il tuo nome per aggiungere il risultato nella classifica della canzone")
                .font(.body)
                .multilineTextAlignment(.center)
                .padding()
            
            VStack {
                HStack {
                    Text("Nome:")
                        .padding([.leading, .bottom])
                    
                    TextField("Luigi o Mattia...", text: $userName)
                        .foregroundColor(colorScheme == .light ? .gray : FinalScoreView.LIGTH_GRAY)
                        .onSubmit { self.uploadChartEntry() }
                        .submitLabel(.done)
                        .padding([.leading, .trailing, .bottom])
                }
                
                Button(action: { self.uploadChartEntry() }) { Text("Conferma") }
                    .buttonStyle(.bordered)
                    .tint(.green)
                    .disabled(self.requestPending)
                    .padding(1.0)
            }
            .frame(maxWidth: 270.0)
            .padding()
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(colorScheme == .light ? .gray : FinalScoreView.LIGTH_GRAY, lineWidth: 1.0)
            )
        }
        .zIndex(.infinity)
        .navigationBarBackButtonHidden(true)
    }
    
    /**
     Allows the user to mark the request as done in the main thread.
     */
    @MainActor private func freePendingRequest() {
        self.requestPending = false
    }
    
    /**
     Allows the user to activate the alert in the main thread.
     */
    @MainActor private func activateAlert() {
        AlertStatus.getInstace().markAlertAsToShow()
    }
    
    /**
     Allows the user to mark the score as submitted in the status model.
     */
    @MainActor private func markScoreAsSubmitted() {
        GameStatus.getInstace().submitScore()
    }
    
    /**
     Allows the user to upload the chart entry to the server.
     */
    @MainActor private func uploadChartEntry() {
        guard !self.requestPending else {
            logger.log("already a request pending, ignoring it")
            return
        }
        
        let name = self.userName.trimmingCharacters(in: .whitespacesAndNewlines)
        
        // The name should at least contain a character that is not a space or a new line.
        if name == "" {
            logger.log("empty name specified")
            AlertStatus.getInstace().markAlertAsToShow()
            return
        }
        
        // The request is started and so it is marked as pending.
        self.requestPending = true
        
        Task {
            do {
                // The user name and score are sent to the server.
                let httpStatus = try await ServerManager.postSongChartEntry(songID: self.songID, chartEntry: NewChartEntry(name: name, score: Model.getInstace().getScore()))
                
                // The request is not pending anymore.
                self.freePendingRequest()
                
                if httpStatus != 200 {
                    self.activateAlert()
                } else {
                    // The score is marked as submitted, now the chart will be shown.
                    self.markScoreAsSubmitted()
                }
            } catch {
                logger.log("unexpected server error: \(error)")
            }
        }
    }
    
    struct FinalScoreView_Previews: PreviewProvider {
        static var previews: some View {
            FinalScoreView(songID: "")
        }
    }
}
