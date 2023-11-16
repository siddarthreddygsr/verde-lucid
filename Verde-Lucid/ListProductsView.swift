//
//  ListProductsView.swift
//  Verde-Lucid
//
//  Created by Siddarth Reddy on 16/11/23.
//

import SwiftUI

struct Productstruct: Codable,Hashable {
    let image: String
    let price: Double
    let product_name: String // Modify the property names to match the API response
    let product_type: String
    let tax: Double
}

struct ListProductsView: View {
    @Namespace var namespace
    @State private var products: [Productstruct] = []
    @State var show = false
    var body: some View {
//        Text("Hello WORLD")
        ScrollView {
            LazyVStack(spacing: 20) {
                ForEach(products, id: \.self) { product in
                    VStack(alignment: .leading, spacing: 12) {
                        Text(product.product_name)
                            .font(.largeTitle.weight(.bold))
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .matchedGeometryEffect(id: product.product_name, in: namespace)
                        Text(product.product_type)
                            .matchedGeometryEffect(id: "\(product.product_name)_type", in: namespace)
                        Text("\(product.price)")
                            .matchedGeometryEffect(id: "\(product.product_name)_price", in: namespace)
                        Text("\(product.tax)")
                            .matchedGeometryEffect(id: "\(product.product_name)_tax", in: namespace)
                    }
                    .padding(20)
                    .background(
                        Rectangle()
                            .fill(.ultraThinMaterial)
                            .mask(RoundedRectangle(cornerRadius: 30, style: .continuous))
                            .blur(radius: 30)
                            .matchedGeometryEffect(id: "blur_\(product.product_name)", in: namespace)
                    )
                    .foregroundStyle(.white)
                    .frame(height: 350)
                    .onTapGesture {
                        withAnimation {
                            show.toggle()
                        }
                    }
                }
            }
            .padding(20)
        }
        .onAppear {
            fetchProducts()
        }
    }

    
    func fetchProducts() {
        guard let url = URL(string: "https://app.getswipe.in/api/public/get") else { fatalError("Missing URL") }

        let urlRequest = URLRequest(url: url)

        let dataTask = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            if let error = error {
                print("Request error: ", error)
                return
            }

            guard let response = response as? HTTPURLResponse else { return }

            if response.statusCode == 200 {
                guard let data = data else { return }

                // Print raw data as a string
                if let dataString = String(data: data, encoding: .utf8) {
                    print("Raw Data:")
                    print(dataString)
                }

                DispatchQueue.main.async {
                    do {
                        let decodedProducts = try JSONDecoder().decode([Productstruct].self, from: data)
                        self.products = decodedProducts
                    } catch let error {
                        print("Error decoding: ", error)
                    }
                }
            }
        }

        dataTask.resume()
    }

//    func fetchProducts() {
//        guard let url = URL(string: "https://app.getswipe.in/api/public/get") else { fatalError("Missing URL") }
//
//        let urlRequest = URLRequest(url: url)
//
//        let dataTask = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
//            if let error = error {
//                print("Request error: ", error)
//                return
//            }
//
//            guard let response = response as? HTTPURLResponse else { return }
//
//            if response.statusCode == 200 {
//                guard let data = data else { return }
//                DispatchQueue.main.async {
//                    do {
//                        let decodedproducts = try JSONDecoder().decode([Product].self, from: data)
//                        self.products = decodedproducts
//                    } catch let error {
//                        print("Error decoding: ", error)
//                    }
//                }
//            }
//        }
//
//        dataTask.resume()
//    }
    
//    func fetchProducts() {
//        guard let url = URL(string: "https://app.getswipe.in/api/public/get") else {
//            return
//        }
//
//        URLSession.shared.dataTask(with: url) { data, response, error in
//            if let error = error {
//                print("Error: \(error)")
//                return
//            }
//
//            guard let data = data else {
//                print("No data received")
//                return
//            }
//
//            do {
//                // Decode the received JSON data into an array of Product objects
//                let decodedData = try JSONDecoder().decode([Product].self, from: data)
//                // Update products array on the main thread
//                DispatchQueue.main.async {
//                    self.products = decodedData
//                }
//            } catch {
//                print("Error decoding JSON: \(error)")
//            }
//        }.resume()
//    }
}

#Preview {
    ListProductsView()
}
