//
//  ProductListViewModel.swift
//  Verde-Lucid
//
//  Created by Siddarth Reddy on 23/11/23.
//
//


import SwiftUI

class ProductsListViewModel: ObservableObject {
    @Published var show = false
    @Published var selectedProduct: Product? = nil
    @Published var isAddProductViewActive = false
    @Published var showAlert = false
    @Published var products: [Product] = []
    @Published var filteredProducts: [Product] = []
    @Published var isLoading = false
    @Published var searchText: String = ""

    func fetchProducts() {
        isLoading = true
        guard let url = URL(string: "https://app.getswipe.in/api/public/get") else { return }

        URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
            guard let self = self else { return }

            defer { self.isLoading = false }

            if let error = error {
                print("Request error: ", error)
                return
            }

            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else { return }

            if let data = data {
                do {
                    let decodedProducts = try JSONDecoder().decode([Product].self, from: data)
                    DispatchQueue.main.async {
                        self.products = decodedProducts
                        self.filteredProducts = decodedProducts
                    }
                } catch let error {
                    print("Error decoding: ", error)
                }
            }
        }.resume()
    }

    func filterProducts() {
        if searchText.isEmpty {
            filteredProducts = products
        } else {
            filteredProducts = products.filter {
                $0.product_name.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    
}
