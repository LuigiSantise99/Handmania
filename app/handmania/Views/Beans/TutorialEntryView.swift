//
//  TutorialEntryView.swift
//  handmania
//
//  Created by Mattia Gallotta on 31/03/23.
//

import SwiftUI

struct TutorialEntryView: View {
    let description: String
    let imageName: String
    
    var body: some View {
        VStack(alignment: .center) {
            Text(description)
                .font(.body)
                .multilineTextAlignment(.center)
                .padding()
            
            Image(imageName)
                .resizable()
                .frame(width: 233.0, height: 375.0)
                .border(.black, width: 1.0)
        }
    }
}

struct TutorialEntryView_Previews: PreviewProvider {
    static var previews: some View {
        TutorialEntryView(description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec imperdiet sem sit amet ipsum blandit, ac sagittis lectus mattis. Aliquam.", imageName: "tutorial_two_hands")
    }
}
