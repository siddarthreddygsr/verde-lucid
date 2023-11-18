//
//  AddProductView.swift
//  Verde-Lucid
//
//  Created by Siddarth Reddy on 18/11/23.
//

import SwiftUI

struct AddProductView: View {
    @State var searchText: String = ""
    var body: some View {
        VStack
        {
            Text("Add Products")
                .font(.title.weight(.bold))
                .frame(maxWidth: .infinity,alignment: .leading)
                .padding(.leading, 20)
            TextField("Search", text: $searchText)
                .textFieldStyle(NeumorphicTextFieldStyle())
                .padding(.leading,20)
                .padding(.trailing,20)
        }
    }
}

#Preview {
    AddProductView()
}
