//
//  ContentView.swift
//  Spotifyish
//
//  Created by Julia  Smith on 3/25/25.
//

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
  @State private var height: CGFloat=80
  var body: some View {
    NavigationStack {
      
      TabView {
        LibraryController()
          .tabItem {
            Label("Library", systemImage: "books.vertical.fill")
        }
        LikedController().tabItem{
          Label("Liked", systemImage: "heart.fill")
        }
        
        RecommendedViewController()
          .tabItem {
            Label("Recommended", systemImage: "house.fill")
        }
        BrowseViewController().tabItem{Label("Browse", systemImage: "magnifyingglass.circle.fill")}
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
          .gesture(DragGesture()
            .onChanged { value in
              let newHeight =  height - value.translation.height
              if (newHeight >= 80) {
                height=newHeight;
              }
            }
            .onEnded{value in if (value.translation.height < -25) {
              withAnimation {
                globalScreenManager.showFullscreenPlayer=true
                height=80
              }
            }}
          )
          .frame(height: height)
          .offset(y:-49)
        }
      }).navigationDestination(isPresented: $globalScreenManager.showFullscreenPlayer ) {
        if audioPlayerViewModel.song != nil {
          PlayerView(song: audioPlayerViewModel.song!, startNew: false)
            .transition(.move(edge: .bottom))
        }
      }
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
        Image(audioPlayerViewModel.song?.imageName ?? "")
          .resizable()
          .aspectRatio(contentMode: .fill)
          .frame(width: size.width, height: size.height)
      }.frame(width: 45, height: 45)
      
        Text(audioPlayerViewModel.song?.name ?? "")
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
