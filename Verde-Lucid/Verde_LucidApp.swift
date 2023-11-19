//
//  Verde_LucidApp.swift
//  Verde-Lucid
//
//  Created by Siddarth Reddy on 15/11/23.
//

import SwiftUI
import Amplify
import AWSCognitoAuthPlugin
import AWSS3StoragePlugin

@main
struct Verde_LucidApp: App {
    
//    init() {
//            configureAmplify()
//        }
//        
//    private func configureAmplify() {
//        do {
//            try Amplify.add(plugin: AWSCognitoAuthPlugin())
//            try Amplify.add(plugin: AWSS3StoragePlugin())
//            
//            try Amplify.configure()
//            print("Successfully configured Amplify")
//            
//        } catch {
//            print("Could not configure Amplify", error)
//        }
//    }
    
    var body: some Scene {
        WindowGroup {
            ProductsListView()
        }
    }
}
