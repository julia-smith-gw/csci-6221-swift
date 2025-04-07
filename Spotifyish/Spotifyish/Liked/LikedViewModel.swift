//
//  SongsViewModel.swift
//  Spotifyish
//
//  Created by Ngoc Phan on 3/29/25.
//

import CoreData
import Foundation
import MusicKit
import SwiftUI

//https://exploringswift.com/blog/Implementing-Core-Data-in-SwiftUI-using-MVVM-architecture
//https://bugfender.com/blog/ios-core-data/
@MainActor
class LikedViewModel: ObservableObject {
  private let viewContext = PersistenceController.shared.viewContext
  @Published var errorMessage: String? = nil
  @Published var showError: Bool = false
  @Published var songsMetadata: [SavedLikedSong] = []
  @Published var songs: [MusicKit.Song] = []
  @Published var loading: Bool = false
  @Published var loaded: Bool = false
  static let shared = LikedViewModel()

  init() {
    Task {
      await self.fetchLikedSongs()
    }
  }

  func fetchLikedSongsCoreMetadata() throws {
    let request = NSFetchRequest<SavedLikedSong>(entityName: "SavedLikedSong")
    var metadataArr: [SavedLikedSong] = []
    do {
      metadataArr = try viewContext.fetch(request)
      self.songsMetadata = metadataArr
    } catch {
      throw error
    }
  }

  func fetchLikedSongsLibraryData() async throws {
    do {
      var musicIds: [MusicItemID] = []
      let uniqueSongs = self.songsMetadata.uniqued(on: \.id)
      for song in uniqueSongs {
        if song.id != nil {
          musicIds.append(MusicItemID(rawValue: song.id ?? ""))
        }
      }
      let songLibRes = try await fetchSongsFromLibraryByIds(ids: musicIds)
      self.songs = Array(songLibRes).uniqued(on: \.id).filter {
        $0.playParameters != nil
      }
    } catch {
      throw error
    }
  }

  func fetchLikedSongs() async {
    self.loading = true
    self.loaded = false
    self.errorMessage = nil
    self.showError = false
    
    defer{
      self.loading = false
    }
    
    do {
      try fetchLikedSongsCoreMetadata()
      try await fetchLikedSongsLibraryData()
      self.loaded = true
    } catch (let error) {
      self.errorMessage = error.localizedDescription
      self.showError = true
      self.loaded = false
    }
  }

  func addSongToLiked(song: Song, fromLibrary: Bool = false) async {
    let songObj = SavedLikedSong(context: viewContext)
    songObj.id = song.id.rawValue
    songObj.title = song.title
    songObj.artistName = song.artistName
    songObj.fromLibrary = fromLibrary
    saveToContext()
    await self.fetchLikedSongs()
  }

  func removeSongFromLiked(song: Song) async {
    songsMetadata.filter {
      $0.title == song.title && $0.artistName == song.artistName
    }.forEach {
      viewContext.delete($0)
    }
    saveToContext()
    await self.fetchLikedSongs()
  }

  func saveToContext() {
    do {
      try viewContext.save()
    } catch {
      self.errorMessage = error.localizedDescription
      self.showError = true
      self.loaded = false
    }
  }

  func getIsSongLiked(song: Song) -> Bool {
    if songsMetadata.contains(where: {
      $0.title == song.title && $0.artistName == song.artistName
    }) {
      return true
    } else {
      return false
    }
  }
}
