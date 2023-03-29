//
//  FinalScoreView.swift
//  handmania
//
//  Created by Mattia Gallotta on 29/03/23.
//

import SwiftUI

struct FinalScoreView: View {
    @State private var userName: String = ""
    
    var body: some View {
        VStack(alignment: .center) {
            Image(systemName: "crown.fill")
                .resizable()
                .foregroundColor(.yellow)
                .frame(width: 64.0, height: 55.0)
                .padding()
            
            Text("Congratulazioni! Il tuo punteggio è:")
                .font(.system(size: 16.0))
                .padding()
            
            Text("\(Model.getInstace().getScore())")
                .font(.system(size: 32.0))
                .padding()
            
            Divider()
                .frame(width: 150.0)
                .background(Color.black)
                .padding(.bottom)
            
            Text("Inserisci il tuo nome per aggiungere il risultato nella classifica della canzone:")
                .font(.system(size: 16.0))
                .multilineTextAlignment(.center)
                .padding()
            
            // View that allows the user to submit the score.
            TextField(text: $userName) {
                Text("Nome utente")
                    .font(.system(size: 16.0))
            }
            .textFieldStyle(.roundedBorder)
            .multilineTextAlignment(.center)
            .submitLabel(.done)
            .padding()
            .frame(width: 170.0)
        }
        .navigationBarBackButtonHidden(true)
    }
}
