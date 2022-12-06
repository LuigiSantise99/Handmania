//
//  WelcomeView.swift
//  handmania
//
//  Created by Mattia Gallotta on 06/12/22.
//

import SwiftUI

struct WelcomeView: View {
    private static var APP_NAME: String {
        get {
            // The app name is set as an environment variable.
            guard let appName = ProcessInfo.processInfo.environment["APP_NAME"] else {
                fatalError("unspecified app name")
            }
            
            return appName
        }
    }
    
    var songsHaveArrived: Bool
    
    var body: some View {
        NavigationStack {
            VStack {
                Image("Logo")
                    .resizable()
                    .frame(width: 256.0, height: 256.0)
                Text(WelcomeView.APP_NAME)
                    .font(.system(size: 36))
                    .padding()
                Text("Progetto di \"Sviluppo di Applicazioni per Dispositivi Mobili\"")
                    .font(.system(size: 20))
                Text("Gallotta, Santise")
                    .font(.system(size: 20))
                
                if songsHaveArrived {
                    NavigationLink("Inizia a giocare!", destination: SongsView(songs: Model.getInstace().songs))
                        .padding()
                }
            }
        }
    }
}
