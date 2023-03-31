//
//  PermissionDeniedView.swift
//  handmania
//
//  Created by Mattia Gallotta on 30/03/23.
//

import SwiftUI

struct PermissionDeniedView: View {
    @Environment (\.colorScheme) var colorScheme
    
    var body: some View {
        VStack(alignment: .center) {
            Image(systemName: "exclamationmark.triangle")
                .resizable()
                .foregroundColor(colorScheme == .light ? .gray : .white)
                .frame(width: 45.0, height: 45.0)
                .padding([.leading, .trailing, .top])
            
            Text("Attenzione")
                .font(.headline)
                .padding([.leading, .trailing, .top])
            
            Text("Per utilizzare l'applicazione, è necessario fornire l'autorizzazione di accesso alla fotocamera; accertati che questa sia concessa")
                .font(.body)
                .multilineTextAlignment(.center)
                .padding()
        }
        .frame(maxHeight: .infinity)
    }
}

struct PermissionDeniedView_Previews: PreviewProvider {
    static var previews: some View {
        PermissionDeniedView()
    }
}
