//
//  RecommendationViewModel.swift
//  Spotifyish
//
//  Created by Julia  Smith on 4/7/25.
//

import Algorithms
import MusicKit
import SwiftUI

@MainActor
class RecommendationViewModel: ObservableObject {
  @Published var errorMessage: String? = nil
  @Published var showError: Bool = false
  @Published var songs: [MusicKit.Song] = []
  @Published var playlists: [MusicKit.Playlist] = []
  @Published var loading: Bool = false
  @Published var searchActive: Bool = false
  @Published var loaded: Bool = false

  init() {
    Task { await getRecommendations() }
  }
  
  func getRecommendationPlaylist(id: MusicItemID) async {
    self.loading = true
    self.loaded = false
    self.showError = false
    defer {
      self.loading = false
    }
    do {
      let result = try await fetchRecommendationPlaylistSongs(id: id)
      self.songs = result
      self.loaded = true
    } catch AppleMusicError.networkError(let reason) {
      print("rec error \(reason)")
      self.showError = true
      self.errorMessage = reason
      self.loaded = false
    } catch AppleMusicError.unknown(reason: let reason) {
      print("rec error \(reason)")
      self.showError = true
      self.errorMessage = reason
      self.loaded = false
    } catch {
      print("rec error \(error.localizedDescription)")
      self.showError = true
      self.errorMessage = error.localizedDescription
      self.loaded = false
    }
  }

  func getRecommendations() async {
    self.loading = true
    self.loaded = false
    self.showError = false

    defer {
      self.loading = false
    }

    do {
      let result = try await fetchRecommendations()
      var recommendedPlaylists: [MusicKit.Playlist] = []
      for rec in result.recommendations {
          recommendedPlaylists+=rec.playlists
      }
      
      print("RECOMMENDED PLAYLIST")
      print(recommendedPlaylists)
      self.playlists = recommendedPlaylists
      self.loaded = true
    } catch AppleMusicError.networkError(let reason) {
      print("rec error \(reason)")
      self.showError = true
      self.errorMessage = reason
      self.loaded = false
    } catch AppleMusicError.unknown(reason: let reason) {
      print("rec error \(reason)")
      self.showError = true
      self.errorMessage = reason
      self.loaded = false
    } catch {
      print("rec error \(error.localizedDescription)")
      self.showError = true
      self.errorMessage = error.localizedDescription
      self.loaded = false
    }
  }
}
