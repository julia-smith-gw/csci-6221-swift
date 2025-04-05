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
//https://www.swiftbysundell.com/articles/swiftui-state-management-guide/
//https://www.reddit.com/r/swift/comments/gb8742/reasoning_behind_observableobjects/
//https://stackoverflow.com/questions/77829110/how-define-a-size-for-image-with-asyncimage

import CoreData
import SwiftUI

@Observable
class GlobalScreenManager: ObservableObject {
  var authorized: Bool = false
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
  @ObservedObject var libraryViewModel: LibraryViewModel = LibraryViewModel()
  @ObservedObject var browseViewModel: BrowseViewModel = BrowseViewModel()
  
  var body: some View {
    NavigationStack {
      if (!globalScreenManager.authorized) {
        ProgressView()
        Text("Fetching authorization...")
      } else if (globalScreenManager.showErrorAlert && !globalScreenManager.authorized) {
        Text("Authorization to Apple Music failed. Please exit the app and try again later.")
      } else {
        TabView {
          LibraryController()
            .tabItem {
              Label("Library", systemImage: "books.vertical.fill")
          }.environmentObject(libraryViewModel)
          
          LikedController().tabItem{
            Label("Liked", systemImage: "heart.fill")
          }
          
          RecommendedViewController()
            .tabItem {
              Label("Recommended", systemImage: "house.fill")
          }
          BrowseViewController().tabItem{Label("Browse", systemImage: "magnifyingglass.circle.fill")}
            .environmentObject(browseViewModel)
          
          SettingsViewController()
            .tabItem {
              Label("Settings", systemImage: "gearshape.fill")
            }
        }.environmentObject(globalScreenManager)
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
        }).environmentObject(globalScreenManager)
        .navigationDestination(isPresented: $globalScreenManager.showFullscreenPlayer ) {
          if audioPlayerViewModel.song != nil {
            PlayerView(song: audioPlayerViewModel.song!, startNew: false)
              .environmentObject(globalScreenManager)
              .transition(.move(edge: .bottom))
          }
        }
      }
    }.task  {
      do {
        try await authenticateToAppleMusic()
        globalScreenManager.authorized = true
      } catch AppleMusicError.authenticationFailed(let reason){
        globalScreenManager.showErrorAlert = true
        globalScreenManager.errorMsg = reason
        globalScreenManager.authorized = false
      } catch {
        globalScreenManager.authorized = false
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
    ZStack{
      HStack(spacing:0) {

      AsyncImage(url: audioPlayerViewModel.song?.artwork?.url(width: 50, height: 50)) { result in
          result.image?
              .resizable()
              .scaledToFill()
          }
          .frame(width: 80, height: 80)

          Spacer()
        HStack {
          Text(audioPlayerViewModel.song?.title ?? "")
            .fontWeight(.semibold)
            .lineLimit(1)
            .padding(.leading, 15)
          
          HStack (spacing: 10) {
            AsyncButton( systemImageName: "backward.fill", action: audioPlayerViewModel.skipBackwards)
              .labelStyle(.iconOnly)
              .imageScale(.large)
            
            AsyncButton(
              systemImageName: audioPlayerViewModel.isPlaying ? "pause.fill" : "play.fill",
               action: audioPlayerViewModel.playOrPause
           )     .imageScale(.large)
       
            AsyncButton( systemImageName: "forward.fill", action: audioPlayerViewModel.skipForwards).labelStyle(.iconOnly)
          }.padding(15)
          .imageScale(.large)
        }.frame(maxWidth: UIScreen.main.bounds.width - 30)
      }.padding(10)
    }

  }
}

#Preview {
  ContentView().environment(
    \.managedObjectContext, PersistenceController.preview.container.viewContext)
}
