//
//  Models.swift
//  Spotifyish
//
//  Created by Julia  Smith on 4/6/25.
//
import Foundation
import MusicKit


struct GenreChart: Hashable {
  static func == (lhs: GenreChart, rhs: GenreChart) -> Bool {
    return lhs.id == rhs.id
  }
  var id: UUID = UUID()
  var genre: Genre? = nil
  var chart: MusicCatalogChartsResponse? = nil
  var songs: [Song] = []
  init(genre: Genre? = nil, chart: MusicCatalogChartsResponse? = nil, songs: [Song] = []) {
    self.genre = genre
    self.chart = chart
    self.songs = songs
  }
}

struct PlaylistInfo: Hashable {
  static func == (lhs: PlaylistInfo, rhs: PlaylistInfo) -> Bool {
    return lhs.playlist?.id == rhs.playlist?.id
  }
  var id: UUID = UUID()
  var playlist: Playlist? = nil
  var songs: MusicItemCollection<Song>? = nil
  init(playlist: Playlist?, songs: MusicItemCollection<Song>) {
    self.playlist = playlist
    self.songs = songs
  }
}
