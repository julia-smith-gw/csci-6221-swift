import MusadoraKit
import MusicKit
import SwiftUI

//https://stackoverflow.com/questions/72339425/how-to-filter-an-array-of-objects-with-unique-properties
//https://developer.apple.com/documentation/swift/array/first(where:)
enum AppleMusicError: Error {
  case authenticationFailed(reason: String)
  case networkError(reason: String)
  case unknown(reason: String)
}

func authenticateToAppleMusic() async throws {
  Task {
    do {
      let authsStatus = await MusicAuthorization.request()
      if authsStatus == .authorized {
        return true
      } else {
        throw AppleMusicError.authenticationFailed(
          reason: "User cannot be authenticated to Apple Music."
        )
      }
    } catch let urlError as URLError {
      throw AppleMusicError.networkError(
        reason:
          "Network Error: \(urlError.localizedDescription) (Code: \(urlError.code))"
      )
    }
  }
}

func fetchSongsFromLibraryByIds(ids: [MusicItemID]) async throws -> MusicItemCollection<Song>  {
  do {
    let response = try await MLibrary.songs(ids: ids)
    return response
  } catch {
    print("fetch liked library song error")
    throw AppleMusicError.unknown(reason: error.localizedDescription)
  }
}

func postSongToLibrary(song: MusicKit.Song) async throws {
  do {
    try await MusicLibrary.shared.add(song)
  } catch {
    print("add error")
    print(error)
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

func searchCatalog(searchTerm: String) async throws
  -> MusicCatalogSearchResponse
{
  do {
    let result = try await MCatalog.search(
      for: searchTerm,
      types: [.songs],
      limit: 20
    )
    return result
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

func fetchTopGenres() async throws -> MusicItemCollection<Genre> {
  do {
    let result = try await MCatalog.topGenres()
    return result
  } catch {
    throw AppleMusicError.unknown(reason: error.localizedDescription)
  }
}


func fetchGenreCharts() async throws -> [GenreChart] {
  do {
    let topGenres = try await fetchTopGenres()
    var genreCharts: [GenreChart] = []
    for genre in topGenres {
      let genreChart = try await MCatalog.charts(
        genre: genre,
        kinds: .dailyGlobalTop,
        types: .songs,
        limit: 15
      )
      let genreChartObj = GenreChart(genre: genre, chart: genreChart, songs: genreChart.songCharts.flatMap(\.items))
      genreCharts.append(genreChartObj)
    }
    return genreCharts
  } catch {
    throw AppleMusicError.unknown(reason: error.localizedDescription)
  }
}

func fetchAllPlauylists() async throws -> MusicItemCollection<MLibraryPlaylist>
{
  do {
    let result = try await MLibrary.playlists(limit: 100)
    return result
  } catch let urlError as URLError {
    throw AppleMusicError.networkError(
      reason:
        "Network Error: \(urlError.localizedDescription) (Code: \(urlError.code))"
    )
  } catch {
    throw AppleMusicError.unknown(reason: error.localizedDescription)
  }
}

func fetchPlaylistMetadataMusicKit(playlistName: String) async throws -> Playlist{
  do {
    let request = MusicLibrarySearchRequest(term: playlistName, types: [Playlist.self])
    let response = try await request.response()
    
    guard let favoritePlaylist = response.playlists.first else {
      throw AppleMusicError.unknown(reason: "Favorite playlist not found")
    }
    return favoritePlaylist
  } catch {
    print("PLATY LIST GET ERROR")
    print(error)
    throw error
  }
}

func fetchPlaylistMetadata(playlistName: String) async throws -> Playlist {
  do {
    let request = MusicLibrarySearchRequest(term: "Favorite Songs", types: [Playlist.self])
    let response = try await request.response()
    print("response", response)
    guard let favoritePlaylist = response.playlists.first(where: {
        $0.name == "Favorite Songs"
      }) else {
        throw AppleMusicError.unknown(reason: "Favorite playlist not found")
      }
    return favoritePlaylist
  } catch {
    print("PLATY LIST GET ERROR")
    print(error)
    throw error
  }
}

func fetchLikedPlaylist() async throws -> PlaylistInfo {
  do {
    let favoritePlaylist = try await fetchPlaylistMetadataMusicKit(playlistName: "amvs in my head")

    guard let url = URL(string: "https://api.music.apple.com/v1/me/library/playlists/\(favoritePlaylist.id)/tracks")
    else {
      throw
        AppleMusicError.unknown(reason: "Invalid URL")
    }
    
    let fullPlaylistReq = MusicDataRequest(
      urlRequest: URLRequest(
        url: url
      )
    )
    let fullPlaylistResponse = try await fullPlaylistReq.response()
    let decodedSongs = try JSONDecoder().decode(MusicItemCollection<Song>.self, from: fullPlaylistResponse.data)
    let decodedPlaylist = try JSONDecoder().decode(MusicItemCollection<Playlist>.self, from: fullPlaylistResponse.data)
    return PlaylistInfo(playlist: favoritePlaylist, songs: decodedSongs)
  } catch {
    throw error
  }
}

func addSongToPlaylist(songs: MusicItemCollection<Song>, playlist: Playlist) async throws -> Playlist {
  do {
    
    let updatedPlaylist = try await MusicLibrary.shared.add(songs.first!, to: playlist)
    return updatedPlaylist
    print("WHAT IS IN THIS ACTUALLY")
    print(updatedPlaylist)

  } catch {
      print("Error adding songs to playlist: \(error)")
      throw error
  }
}

func fetchSongStreamingInfo(song: MusicKit.Song) async throws
  -> MusicItemCollection<MusicKit.Song>.Element
{
  do {
    let result = try await MCatalog.song(id: song.id)
    return result
  } catch let urlError as URLError {
    throw AppleMusicError.networkError(
      reason:
        "Network Error: \(urlError.localizedDescription) (Code: \(urlError.code))"
    )
  } catch {
    throw AppleMusicError.unknown(reason: error.localizedDescription)
  }

}
