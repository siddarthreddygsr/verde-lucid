//
//  ContentView.swift
//  Verde-Lucid
//
//  Created by Siddarth Reddy on 15/11/23.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
        }
        .padding()
    }
}

#Preview {
//    ContentView()
    ProductsListView()
}
