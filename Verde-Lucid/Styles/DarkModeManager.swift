//
//  DarkModeManager.swift
//  Verde-Lucid
//
//  Created by Siddarth Reddy on 24/11/23.
//

import SwiftUI

struct DarkModeManager {
    static var isDarkMode: Bool {
        guard let window = UIApplication.shared.windows.first else {
            return false // Defaulting to false if unable to retrieve the window
        }
        return window.rootViewController?.traitCollection.userInterfaceStyle == .dark
    }
}
