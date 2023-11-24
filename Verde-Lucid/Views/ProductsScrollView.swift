//
//  ProductsScrollView.swift
//  Verde-Lucid
//
//  Created by Siddarth Reddy on 24/11/23.
//

import SwiftUI

struct ProductsScrollView: View {
    @ObservedObject var viewModel: ProductsListViewModel
    var namespace: Namespace.ID
    
    var body: some View {
        ScrollView {
            if viewModel.filteredProducts.isEmpty && viewModel.searchText.isEmpty {
                ForEach(viewModel.products, id: \.id) { product in
                    ProductItemView(selectedProduct: $viewModel.selectedProduct, product: product, namespace: namespace)
                }
            } else if viewModel.filteredProducts.isEmpty {
                Text("No matching products")
                    .foregroundColor(.gray)
            } else {
                ForEach(viewModel.filteredProducts, id: \.id) { product in
                    ProductItemView(selectedProduct: $viewModel.selectedProduct, product: product, namespace: namespace)
                }
            }
        }
    }
}
