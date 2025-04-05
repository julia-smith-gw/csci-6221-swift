//WelcomePageController.swift
import UIKit
import SwiftUI

/// The main controller that displays the welcome screen with branding and login/signup options.
class WelcomePageController: UIViewController {
    /// A button users tap to begin sign in or sign up flow.
    private let signInButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .white
        button.setTitle("Sign In", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        return button
        
    }()
    /// Title label displaying the app name.
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Spotifyish"
        label.font = UIFont.systemFont(ofSize: 36, weight: .semibold)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    /// ImageView that displays the Spotify logo in the center of the screen.
    private let logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "spotify_logo")
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        return imageView
    }()

    /// Called when the view loads into memory. Sets up UI and retrieves saved users.
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Spotifyish"
        view.backgroundColor = .systemGreen
        view.addSubview(signInButton)
        view.addSubview(titleLabel)
        view.addSubview(logoImageView)
        signInButton.addTarget(self, action: #selector(didTapSignIn), for: .touchUpInside)

        
        if let users = UserDefaults.standard.dictionary(forKey: "users") as? [String: String] {
            print("Saved users: \(users)")
            
            for family in UIFont.familyNames.sorted() {
                for name in UIFont.fontNames(forFamilyName: family) {
                    print("    ↪︎ \(name)")
                }
            }

        }
    }
    /// Lays out subviews (title, logo, sign-in button) with fixed frames.
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        titleLabel.frame = CGRect(x: 20, y: 120, width: view.bounds.width - 40, height: 50)
        logoImageView.frame = CGRect(x: (view.bounds.width - 150)/2, y: 200, width: 150, height: 150)
        signInButton.frame = CGRect(x: 20, y: view.bounds.height - 50 - view.safeAreaInsets.bottom, width: view.bounds.width - 40, height: 50)
    }
 
    /// Handles tap on the sign-in button and presents options to log in or sign up.
    @objc func didTapSignIn() {
        let choiceAlert = UIAlertController(title: "Welcome", message: "Choose an option", preferredStyle: .alert)

        choiceAlert.addAction(UIAlertAction(title: "Log In", style: .default) { [weak self] _ in
            self?.promptForCredentials(mode: "login")
        })

        choiceAlert.addAction(UIAlertAction(title: "Sign Up", style: .default) { [weak self] _ in
            self?.promptForCredentials(mode: "signup")
        })

        choiceAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        present(choiceAlert, animated: true)
    }
    /// Prompts the user for username and password for either login or signup.
        /// - Parameter mode: Either `"login"` or `"signup"`.
    func promptForCredentials(mode: String) {
        let alert = UIAlertController(
            title: mode == "login" ? "Log In" : "Sign Up",
            message: "Enter your username and password",
            preferredStyle: .alert
        )

        alert.addTextField { textField in
            textField.placeholder = "Username"
        }
        alert.addTextField { textField in
            textField.placeholder = "Password"
            textField.isSecureTextEntry = true
        }

        let action = UIAlertAction(title: mode.capitalized, style: .default) { [weak self] _ in
            guard let fields = alert.textFields,
                  let username = fields[0].text, !username.isEmpty,
                  let password = fields[1].text, !password.isEmpty else {
                return
            }

            var users = UserDefaults.standard.dictionary(forKey: "users") as? [String: String] ?? [:]

            if mode == "signup" {
                if users[username] != nil {
                    self?.showError(title: "Username Taken", message: "Please choose another username.")
                } else {
                    users[username] = password
                    UserDefaults.standard.set(users, forKey: "users")
                    UserDefaults.standard.set(username, forKey: "signedInUsername")
                    self?.navigateToMainApp()
                }
            } else if mode == "login" {
                if let savedPassword = users[username], savedPassword == password {
                    UserDefaults.standard.set(username, forKey: "signedInUsername")
                    self?.navigateToMainApp()
                } else {
                    self?.showError(title: "Login Failed", message: "Invalid username or password.")
                }
            }
        }

        alert.addAction(action)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alert, animated: true)
    }
    /// Shows a pop-up alert with an error message.
        /// - Parameters:
        ///   - title: Title of the error alert.
        ///   - message: Message body of the alert.
    func showError(title: String, message: String) {
        let errorAlert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        errorAlert.addAction(UIAlertAction(title: "OK", style: .default))
        present(errorAlert, animated: true)
    }
    /// Navigates the user to the main SwiftUI content view after successful login/signup.
    private func navigateToMainApp() {
        let mainVC = UIHostingController(rootView: ContentView())
        mainVC.modalPresentationStyle = .fullScreen
        present(mainVC, animated: true)
    }
}
