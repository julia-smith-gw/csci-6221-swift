//
//  SearchBar.swift
//  Spotifyish
//
//  Created by Julia  Smith on 4/5/25.
//

//https://stackoverflow.com/questions/76832159/searchable-make-the-search-box-stick-to-the-top-without-moving-when-focused
//https://developer.apple.com/forums/thread/738726
//https://www.hackingwithswift.com/forums/100-days-of-swift/adding-a-clear-button-to-a-textfield/12079
//https://stackoverflow.com/questions/71744888/view-with-rounded-corners-and-border

import SwiftUI

struct TextFieldClearButton: ViewModifier {
    @Binding var fieldText: String

    func body(content: Content) -> some View {
        content
            .overlay {
                if !fieldText.isEmpty {
                    HStack {
                        Spacer()
                        Button {
                            fieldText = ""
                        } label: {
                            Image(systemName: "multiply.circle.fill")
                        }
                        .foregroundColor(.secondary)
                        .padding(.trailing, 4)
                    }
                }
            }
    }
}

extension View {
    func showClearButton(_ text: Binding<String>) -> some View {
        self.modifier(TextFieldClearButton(fieldText: text))
    }
}

struct CustomSearchBar: View {
  @Binding var searchText: String
  var submitAction: () async -> () = {}
  @Binding var searchActive: Bool 
  @State var active = false

  @State var text = "foo"
  var body: some View {
    HStack {
      HStack {
        Image(systemName: "magnifyingglass").foregroundColor(.gray)
        TextField(
          "Search",
          text: $searchText,
          onEditingChanged: { editing in
            withAnimation {
              active = editing
            }
          }
        )
        
        // Clear data if search is active and cancel button is hit
        .onChange(of: searchText) { oldValue, newValue in
          if (newValue == "" && searchActive) {
            Task {
              await submitAction()
              searchActive = false
            }
          }
        }
        .onSubmit {
          if (searchText != "") {
            searchActive = true
          } else {
            searchActive = false
          }
          Task { await submitAction() }
        }
        .showClearButton($searchText)
      }
      .padding(10)
      .cornerRadius(20)
      .overlay( /// apply a rounded border
          RoundedRectangle(cornerRadius: 20)
              .stroke(.separator, lineWidth: 1)
      )
      .padding(.horizontal, active ? 0 : 50)

      Button("Cancel") {
        withAnimation {
          active = false
        }
      }
      .opacity(active ? 1 : 0)
      .frame(width: active ? nil : 0)
    }
  }
}
