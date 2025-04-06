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

func fetchLibrarySearchResult(searchTerm: String?) async throws
  -> MusicItemCollection<MusicKit.Song>
{
  do {
    let result = try await MLibrary.search(
      for: searchTerm ?? "",
      types: [MLibrarySearchableType.songs]
    )
    return result.songs
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
    let result = try await MLibrary.songs()
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

struct GenreChart: Hashable {
  static func == (lhs: GenreChart, rhs: GenreChart) -> Bool {
    return lhs.id == rhs.id
  }
  var id: UUID = UUID()
  var genre: Genre? = nil
  var chart: MusicCatalogChartsResponse? = nil
  init(genre: Genre? = nil, chart: MusicCatalogChartsResponse? = nil) {
    self.genre = genre
    self.chart = chart
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
      let genreChartObj = GenreChart(genre: genre, chart: genreChart)
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
    #if DEBUG
      print("Error fetching playlists: \(error.localizedDescription)")
    #endif
    throw AppleMusicError.unknown(reason: error.localizedDescription)
  }
}

func fetchLikedPlaylist() async throws -> MusicItemCollection<Song> {
  do {
    let result = try await MLibrary.playlists()
    guard
      let favoritePlaylist = result.first(where: {
        $0.name == "Favorite Songs"
      })
    else {
      throw AppleMusicError.unknown(reason: "Favorite playlist not found")
    }

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
    let decodedData = try JSONDecoder().decode(MusicItemCollection<Song>.self, from: fullPlaylistResponse.data)
    print(try JSONDecoder().decode(MusicItemCollection<Song>.self, from: fullPlaylistResponse.data))
    return decodedData

  } catch {
    throw error
  }
}

//func fetchLikedPlaylist() async throws -> MusicItemCollection<Playlist>.Element{
//  do {
//    let result = try await MLibrary.playlists()
//    guard let favoritePlaylist = result.first(where: {$0.name == "amvs in my head"}) else {
//      throw AppleMusicError.unknown(reason: "Favorite playlist not found")
//    }
//    let playlist = try await MLibrary.playlist(id: favoritePlaylist.id)
//    for song in playlist.tracks ?? [] {
//      print("Song: \(song.title)")
//    }
//    return playlist
//  } catch let urlError as URLError {
//    throw AppleMusicError.networkError(
//      reason:
//        "Network Error: \(urlError.localizedDescription) (Code: \(urlError.code))"
//    )
//  } catch {
//    throw AppleMusicError.unknown(reason: error.localizedDescription)
//  }
//}

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
