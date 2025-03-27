//
//  ContentView.swift
//  Spotifyish
//
//  Created by Julia  Smith on 3/25/25.
//

import CoreData
import SwiftUI

struct ContentView: View {
  @Environment(\.managedObjectContext) private var viewContext

  @FetchRequest(
    sortDescriptors: [
      NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)
    ],
    animation: .default)
  private var items: FetchedResults<Item>

  var body: some View {
    TabView {
      HomeController()
        .tabItem {
          Label("Home", systemImage: "house.fill")
        }

      LibraryController()
        .tabItem {
          Label("Library", systemImage: "books.vertical.fill")
        }
      
      LikedController().tabItem{
        Label("Liked", systemImage: "heart.fill")
      }
      RecommendedViewController().tabItem{Label("Search", systemImage: "magnifyingglass.circle.fill")}
    }

  }

}

#Preview {
  ContentView().environment(
    \.managedObjectContext, PersistenceController.preview.container.viewContext)
}
