//
//  ErrorView.swift
//  Spotifyish
//
//  Created by Julia  Smith on 3/30/25.
//

//https://holyswift.app/best-way-to-present-error-in-swiftui/

import SwiftUI

public struct ErrorView: View {
  @State var repeatTask: () async -> Void
  @State var errorMsg: String
  
  public var body: some View {
    RoundedRectangle(cornerRadius: 20)
      .foregroundColor(.red)
      .overlay {
        VStack {
          Text(errorMsg)
          Button("Try again") {
            Task  {
              await repeatTask()
            }
          }.buttonStyle(.borderedProminent)
        }
      }
  }
}
