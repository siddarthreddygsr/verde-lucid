//
//  AddProductButtonView.swift
//  Verde-Lucid
//
//  Created by Siddarth Reddy on 24/11/23.
//

import SwiftUI

struct AddProductButtonView: View {
    @ObservedObject var viewModel: ProductsListViewModel
    
    var body: some View {
        VStack {
            Spacer()
            HStack {
                Button(action: {
                    viewModel.isAddProductViewActive = true
                }) {
                    Image(systemName: "plus")
                        .font(.title)
                        .clipShape(Circle())
                }
                .softButtonStyle(RoundedRectangle(cornerRadius: 20))
                .padding(20)
                .frame(maxWidth:.infinity,alignment: .trailing)
                .sheet(isPresented: $viewModel.isAddProductViewActive) {
                    AddProductView()
                }
            }
            .frame(maxWidth:.infinity,alignment: .trailing)
        }
    }
}
