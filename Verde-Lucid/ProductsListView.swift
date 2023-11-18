//
//  ProductsListView.swift
//  Verde-Lucid
//
//  Created by Siddarth Reddy on 16/11/23.
//

import SwiftUI
import Neumorphic


struct Product: Codable, Hashable, Identifiable {
    let id = UUID()
    let image: String
    let price: Double
    let product_name: String // Modify the property names to match the API response
    let product_type: String
    let tax: Double
}

class ProductsListViewModel: ObservableObject {
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


struct NeumorphicTextFieldStyle: TextFieldStyle {
    @Environment(\.colorScheme) var colorScheme

    func _body(configuration: TextField<_Label>) -> some View {
        configuration
            .padding(EdgeInsets(top: 10, leading: 15, bottom: 10, trailing: 15))
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(neumorphicBackgroundColor())
                    .softOuterShadow(darkShadow: neumorphicDarkShadow(), lightShadow: neumorphicLightShadow(), offset: 5, radius: 10)
                    .softInnerShadow(RoundedRectangle(cornerRadius: 12), darkShadow: neumorphicDarkShadow(), lightShadow: neumorphicLightShadow(), spread: 0.1, radius: 2)
            )
    }

    func neumorphicBackgroundColor() -> Color {
        return colorScheme == .dark ? Color.black : Color.white
    }

    func neumorphicDarkShadow() -> Color {
        return colorScheme == .dark ? Color.white.opacity(0.1) : Color.Neumorphic.darkShadow
    }

    func neumorphicLightShadow() -> Color {
        return colorScheme == .dark ? Color.black.opacity(0.5) : Color.Neumorphic.lightShadow
    }
}


