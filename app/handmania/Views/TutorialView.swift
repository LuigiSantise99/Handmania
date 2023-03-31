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
        "Muovi le tue mani sopra, sotto, a destra e sinistra rispetto al viso inquadrato per premere le corrispondenti frecce direzionali sullo schermo. Assicurati che il viso rimanga al centro.",
        "Quando una freccia colorata si sovrappone alla sua controparte vuota, è necessario posizionare la mano nella stessa direzione della freccia colorata.",
        "Se posizioni la mano nella stessa direzione della freccia colorata entro il tempo previsto, otterrai 10 punti.",
        "Se la freccia colorata è seguita da più frecce blu, significa che devi mantenere la mano nella stessa direzione fino alla fine della sequenza."
        
    ]
    private static let IMAGES = [
        "tutorial_two_hands",
        "tutorial_up",
        "tutorial_glow",
        "tutorial_hold"
    ]
    
    @State var progressive = 0
    
    var body: some View {
        GeometryReader { proxy in
            ScrollView(showsIndicators: false) {
                VStack(alignment: .center) {
                    Text("Tutorial")
                        .font(.title)
                        .padding(.top, 30.0)
                    
                    TutorialEntryView(description: TutorialView.DESCRIPTIONS[progressive], imageName: TutorialView.IMAGES[progressive])
                        .frame(width: proxy.size.width - 150.0, height: proxy.size.height - 150.0)
                        .padding([.leading, .trailing])
                    
                    
                    Button(self.progressive < TutorialView.IMAGES.count - 1 ? "Avanti" : "Fine") {
                        if self.progressive == TutorialView.IMAGES.count - 1 {
                            dismiss()
                        } else {
                            self.progressive += 1
                        }
                    }
                    .buttonStyle(.borderedProminent)
                    .padding(.top)
                }
                .frame(maxWidth: .infinity)
            }
        }
    }
}

struct TutorialView_Previews: PreviewProvider {
    static var previews: some View {
        TutorialView()
    }
}
