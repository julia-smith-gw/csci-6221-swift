//
//  LoadingView.swift
//  Spotifyish
//
//  Created by Julia  Smith on 4/7/25.
//
import SwiftUI

struct LoadingView: View {
  var loadingText: String = ""
  var body: some View {
    VStack {
      ProgressView()
      Text(loadingText)
    }
  }
}
