//
//  ContentView.swift
//  handmania
//
//  Created by Mattia Gallotta on 24/06/22.
//

import SwiftUI

struct ContentView: View {
    private var appName: String {
        get {
            // The app name is set as an environment variable.
            guard let appName = ProcessInfo.processInfo.environment["APP_NAME"] else {
                fatalError("unspecified app name")
            }
            
            return appName
        }
    }
    
    @StateObject private var handDirectionManager = HandDirectionsManager.getInstance()
    @StateObject private var model = Model.getInstace()
    
    var body: some View {
        VStack (alignment: .center) {
            NavigationStack {
                VStack(alignment: .center) {
                    Image("logo")
                        .resizable()
                        .frame(width: 175.0, height: 175.0)
                    Text(appName)
                        .font(.title)
                        .multilineTextAlignment(.center)
                        .padding()
                    Text("Progetto di \"Sviluppo di Applicazioni per Dispositivi Mobili\"\nGallotta, Santise")
                        .font(.subheadline)
                        .multilineTextAlignment(.center)
                        .padding([.leading, .trailing, .bottom])
                    
                    if model.songsHaveArrived {
                        NavigationLink("Inizia a giocare!", destination: SongsView(songs: Model.getInstace().songs))
                            .buttonStyle(.borderedProminent)
                            .multilineTextAlignment(.center)
                            .padding()
                    } else {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle())
                            .scaleEffect(1.5)
                            .padding()
                    }
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
