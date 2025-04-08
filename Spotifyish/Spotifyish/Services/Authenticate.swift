//
//  Authenticate.swift
//  Spotifyish
//
//  Created by Julia  Smith on 4/7/25.
//

import MusadoraKit
import MusicKit
import SwiftUI

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