struct ProductsListView: View {
    @Namespace var namespace
//    @State private var products: [Product] = []
    @State var show = false
//    @State private var isLoading = false
//    @State private var searchText: String = ""
//    @State private var filteredProducts: [Product] = []
    @State private var selectedProduct: Product? = nil
    @StateObject var viewModel = ProductsListViewModel()

    
    var body: some View {
        ZStack {
            if viewModel.isLoading { // Show loader if data is loading
                            ProgressView() // A simple indeterminate loader
                                .progressViewStyle(CircularProgressViewStyle())
            } else {
                if !show {
                    ScrollView
                    {
//                        LazyVStack{
                            Text("All Products")
                            .font(.title.weight(.bold))
                            .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/,alignment: .leading)
                            .padding(.leading, 20)
//                            Divider()
                        TextField("Search", text: $viewModel.searchText)
//                                                .textFieldStyle(RoundedBorderTextFieldStyle())
                            .textFieldStyle(NeumorphicTextFieldStyle())
                                                .padding(.leading,20)
                                                .padding(.trailing,20)
                        

                        if viewModel.filteredProducts.isEmpty && viewModel.searchText.isEmpty {
                            ForEach(viewModel.products, id: \.id) { product in
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
                                                            ZStack{
                                                                Color.gray.opacity(0.5)
                                                                Rectangle()
                                                                    .fill(.ultraThinMaterial)
                                                                    .mask(RoundedRectangle(cornerRadius: 30, style: .continuous))
                                                                    .blur(radius: 30)
                                                                    .matchedGeometryEffect(id: "\(product.id)_blur", in: namespace)
                                                            }
                                                        )
                                                    }
                                                    .onTapGesture{selectedProduct = product}
                                                    .foregroundStyle(.white)
                                                    .background(
                                                        ZStack{
                                                            if product.image.isEmpty {
                                                                Image("product2")
                                                                    .resizable()
                                                                    .aspectRatio(contentMode: .fill)
                                                            }
                                                            else {
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
                                                    .sheet(item: $selectedProduct) { product in
                                                        VStack {
                                                            if product.image.isEmpty {
                                                                Image("product2")
                                                                    .resizable()
                                                                    .aspectRatio(contentMode: .fit)
//                                                                    .frame(width: 300, height:300)
                                                                    .padding(20)
                                                            }
                                                            else {
                                                                AsyncImage(url: URL(string: product.image)) { phase in
                                                                    switch phase {
                                                                    case .empty:
                                                                        ProgressView() // Placeholder view while loading
                                                                    case .success(let image):
                                                                        image
                                                                            .resizable()
                                                                            .aspectRatio(contentMode: .fit)
                                                                            .matchedGeometryEffect(id: "\(product.id)_image", in: namespace)
                                                                    case .failure:
                                                                        Image(systemName: "photo") // Placeholder when image fails to load
                                                                            .symbolRenderingMode(.multicolor)
                                                                            .foregroundColor(.gray)
                                                                    @unknown default:
                                                                        EmptyView()
                                                                    }
                                                                }
                                                                .padding(20)
                                                            }
                                                            
                                                            VStack{
                                                                Text("\(product.product_name.replacingOccurrences(of: "\n", with: ""))")
                                                                    .font(.title.weight(.bold))
                                                                    .matchedGeometryEffect(id: product.id, in: namespace)
                                                                    .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/,alignment: .leading)
                                                                Text("Category: \(product.product_type.replacingOccurrences(of: "\n", with: ""))")
                                                                    .matchedGeometryEffect(id: "\(product.id)_type", in: namespace)
                                                                    .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/,alignment: .leading)
                                                                Text("Price before tax: \(String(format: "%.2f", product.price))")
                                                                    .matchedGeometryEffect(id: "\(product.id)_price", in: namespace)
                                                                    .frame(maxWidth: .infinity,alignment: .leading)
                                                                Text("Tax: \(String(format: "%.2f", product.tax))")
                                                                    .matchedGeometryEffect(id: "\(product.id)_tax", in: namespace)
                                                                    .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/,alignment: .leading)
                                                                Text("Price after tax: \(String(format: "%.2f", product.price + product.tax))")
                                                                    .matchedGeometryEffect(id: "\(product.id)_priceAfterTax", in: namespace)
                                                                    .frame(maxWidth: .infinity, alignment: .leading)
                                                            }
                                                            .padding(20)
                                                            // Add other product information here as needed
                                                            CorrectButton()
                                                        }
                                                    }
                                                }
                                            }
                        else if viewModel.filteredProducts.isEmpty {
                                                Text("No matching products")
                                                    .foregroundColor(.gray)
                                            } else {
    //                                            if searchText.isEmpty {
    //                                                filteredProducts = products
    //                                                print(products)
    //
    //                                            }

                                                ForEach(viewModel.filteredProducts, id: \.id) { product in
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
//                                            Text(String(format: "%.2f", product.tax))
//                                                .matchedGeometryEffect(id: "\(product.id)_tax", in: namespace)
//                                                .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/,alignment: .leading)
                                        }
                                        .padding(20)
                                        .background(.ultraThinMaterial)
                                        .cornerRadius(20)
                                    }
                                    .onTapGesture{selectedProduct = product}
                                    .foregroundStyle(.white)
                                    .background(
                                        ZStack{
                                            if product.image.isEmpty {
                                                Image("product2")
                                                    .resizable()
                                                    .aspectRatio(contentMode: .fit)
                                            }
                                            else {
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
                                    .sheet(item: $selectedProduct) { product in
                                        VStack {
                                            if product.image.isEmpty {
                                                Image("product2")
                                                    .resizable()
                                                    .aspectRatio(contentMode: .fit)
//                                                                    .frame(width: 300, height:300)
                                                    .padding(20)
                                            }
                                            else {
                                                AsyncImage(url: URL(string: product.image)) { phase in
                                                    switch phase {
                                                    case .empty:
                                                        ProgressView() // Placeholder view while loading
                                                    case .success(let image):
                                                        image
                                                            .resizable()
                                                            .aspectRatio(contentMode: .fit)
                                                            .matchedGeometryEffect(id: "\(product.id)_image", in: namespace)
                                                    case .failure:
                                                        Image(systemName: "photo") // Placeholder when image fails to load
                                                            .symbolRenderingMode(.multicolor)
                                                            .foregroundColor(.gray)
                                                    @unknown default:
                                                        EmptyView()
                                                    }
                                                }
                                                .padding(20)
                                            }
                                            
                                            VStack{
                                                Text("\(product.product_name.replacingOccurrences(of: "\n", with: ""))")
                                                    .font(.title.weight(.bold))
                                                    .matchedGeometryEffect(id: product.id, in: namespace)
                                                    .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/,alignment: .leading)
                                                Text("Category: \(product.product_type.replacingOccurrences(of: "\n", with: ""))")
                                                    .matchedGeometryEffect(id: "\(product.id)_type", in: namespace)
                                                    .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/,alignment: .leading)
                                                Text("Price before tax: \(String(format: "%.2f", product.price))")
                                                    .matchedGeometryEffect(id: "\(product.id)_price", in: namespace)
                                                    .frame(maxWidth: .infinity,alignment: .leading)
                                                Text("Tax: \(String(format: "%.2f", product.tax))")
                                                    .matchedGeometryEffect(id: "\(product.id)_tax", in: namespace)
                                                    .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/,alignment: .leading)
                                                Text("Price after tax: \(String(format: "%.2f", product.price + product.tax))")
                                                    .matchedGeometryEffect(id: "\(product.id)_priceAfterTax", in: namespace)
                                                    .frame(maxWidth: .infinity, alignment: .leading)
                                            }
                                            .padding(20)
                                            // Add other product information here as needed
                                            Button(action: {}) {
                                                Text("Soft Button").fontWeight(.bold)
                                            }
                                            .softButtonStyle(RoundedRectangle(cornerRadius: 20))
                                        }
                                    }
                                }
                            }
                        }
//                        }
                }
                else{
                    ScrollView {
                        ForEach(viewModel.products, id: \.self) { product in
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
            viewModel.fetchProducts()
        }
        .onChange(of: viewModel.searchText) { newValue in
            viewModel.filterProducts()
                }
        .onTapGesture{
//            fetchProducts()
//            withAnimation{
//                show.toggle()
//            }
        }
    }
    
//    func fetchProducts() {
//        isLoading = true
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
//
//                // Print raw data as a string
//                if let dataString = String(data: data, encoding: .utf8) {
//                    print("Raw Data:")
//                    print(dataString)
//                }
//
//                DispatchQueue.main.async {
//                    isLoading = false
//                    do {
//                        let decodedProducts = try JSONDecoder().decode([Product].self, from: data)
//                        self.products = decodedProducts
//                    } catch let error {
//                        print("Error decoding: ", error)
//                    }
//                }
//            }
//        }
//
//        dataTask.resume()
//    }
//
//    func filterProducts() {
//            if searchText.isEmpty {
//                filteredProducts = products
//                print("search string was empty")
//            } else {
//                filteredProducts = products.filter {
//                    $0.product_name.localizedCaseInsensitiveContains(searchText)
//                }
//            }
//        print(filteredProducts)
//        print(searchText)
//        }
}

#Preview {
    ProductsListView()
}

