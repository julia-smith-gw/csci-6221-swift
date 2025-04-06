//
//  LikedViewModel.swift
//  Spotifyish
//
//  Created by Julia  Smith on 4/5/25.
//

import Algorithms
import MusicKit
import SwiftUI

class LikedViewModel: ObservableObject {
  @EnvironmentObject var globalScreenManager: GlobalScreenManager
  @Published var errorMessage: String? = nil
  @Published var showError: Bool = false
  @Published var likedPlaylistInfo: MusicItemCollection<MusicKit.Playlist>.Element?
  @Published var songs: MusicItemCollection<MusicKit.Song>?
  @Published var currentlyVisibleSongs: [MusicKit.Song] = []
  @Published var searchTerm: String = ""
  @Published var loading: Bool = false
  @Published var hasNextBatch: Bool = false
  @Published var searchActive: Bool = false
  private var nextBatch: MusicItemCollection<MusicKit.Song>?
  @Published var loaded: Bool = false

  init() {
    Task {
      await getLikedPlaylist()
    }
  }

  func getLikedPlaylist() async {
    self.loading = true
    self.loaded = false
    self.showError = false

    defer {
      self.loading = false
    }

    do {
      let result = try await fetchLikedPlaylist()
//      self.likedPlaylistInfo = result
      print("wtf is in this ")
      print(result)
      self.songs = result

//      var playlistSongs: [MusicKit.Song] = []
//      for playlist in result.items {
//        print("in the playlist loop")
//        print(playlist.tracks ?? "no tracks")
//        print(playlist.entries)
//        print(playlist.description)
//        for playlistEntry in playlist.tracks ?? [] {
//          switch playlistEntry {
//          case .song(let song):
//            print("is a song")
//            playlistSongs.append(song)
//          default:
//            continue
//          }
//        }
//      }

//      self.songs=playlistSongs
//      print("playlist result    \(playlistSongs)")
//      print(playlistSongs)
      self.loaded = true
    } catch AppleMusicError.networkError(let reason) {
      self.showError = true
      self.errorMessage = reason
      self.loaded = false
    } catch AppleMusicError.unknown(reason: let reason) {
      self.showError = true
      self.errorMessage = reason
      self.loaded = false
    } catch {
      self.showError = true
      self.errorMessage = error.localizedDescription
      self.loaded = false
    }
  }
}
