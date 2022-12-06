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
                VStack {
                    Image("Logo")
                        .resizable()
                        .frame(width: 256.0, height: 256.0)
                    Text(appName)
                        .font(.system(size: 36))
                        .padding()
                    Text("Progetto di \"Sviluppo di Applicazioni per Dispositivi Mobili\"")
                        .font(.system(size: 20))
                    Text("Gallotta, Santise")
                        .font(.system(size: 20))
                    
                    if model.songsHaveArrived {
                        NavigationLink("Inizia a giocare!", destination: SongsView(songs: Model.getInstace().songs))
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
