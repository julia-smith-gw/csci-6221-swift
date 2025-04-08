//
//  Library.swift
//  Spotifyish
//
//  Created by Julia  Smith on 4/7/25.
//

import MusicKit
import MusadoraKit

func fetchSongsFromLibraryByIds(ids: [MusicItemID]) async throws -> MusicItemCollection<Song>  {
  do {
    let response = try await MLibrary.songs(ids: ids)
    return response
  } catch {
    throw AppleMusicError.unknown(reason: error.localizedDescription)
  }
}

func postSongToLibrary(song: MusicKit.Song) async throws {
  do {
    try await MusicLibrary.shared.add(song)
  } catch {
    throw AppleMusicError.unknown(reason: error.localizedDescription)
  }
}

func fetchLibrarySearchResult(searchTerm: String?) async throws -> MusicLibrarySearchResponse
{
  do {
    let request = MusicLibrarySearchRequest(term: searchTerm ?? "", types: [Song.self])
    let response = try await request.response()
    return response
  } catch {
    throw AppleMusicError.unknown(reason: error.localizedDescription)
  }
}

func fetchEntireLibrary() async throws -> MusicItemCollection<MusicKit.Song> {
  do {
    let result = try await MLibrary.songs(limit: 20000)
    return result
  } catch {
    throw AppleMusicError.unknown(reason: error.localizedDescription)
  }
}
