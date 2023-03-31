//
//  TutorialView.swift
//  handmania
//
//  Created by Mattia Gallotta on 31/03/23.
//

import SwiftUI

struct TutorialView: View {
    @Environment(\.dismiss) var dismiss
    
    private static let DESCRIPTIONS = [
        "Muovi le tue mani sopra, sotto, a destra e sinistra rispetto al viso inquadrato per premere le corrispondenti frecce direzionali sullo schermo. Assicurati che il viso rimanga al centro",
        "Quando una freccia colorata si sovrappone alla sua controparte vuota, è necessario posizionare la mano nella stessa direzione della freccia colorata",
        "Se posizioni la mano nella stessa direzione della freccia colorata entro il tempo previsto, otterrai dieci punti",
        "Se la freccia colorata è seguita da più frecce blu, significa che devi mantenere la mano nella stessa direzione fino alla fine della sequenza"
        
    ]
    private static let IMAGES = [
        "tutorial_two_hands",
        "tutorial_up",
        "tutorial_glow",
        "tutorial_hold"
    ]
    
    @State var progressive = 0
    
    var body: some View {
        TutorialEntryView(description: TutorialView.DESCRIPTIONS[progressive], imageName: TutorialView.IMAGES[progressive])
            .frame(maxWidth: 450.0, maxHeight: 950.0)
            .overlay(alignment: .bottom) {
                Button(self.progressive < TutorialView.IMAGES.count - 1 ? "Avanti" : "Fine") {
                    if self.progressive == TutorialView.IMAGES.count - 1 {
                        dismiss()
                    } else {
                        self.progressive += 1
                    }
                }
                .buttonStyle(.bordered)
                .tint(.blue)
                .padding()
            }
            .padding()
    }
}

struct TutorialView_Previews: PreviewProvider {
    static var previews: some View {
        TutorialView()
    }
}
