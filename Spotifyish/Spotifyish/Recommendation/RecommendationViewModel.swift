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
  @Published var loaded: Bool = false
  @Published var songsLoading: Bool = false
  @Published var songsLoaded: Bool = false

  init() {
    Task { await getRecommendations() }
  }
  
  func getRecommendationPlaylist(id: MusicItemID) async {
    self.songsLoading = true
    self.showError = false
    self.songsLoaded = false
    
    defer {
      self.songsLoading = false
    }
    do {
      let result = try await fetchRecommendationPlaylistSongs(id: id)
      self.songs = result
      self.songsLoaded = false
    } catch AppleMusicError.networkError(let reason) {
      self.showError = true
      self.errorMessage = reason
      self.songsLoaded = false
    } catch AppleMusicError.unknown(reason: let reason) {
      self.showError = true
      self.errorMessage = reason
      self.songsLoaded = false
    } catch {
      self.showError = true
      self.errorMessage = error.localizedDescription
      self.songsLoaded = false
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
    
      self.playlists = recommendedPlaylists.uniqued(on: \.id)
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
