import CoreData
import Foundation
import MusicKit
import SwiftUI

//https://www.youtube.com/watch?v=vqPK8qFsoBg&t=145s
//https://www.reddit.com/r/SwiftUI/comments/s5npb6/how_to_increasedecrease_the_size_of_a_view/
//https://developer.apple.com/documentation/swiftui/view/navigationdestination(for:destination:)
//https://stackoverflow.com/questions/65757784/how-to-best-pass-data-for-form-editing-in-swuiftui-while-having-that-data-avail
//https://www.swiftbysundell.com/articles/swiftui-state-management-guide/
//https://www.reddit.com/r/swift/comments/gb8742/reasoning_behind_observableobjects/
//https://stackoverflow.com/questions/61363361/environmentobject-vs-singleton-in-swiftui
//https://www.hackingwithswift.com/quick-start/swiftui/how-to-present-a-full-screen-modal-view-using-fullscreencover
//https://www.reddit.com/r/SwiftUI/comments/tb5tfd/is_there_anything_like_onload_is_swiftui/
//https://swiftwithmajid.com/2021/11/03/managing-safe-area-in-swiftui/

class GlobalScreenManager: ObservableObject {
  var authorized: Bool = false
  var showFullscreenPlayer: Bool = false
  var showErrorAlert: Bool = false
  var errorMsg: String = ""
  static let shared = GlobalScreenManager()
}

struct ContentView: View {
  @Environment(\.managedObjectContext) private var viewContext
  let persistenceController = PersistenceController.shared
  @FetchRequest(
    sortDescriptors: [
      NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)
    ],
    animation: .default
  )
  private var items: FetchedResults<Item>

  @ObservedObject var audioPlayerViewModel = AudioPlayerViewModel.shared
  @ObservedObject var likedSongsViewModel = LikedViewModel.shared
  @ObservedObject var globalScreenManager = GlobalScreenManager.shared
  @ObservedObject var libraryViewModel: LibraryViewModel = LibraryViewModel
    .shared
  @ObservedObject var browseViewModel: BrowseViewModel = BrowseViewModel()
  @ObservedObject var recommendationViewModel: RecommendationViewModel =
    RecommendationViewModel()

  var body: some View {
    ZStack {
      if !globalScreenManager.authorized {
        ProgressView()
        Text("Fetching authorization...")
      } else if globalScreenManager.showErrorAlert
        && !globalScreenManager.authorized
      {
        Text(
          "Authorization to Apple Music failed. Please exit the app and try again later."
        )
      } else {
        TabView {
          NavigationStack {
            LibraryController()
          }.tabItem {
            Label("Library", systemImage: "books.vertical.fill")
          }

          NavigationStack {
            LikedController()
          }
          .tabItem {
            Label("Liked", systemImage: "heart.fill")
          }

          NavigationStack {
            RecommendationViewController().environmentObject(
              recommendationViewModel
            )
          }
          .tabItem {
            Label("Recommended", systemImage: "house.fill")
          }

          NavigationStack {
            BrowseViewController()
          }.tabItem {
            Label("Browse", systemImage: "magnifyingglass.circle.fill")
          }
          .environmentObject(browseViewModel)

          NavigationStack {
            SettingsViewController()
          }
            .tabItem {
              Label("Settings", systemImage: "gearshape.fill")
            }
        }.fullScreenCover(isPresented: $globalScreenManager.showFullscreenPlayer, content: {
          PlayerView()
        })
        .safeAreaInset(
          edge: .bottom,
          spacing: 0,
          content: {
            if (audioPlayerViewModel.pendingSong != nil
              || audioPlayerViewModel.song != nil)
              && !globalScreenManager.showFullscreenPlayer
            {
              ZStack {
                Rectangle()
                  .fill(.ultraThickMaterial)
                  .overlay {
                    if audioPlayerViewModel.song != nil {
                      MusicInfo()
                    } else {
                      Image(systemName: "music.quarternote.3")
                        .symbolEffect(
                          .variableColor,
                          isActive: true
                        )
                    }
                  }
              }.gesture(
                  TapGesture(count: 2)
                    .onEnded {
                      withAnimation {
                        globalScreenManager.showFullscreenPlayer = true
                      }
                    }
                )
                .frame(maxHeight: 80)
                .offset(y: -49)
            }
          }
        )
      }
    }
    .task {
      do {
        try await authenticateToAppleMusic()
        globalScreenManager.authorized = true
      } catch AppleMusicError.authenticationFailed(let reason) {
        globalScreenManager.showErrorAlert = true
        globalScreenManager.errorMsg = reason
        globalScreenManager.authorized = false
      } catch {
        globalScreenManager.authorized = false
        globalScreenManager.showErrorAlert = true
        globalScreenManager.errorMsg = error.localizedDescription
      }
    }.alert(isPresented: $globalScreenManager.showErrorAlert) {
      Alert(
        title: Text("Error"),
        message: Text(globalScreenManager.errorMsg),
        dismissButton: .default(Text("OK"))
      )
    }
  }
}

// source https://www.youtube.com/watch?v=_KohThDWl5Y
struct MusicInfo: View {
  @ObservedObject var audioPlayerViewModel = AudioPlayerViewModel.shared

  var body: some View {
    ZStack {
      HStack(spacing: 0) {
        if (audioPlayerViewModel.song?.artwork?.url != nil) {
          AsyncImage(
            url: audioPlayerViewModel.song?.artwork?.url(width: 50, height: 50)
          ) { result in
            result.image?
              .resizable()
              .scaledToFill()
          }
          .frame(width: 80, height: 80)
        } else {
          Rectangle()
            .fill(Color.secondary)
            .foregroundStyle(.secondary)
            .frame(width: 80, height: 80)
        }

        Spacer()
        HStack {
          Text(audioPlayerViewModel.song?.title ?? "")
            .fontWeight(.semibold)
            .lineLimit(1)
            .padding(.leading, 15)

          HStack(spacing: 10) {
            AsyncButton(
              systemImageName: "backward.fill",
              action: audioPlayerViewModel.skipBackwards
            )
            .labelStyle(.iconOnly)
            .imageScale(.large)

            AsyncButton(
              systemImageName: audioPlayerViewModel.isPlaying
                ? "pause.fill" : "play.fill",
              action: audioPlayerViewModel.playOrPause
            ).imageScale(.large)

            AsyncButton(
              systemImageName: "forward.fill",
              action: audioPlayerViewModel.skipForwards
            ).labelStyle(.iconOnly)
          }.padding(15)
            .imageScale(.large)
        }.frame(maxWidth: UIScreen.main.bounds.width - 30)
      }.padding(10)
    }
  }
}

#Preview {

  ContentView()
    .environment(
      \.managedObjectContext,
      PersistenceController.preview.container.viewContext
    )
}
