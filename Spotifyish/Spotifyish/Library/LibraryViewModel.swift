//
//  LibraryViewModel.swift
//  Spotifyish
//
//  Created by Julia  Smith on 4/5/25.
//

import Algorithms
import MusicKit
import SwiftUI

@MainActor
class LibraryViewModel: ObservableObject {
  @Published var errorMessage: String? = nil
  @Published var showError: Bool = false
  @Published var allSongs: [MusicKit.Song] = []
  @Published var currentlyVisibleSongs: [MusicKit.Song] = []
  @Published var searchTerm: String = ""
  @Published var loading: Bool = false
  @Published var searchActive: Bool = false
  @Published var loaded: Bool = false
  @Published var storedFocusedIndex: Int = 0
  static let shared = LibraryViewModel()

  init() {
    Task { await fetchInitialBatch() }
  }

  func fetchInitialBatch() async {
    self.loading = true
    self.loaded = false
    self.showError = false

    defer {
      self.loading = false
    }

    do {
      let result = try await fetchEntireLibrary()
      self.allSongs = Array(result).uniqued(on: \.id).filter {
        $0.playParameters != nil
      }

      if !self.searchActive {
        self.currentlyVisibleSongs = self.allSongs
      }
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

  func getSongIsInLibrary(song: Song) -> Bool {
    if allSongs.contains(where: {
      $0.title == song.title && $0.artistName == song.artistName
    }) {
      return true
    } else {
      return false
    }
  }

  func addSongToLibrary(song: Song) async {
    do {
      try await postSongToLibrary(song: song)
      await fetchInitialBatch()
    } catch AppleMusicError.networkError(let reason) {
      self.errorMessage = reason
      self.showError = true
    } catch AppleMusicError.unknown(reason: let reason) {
      self.errorMessage = reason
      self.showError = true
    } catch {
      self.errorMessage = error.localizedDescription
      self.showError = true
    }
  }

  func searchLibrary() async {
    self.loading = true
    self.loaded = false
    self.showError = false

    defer {
      self.loading = false
    }

    do {
      var result: MusicLibrarySearchResponse
      if self.searchTerm == "" {
        currentlyVisibleSongs = allSongs
        self.searchActive = false
      } else {
        result = try await fetchLibrarySearchResult(searchTerm: self.searchTerm)
        self.currentlyVisibleSongs = Array(result.songs).uniqued(on: \.id)
          .filter {
            $0.playParameters != nil
          }
      }
      self.loaded = true
    } catch AppleMusicError.networkError(let reason) {
      self.errorMessage = reason
      self.loaded = false
      self.loading = false
      self.showError = true
    } catch AppleMusicError.unknown(reason: let reason) {
      self.errorMessage = reason
      self.loaded = false
      self.loading = false
      self.showError = true
    } catch {
      self.errorMessage = error.localizedDescription
      self.loaded = false
      self.loading = false
      self.showError = true
    }
  }
}
