import MusicKit
import SwiftUI
//https://stackoverflow.com/questions/72339425/how-to-filter-an-array-of-objects-with-unique-properties
//https://developer.apple.com/documentation/swift/array/first(where:)
enum AppleMusicError: Error {
  case authenticationFailed(reason: String)
  case networkError(reason:String)
  case unknown(reason: String)
}

func authenticateToAppleMusic() async throws {
  Task {
    do {
      let authsStatus = await MusicAuthorization.request()
      if authsStatus == .authorized {
        print("Access granted!")
        return true
      } else {
        throw AppleMusicError.authenticationFailed(reason: "User cannot be authenticated to Apple Music.")
      }
    } catch let urlError as URLError{
      throw AppleMusicError.networkError(reason: "Network Error: \(urlError.localizedDescription) (Code: \(urlError.code))")
    }
  }
}

func fetchLibrary(musicLibraryRequest: MusicLibraryRequest<MusicKit.Song> = MusicLibraryRequest<MusicKit.Song>()) async throws -> MusicLibraryResponse<MusicKit.Song>{
    do {
      let result = try await musicLibraryRequest.response()
      print("song")
      print(result.items)
      return result
    } catch let urlError as URLError{
      throw AppleMusicError.networkError(reason: "Network Error: \(urlError.localizedDescription) (Code: \(urlError.code))")
    } catch  {
      throw AppleMusicError.unknown(reason: error.localizedDescription)
    }
}

func fetchSongStreamingInfo(song: MusicKit.Song) async throws  -> MusicItemCollection<MusicKit.Song>.Element{
  do {
    let result = try await MusicCatalogSearchRequest.init(term: song.title, types: [MusicKit.Song.self]).response()
    guard let firstSong = result.songs.first (where:{
      $0.title == song.title &&
      $0.artistName == song.artistName
    }) else {
      throw AppleMusicError.networkError(reason: "Song not found for the provided information.")
    }
    return firstSong
  } catch let urlError as URLError{
    throw AppleMusicError.networkError(reason: "Network Error: \(urlError.localizedDescription) (Code: \(urlError.code))")
  } catch  {
    throw AppleMusicError.unknown(reason: error.localizedDescription)
  }
  
}

