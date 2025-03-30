//
//  ContentView.swift
//  Spotifyish
//
//  Created by Julia  Smith on 3/25/25.
//

import CoreData
import SwiftUI

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(
        sortDescriptors: [
            NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)
        ],
        animation: .default)
    private var items: FetchedResults<Item>
    
    var body: some View {
        TabView {
            VStack {
                LibraryController()
                Button("Log Out") {
                    logout()
                }
                .foregroundColor(.red)
                .padding()
            }
            .tabItem {
                Label("Library", systemImage: "books.vertical.fill")
            }
            
            LikedController()
                .tabItem {
                    Label("Liked", systemImage: "heart.fill")
                }
            
            RecommendedViewController()
                .tabItem {
                    Label("Recommended", systemImage: "house.fill")
                }
            
            BrowseViewController()
                .tabItem {
                    Label("Browse", systemImage: "magnifyingglass.circle.fill")
                }
        }
    }
    
    func logout() {
        UserDefaults.standard.removeObject(forKey: "signedInUsername")
        
        if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            scene.windows.first?.rootViewController = UIHostingController(rootView: WelcomeViewControllerWrapper())
            scene.windows.first?.makeKeyAndVisible()
        }
    }
}
            

//MINI PLAYER JULIA WORK IN PROGRESS
//struct MusicInfo:View{
//  @ObservedObject var audioPlayerViewModel = AudioPlayerViewModel.shared
//  var body: some View {
//    HStack(spacing:0) {
//      GeometryReader {
//        let size = $0.size
//        Image(audioPlayerViewModel.song!.imageName)
//          .resizable()
//          .aspectRatio(contentMode: .fill)
//          .frame(width: size.width, height: size.height)
//      }.frame(width: 45, height: 45)
//      
//   
//    }
//  }
//}
//
//@ViewBuilder
//func MiniPlayer() -> some View {
//  ZStack {
//    Rectangle()
//      .fill(.ultraThickMaterial)
//      .overlay{
//        MusicInfo()
//      }
//  }.frame(height:80)
//    .overlay(alignment: .bottom, content: {
//      Rectangle().fill(.gray.opacity(0.1))
//        .frame(height:1)
//        .padding(.horizontal, 20).offset(y:-10)
//    })
//    .offset(y:-49)
//}

#Preview {
  ContentView().environment(
    \.managedObjectContext, PersistenceController.preview.container.viewContext)
}
