//
//  ContentView.swift
//  Spotifyish
//
//  Created by Julia  Smith on 3/25/25.
//
/// Makes a new search request to MusicKit when the current search term changes.
import SwiftUI
import MusicKit

//https://stackoverflow.com/questions/73488386/swiftui-animation-from-screen-bottom-not-working-properly
//https://www.youtube.com/watch?v=vqPK8qFsoBg&t=145s
//https://www.reddit.com/r/SwiftUI/comments/s5npb6/how_to_increasedecrease_the_size_of_a_view/
//https://developer.apple.com/documentation/swiftui/view/navigationdestination(for:destination:)
//https://stackoverflow.com/questions/65757784/how-to-best-pass-data-for-form-editing-in-swuiftui-while-having-that-data-avail


import CoreData
import SwiftUI

@Observable
class GlobalScreenManager: ObservableObject {
  var showFullscreenPlayer: Bool = false
  var showErrorAlert: Bool = false
  var errorMsg: String = ""
}

struct ContentView: View {
  @Environment(\.managedObjectContext) private var viewContext

  @FetchRequest(
    sortDescriptors: [
      NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)
    ],
    animation: .default)
  private var items: FetchedResults<Item>
  
  @ObservedObject var audioPlayerViewModel = AudioPlayerViewModel.shared
  @StateObject private var globalScreenManager: GlobalScreenManager = GlobalScreenManager()
  
  
  func requestUpdatedSearchResults(for searchTerm: String = "evanescence") {
    Task {
      do {
        var searchRequest = MusicCatalogSearchRequest(term: searchTerm, types: [Album.self])
        searchRequest.limit = 5
        let searchResponse = try await searchRequest.response()
        print(searchResponse)
      } catch {
        print("Search request failed with error: \(error).")
      }
    }
  }
  

  
  var body: some View {
    NavigationStack {
      TabView {
        LibraryController()
          .tabItem {
            Label("Library", systemImage: "books.vertical.fill")
        }.environmentObject(globalScreenManager)
        LikedController().tabItem{
          Label("Liked", systemImage: "heart.fill")
        }
        
        RecommendedViewController()
          .tabItem {
            Label("Recommended", systemImage: "house.fill")
        }
        BrowseViewController().tabItem{Label("Browse", systemImage: "magnifyingglass.circle.fill")}
        
        SettingsViewController()
          .tabItem {
            Label("Settings", systemImage: "gearshape.fill")
          }
      }
      .safeAreaInset(edge: .bottom, content: {
        if (audioPlayerViewModel.song != nil) {
          ZStack {
            Rectangle()
              .fill(.ultraThickMaterial)
              .overlay{
                MusicInfo()
              }
          }
          .gesture(TapGesture(count: 1)
            .onEnded{
              withAnimation {
                globalScreenManager.showFullscreenPlayer=true
              }
            }
          )
          .frame(maxHeight: 80)
          .offset(y:-49)
        }
      }).navigationDestination(isPresented: $globalScreenManager.showFullscreenPlayer ) {
//        if audioPlayerViewModel.song != nil {
//          PlayerView(song: audioPlayerViewModel.song!, startNew: false)
//            .transition(.move(edge: .bottom))
//        }
      }
    }.task  {
      do {
        try await authenticateToAppleMusic()
      } catch AppleMusicError.authenticationFailed(let reason){
        globalScreenManager.showErrorAlert = true
        globalScreenManager.errorMsg = reason
      } catch {
        globalScreenManager.showErrorAlert = true
        globalScreenManager.errorMsg = error.localizedDescription
      }
    }.alert(isPresented: $globalScreenManager.showErrorAlert) {
      Alert(title: Text("Error"), message: Text(globalScreenManager.errorMsg), dismissButton: .default(Text("OK")))
    }
  }
}


//MINI PLAYER JULIA WORK IN PROGRESS
// source https://www.youtube.com/watch?v=_KohThDWl5Y
struct MusicInfo:View{
  @ObservedObject var audioPlayerViewModel = AudioPlayerViewModel.shared
  var body: some View {
    HStack(spacing:0) {
      GeometryReader {
        let size = $0.size
        AsyncImage(url: audioPlayerViewModel.song?.artwork?.url(width: Int(size.width), height: Int(size.height)))
          .aspectRatio(contentMode: .fill)
          .frame(width: size.width, height: size.height)
      }.frame(width: 45, height: 45)
      
        Text(audioPlayerViewModel.song?.title ?? "")
          .fontWeight(.semibold)
          .lineLimit(1)
          .padding(.leading, 15)
        
        HStack (spacing: 5) {
          Button("Play last", systemImage: "backward.fill", action: audioPlayerViewModel.skipBackwards)
            .labelStyle(.iconOnly)

          Button("Play or pause", systemImage: audioPlayerViewModel.isPlaying ? "pause.fill" : "play.fill", action:audioPlayerViewModel.playOrPause
          ).labelStyle(.iconOnly)
     
          Button("Play next", systemImage: "forward.fill", action: audioPlayerViewModel.skipForwards).labelStyle(.iconOnly)
        }.padding(5)
      
    }.padding(10)
  }
}

#Preview {
  ContentView().environment(
    \.managedObjectContext, PersistenceController.preview.container.viewContext)
}
