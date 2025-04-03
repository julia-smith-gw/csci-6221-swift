//
//  SongListViewModel.swift
//  Spotifyish
//
//  Created by Julia  Smith on 4/1/25.
//
import SwiftUI
import MusicKit
import Algorithms

class SongListViewModel : ObservableObject  {
  @EnvironmentObject var globalScreenManager: GlobalScreenManager
  @Published var error: String? = nil
  @Published var songs: [MusicKit.Song] = []
  @Published var loading: Bool = false
  @Published var loaded: Bool = false
  @Published var nextBatchLoading: Bool=false
  @Published var hasNextBatch: Bool=false
  @Published var currentOffset: Int = 0
  var dataSourceCall: (MusicLibraryRequest<MusicKit.Song>) async throws -> MusicLibraryResponse<MusicKit.Song>
  
  init(newDataSourceFunction: @escaping (MusicLibraryRequest<MusicKit.Song>) async throws -> MusicLibraryResponse<MusicKit.Song>) {
    dataSourceCall = newDataSourceFunction
  }
  
  func fetch(_ args: Any...) async throws -> MusicItemCollection<MusicKit.Song> {
    do {
      let call : MusicLibraryRequest<MusicKit.Song> = MusicLibraryRequest<MusicKit.Song>()
      if (currentOffset > 0 ) {
        nextBatchLoading=true
      }
      loading = true
//      call.limit = 100
//      call.offset=currentOffset
      let result: MusicLibraryResponse<MusicKit.Song> = try await dataSourceCall(call)
      songs += result.items.uniqued(on: \.id)
//      currentOffset+=100
      nextBatchLoading=false
      hasNextBatch = result.items.hasNextBatch
      loading=false
      loaded=true
     // print(result.items)
      return result.items;
    }
  }
}
