//
//  AsyncImageStretchyHeader.swift
//  Spotifyish
//
//  Created by Sumairah Rahman on 07/04/25.
//

import SwiftUI

import SwiftUI

struct AsyncImageStretchyHeader: View {
    var imageName: String

    var body: some View {
        GeometryReader { geo in
            Image(imageName)
                .resizable()
                .scaledToFill()
                .frame(
                    width: geo.size.width,
                    height: geo.frame(in: .global).minY > 0
                        ? geo.size.height + geo.frame(in: .global).minY
                        : geo.size.height
                )
                .clipped()
                .offset(y: geo.frame(in: .global).minY > 0 ? -geo.frame(in: .global).minY : 0)
        }
    }
}

