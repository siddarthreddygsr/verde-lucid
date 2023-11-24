//
//  DarkModeManager.swift
//  Verde-Lucid
//
//  Created by Siddarth Reddy on 24/11/23.
//

import SwiftUI

struct DarkModeManager {
    static var isDarkMode: Bool {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            return windowScene.windows.first(where: { $0.isKeyWindow })?.traitCollection.userInterfaceStyle == .dark
        }
        return false // Defaulting to false if unable to retrieve the window scene
    }
}
