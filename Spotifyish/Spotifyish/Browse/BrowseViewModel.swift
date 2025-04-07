//
//  LibraryViewModel.swift
//  Spotifyish
//
//  Created by Julia  Smith on 4/5/25.
//

import Algorithms
import MusicKit
import SwiftUI
import MusadoraKit

@MainActor
class BrowseViewModel: ObservableObject {
  @Published var errorMessage: String? = nil
  @Published var showError: Bool = false
  @Published var allSongs: [MusicKit.Song] = []
  @Published var searchTerm: String = ""
  @Published var loading: Bool = false
  @Published var hasNextBatch: Bool = false
  @Published var searchActive: Bool = false
  @Published var genreCharts: [GenreChart] = []
  @Published var searchSongs: [MusicKit.Song] = []
  @Published var loaded: Bool = false

  init(){
    Task {await fetchGenres() }
  }
  
  func fetchCatalogSearchResults() async{
    if (self.searchTerm == "") {
      return
    }
    self.loading = true
    self.loaded = false
    self.showError = false
    
    defer {
      self.loading = false
    }
    
    do{
      let result: MusicCatalogSearchResponse = try await searchCatalog(searchTerm: searchTerm)
      self.loaded = true
      self.searchSongs = Array(result.songs)
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
  
  func fetchGenres() async {
    self.loading = true
    self.loaded = false
    self.showError = false
    
    defer {
      self.loading = false
    }
    
    do{
      let result: [GenreChart] = try await fetchGenreCharts()
      self.loaded = true
      self.genreCharts = result
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
