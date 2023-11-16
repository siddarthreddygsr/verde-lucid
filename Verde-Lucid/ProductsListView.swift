//
//  ProductsListView.swift
//  Verde-Lucid
//
//  Created by Siddarth Reddy on 16/11/23.
//

import SwiftUI

struct Product: Codable, Hashable {
    let id = UUID()
    let image: String
    let price: Double
    let product_name: String // Modify the property names to match the API response
    let product_type: String
    let tax: Double
}

struct ProductsListView: View {
    @Namespace var namespace
    @State private var products: [Product] = []
    @State var show = false
    @State private var isLoading = false
    @State private var searchText: String = ""
    @State private var filteredProducts: [Product] = []

    var body: some View {
        ZStack {
            if isLoading { // Show loader if data is loading
                            ProgressView() // A simple indeterminate loader
                                .progressViewStyle(CircularProgressViewStyle())
            } else {
                if !show {
                    ScrollView
                    {
                        Text("All Products")
                            .font(.largeTitle.weight(.bold))
                        Divider()
                        TextField("Search", text: $searchText)
                                            .textFieldStyle(RoundedBorderTextFieldStyle())
                                            .padding()

                                        if filteredProducts.isEmpty {
                                            Text("No matching products")
                                                .foregroundColor(.gray)
                                        } else {
                            ForEach(filteredProducts, id: \.id) { product in
                                VStack(alignment: .leading, spacing: 12) {
                                    Spacer()
                                    VStack {
                                        Text(product.product_name.replacingOccurrences(of: "\n", with: ""))
        //                                Text("")
                                            .font(.title.weight(.bold))
                                            .matchedGeometryEffect(id: product.id, in: namespace)
                                            .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/,alignment: .leading)
                                        Text(product.product_type.replacingOccurrences(of: "\n", with: ""))
                                            .matchedGeometryEffect(id: "\(product.id)_type", in: namespace)
                                            .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/,alignment: .leading)
                                        Text(String(format: "%.2f", product.price))
                                            .matchedGeometryEffect(id: "\(product.id)_price", in: namespace)
                                            .frame(maxWidth: .infinity,alignment: .leading)
                                        Text(String(format: "%.2f", product.tax))
                                            .matchedGeometryEffect(id: "\(product.id)_tax", in: namespace)
                                            .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/,alignment: .leading)
                                    }
                                    .padding(20)
                                    .background(
                                        Rectangle()
                                            .fill(.ultraThinMaterial)
                                            .mask(RoundedRectangle(cornerRadius: 30, style: .continuous))
                                            .blur(radius: 30)
                                            .matchedGeometryEffect(id: "\(product.id)_blur", in: namespace)
                                    )
                                }
                                
                                .foregroundStyle(.white)
                                .background(
                                    ZStack{
                                        AsyncImage(url: URL(string: product.image)) { phase in
                                            switch phase {
                                            case .empty:
                                                ProgressView() // Placeholder view while loading
                                            case .success(let image):
                                                image
                                                    .resizable()
                                                    .aspectRatio(contentMode: .fill)
                                                    .matchedGeometryEffect(id: "\(product.id)_image", in: namespace)
                                            case .failure:
                                                Image(systemName: "photo") // Placeholder when image fails to load
                                                    .symbolRenderingMode(.multicolor)
                                                    .foregroundColor(.gray)
                                            @unknown default:
                                                EmptyView()
                                            }
                                        }
                                        Color.black.opacity(0.5)
                                    }
                                )
                                .mask(
                                    RoundedRectangle(cornerRadius: 30, style: .continuous)
                                        .matchedGeometryEffect(id: "\(product.id)_mask", in: namespace)
                                )
                                .frame(height: 350)
                                .padding(20)
                            }
                        }
                    }
                }
                else{
                    ScrollView {
                        ForEach(products, id: \.self) { product in
                            VStack {
                                Spacer()
                            }
                            .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
                            .frame(height: 500)
                            .foregroundStyle(.black)
                            .background(
                                Image("product2")
//                                AsyncImage(url: URL(string: product.image))
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .matchedGeometryEffect(id: "\(product.id)_image", in: namespace)
                                //                    Color.blue.matchedGeometryEffect(id: "background", in: namespace)
                            )
                            .mask(
                                RoundedRectangle(cornerRadius: 30, style: .continuous)
                                    .matchedGeometryEffect(id: "\(product.id)_mask", in: namespace)
                            )
                            .overlay(
                                VStack(alignment: .leading, spacing: 12){
                                    Text(product.product_name.replacingOccurrences(of: "\n", with: ""))
                                        .font(.title.weight(.bold))
                                        .matchedGeometryEffect(id: product.id, in: namespace)
                                        .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/,alignment: .leading)
                                    Text(product.product_type.replacingOccurrences(of: "\n", with: ""))
                                        .matchedGeometryEffect(id: "\(product.id)_type", in: namespace)
                                        .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/,alignment: .leading)
                                    Text(String(format: "%.2f", product.tax))
                                        .matchedGeometryEffect(id: "\(product.id)_price", in: namespace)
                                        .frame(maxWidth: .infinity,alignment: .leading)
                                    Text(String(format: "%.2f", product.tax))
                                        .matchedGeometryEffect(id: "\(product.id)_tax", in: namespace)
                                        .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/,alignment: .leading)
                                }
                                    .padding(20)
                                    .background(
                                        Rectangle()
                                            .fill(.ultraThinMaterial)
                                            .mask(RoundedRectangle(cornerRadius: 30, style: .continuous))
                                        //                                .blur(radius: 30)
                                            .matchedGeometryEffect(id: "\(product.id)_blur", in: namespace)
                                    )
                                    .offset(y:230)
                                    .padding(20)
                                )
                            }
                        }
                    }
                
            }
        }
        .onAppear {
            fetchProducts()
        }
        .onChange(of: searchText) { newValue in
                    filterProducts()
                }
        .onTapGesture{
//            fetchProducts()
//            withAnimation{
//                show.toggle()
//            }
        }
    }
    
    func fetchProducts() {
        isLoading = true
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
                    isLoading = false
                    do {
                        let decodedProducts = try JSONDecoder().decode([Product].self, from: data)
                        self.products = decodedProducts
                    } catch let error {
                        print("Error decoding: ", error)
                    }
                }
            }
        }

        dataTask.resume()
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
    ProductsListView()
}
