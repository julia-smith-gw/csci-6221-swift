//
//  WelcomeWrapper.swift
//  Spotifyish
//
//  Created by Nina on 3/29/25.
//

import Foundation
import SwiftUI

/// A SwiftUI-compatible wrapper for `WelcomePageController`,
/// allowing it to be used as a view in SwiftUI code.
///
/// This is used to display the UIKit-based welcome screen
/// (with branding, login, and signup) inside a SwiftUI app.
struct WelcomeViewControllerWrapper: UIViewControllerRepresentable {
    /// Creates and returns the UIKit welcome screen controller.
        /// - Parameter context: Contextual information for creating the view controller.
        /// - Returns: An instance of `WelcomePageController`.
    func makeUIViewController(context: Context) -> UIViewController {
        return WelcomePageController()
    }

    /// Updates the UIKit view controller. Not used in this case since the screen is static.
        /// - Parameters:
        ///   - uiViewController: The current `WelcomePageController` instance.
        ///   - context: Contextual information for the update.
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        // No updates needed for now
    }
}
