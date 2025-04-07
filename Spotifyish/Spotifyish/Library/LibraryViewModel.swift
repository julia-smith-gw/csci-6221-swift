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
  static let shared = LibraryViewModel()

  init(){
    Task {await fetchInitialBatch() }
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
      
      DispatchQueue.main.async {
        self.allSongs = Array(result).uniqued(on: \.id).filter {
          $0.playParameters != nil
        }
      }
      
      if (!self.searchActive) {
        DispatchQueue.main.async {
          self.currentlyVisibleSongs=self.allSongs
        }
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
      // found
    } else {
      return false
    }
  }
  
  func addSongToLibrary(song: Song) async {
    do {
      try await postSongToLibrary(song: song)
      await fetchInitialBatch()
      let afterFilter = self.allSongs.filter {
        song.title == $0.title && song.artistName == $0.artistName
      }
    } catch AppleMusicError.networkError(let reason) {
      print("failed song to library \(reason)")
      self.errorMessage = reason
      self.showError = true
    } catch AppleMusicError.unknown(reason: let reason) {
      print("failed song to library \(reason)")
      self.errorMessage = reason
      self.showError = true
    } catch {
      print("failed song to library \(error.localizedDescription)")
      self.errorMessage = error.localizedDescription
      self.showError = true
    }

  }

  func searchLibrary() async {
    self.loading = true
    self.loaded = false
    self.showError = false
    do {
      var result: MusicLibrarySearchResponse
      if self.searchTerm == "" {
        currentlyVisibleSongs = allSongs
        self.searchActive = false
      } else {
        result = try await fetchLibrarySearchResult(searchTerm: self.searchTerm)
        self.currentlyVisibleSongs = Array(result.songs).uniqued(on: \.id).filter {
          $0.playParameters != nil
        }
      }
      self.loading = false
      self.loaded = true
    } catch AppleMusicError.networkError(let reason) {
      print("bad")
      print(reason)
      self.errorMessage = reason
      self.loaded = false
      self.loading = false
      self.showError = true
    } catch AppleMusicError.unknown(reason: let reason) {
      print("bad")
      print(reason)
      self.errorMessage = reason
      self.loaded = false
      self.loading = false
      self.showError = true
    } catch {
      print("bad")
      print(error.localizedDescription)
      self.errorMessage = error.localizedDescription
      self.loaded = false
      self.loading = false
      self.showError = true
    }
  }
}
