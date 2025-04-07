//
//  SettingsViewController.swift
//  Spotifyish
//
//  Created by Julia  Smith on 3/30/25.
//
import SwiftUI

struct SettingsViewController: View {
  func logout() {
    AudioPlayerViewModel.shared.clearSong()
    UserDefaults.standard.removeObject(forKey: "signedInUsername")

    if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene
    {
      scene.windows.first?.rootViewController = UIHostingController(
        rootView: WelcomeViewControllerWrapper())
      scene.windows.first?.makeKeyAndVisible()
    }
  }
  
  var body: some View{
    Button("Log Out") {
        logout()
    }
    .foregroundColor(.red)
    .padding()
  }
}
