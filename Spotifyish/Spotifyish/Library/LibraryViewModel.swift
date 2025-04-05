//
//  LibraryViewModel.swift
//  Spotifyish
//
//  Created by Julia  Smith on 4/5/25.
//

import Algorithms
import MusicKit
import SwiftUI

class LibraryViewModel: ObservableObject {
  @EnvironmentObject var globalScreenManager: GlobalScreenManager
  @Published var errorMessage: String? = nil
  @Published var showError: Bool = false
  @Published var allSongs: [MusicKit.Song] = []
  @Published var currentlyVisibleSongs: [MusicKit.Song] = []
  @Published var searchTerm: String = ""
  @Published var loading: Bool = false
  @Published var hasNextBatch: Bool = false
  @Published var searchActive: Bool = false
  private var nextBatch: MusicItemCollection<MusicKit.Song>?
  @Published var loaded: Bool = false

  init(){
    Task {await fetchInitialBatch() }
  }
  
  func loadMoreItemsIfNeeded(currentIndex: Int ) async {
    // Check if the item is near the end of the list
    if (allSongs.endIndex == currentIndex + 1) {
      await fetchNextBatch()
    }
  }

  
  func fetchNextBatch() async {
    if (!self.hasNextBatch || self.nextBatch == nil){
      return
    }
    
    self.loading = true
    
    defer {
      self.loading = false
    }
    
    do {
      let result = try await self.nextBatch?.nextBatch(limit:50)
      self.hasNextBatch = result?.hasNextBatch ?? false
      self.nextBatch = result
      self.allSongs+=Array(result ?? []).uniqued(on: \.id).filter {
        $0.playParameters != nil
      }
      self.currentlyVisibleSongs=self.allSongs
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

  func fetchInitialBatch() async {
    self.loading = true
    self.loaded = false
    self.showError = false

    defer {
      self.loading = false
    }

    do {
      let result = try await fetchEntireLibrary()
      self.hasNextBatch = result.hasNextBatch
      self.nextBatch = result
      self.allSongs = Array(result).uniqued(on: \.id).filter {
        $0.playParameters != nil
      }
      self.currentlyVisibleSongs=self.allSongs
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

  func searchLibrary() async {
    self.loading = true
    self.loaded = false
    self.showError = false
    do {
      var result: MusicItemCollection<Song>
      if self.searchTerm == "" {
        currentlyVisibleSongs = allSongs
      } else {
        result = try await fetchLibrarySearchResult(searchTerm: self.searchTerm)
        self.currentlyVisibleSongs = Array(result).uniqued(on: \.id).filter {
          $0.playParameters != nil
        }
      }
      self.loading = false
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
