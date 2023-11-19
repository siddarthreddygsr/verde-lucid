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
    let product_name: String 
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
        return colorScheme == .dark ? Color(red: 48/255, green: 49/255, blue: 53/255) : Color(red: 236/255, green: 240/255, blue: 243/255)
    }

    func neumorphicDarkShadow() -> Color {
        return colorScheme == .dark ? Color(red: 245/255, green: 245/255, blue: 245/255).opacity(0.1) : Color.Neumorphic.darkShadow
    }

    func neumorphicLightShadow() -> Color {
        return colorScheme == .dark ? Color(red: 35/255, green: 36/255, blue: 37/255) : Color.Neumorphic.lightShadow
    }
}


struct ProductsListView: View {
    @Namespace var namespace
    @State var show = false
    @State private var selectedProduct: Product? = nil
    @StateObject var viewModel = ProductsListViewModel()
    @State private var isAddProductViewActive = false
    @State var showAlert = false
    
    var body: some View {
        ZStack {
            if viewModel.isLoading { // Show loader if data is loading
                            ProgressView() // A simple indeterminate loader
                                .progressViewStyle(CircularProgressViewStyle())
            } else {
                VStack {
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
                    ScrollView
                        {
    //                        LazyVStack{
                                
                            

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
    //                                                                    .cornerRadius(30)
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
    //                                                                            .cornerRadius(30)
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
    //                                                            .fill(Color.Neumorphic.main).softOuterShadow()
                                                                .matchedGeometryEffect(id: "\(product.id)_mask", in: namespace)
                                                        )
                                                        .frame(height: 350)
                                                        .padding(20)
                                                        .sheet(item: $selectedProduct) { product in
                                                            VStack {
                                                                Spacer()
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
                                                                Button(action: {
                                                                    showAlert = true
                                                                }) {
                                                                    Text("Add to cart").fontWeight(.bold)
                                                                }
                                                                .softButtonStyle(RoundedRectangle(cornerRadius: 20))
                                                                .alert(isPresented: $showAlert) {
                                                                    Alert(title: Text("Cart"), message: Text("\(product.product_name) was added to cart"), dismissButton: .default(Text("OK")))
                                                                            }
                                                            }
                                                            .background(isDarkMode ? Color(red: 48/255, green: 49/255, blue: 53/255) : Color(red: 237/255, green: 240/255, blue: 243/255)) // Conditional background color
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
    //                                    .fill(Color.Neumorphic.main).softOuterShadow()
                                        .background(
                                            ZStack{
                                                if product.image.isEmpty {
                                                    Image("product2")
                                                        .resizable()
    //                                                    .cornerRadius(30)
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
    //                                                            .cornerRadius(30)
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
    //                                            .fill(Color.Neumorphic.main).softOuterShadow()
                                                .matchedGeometryEffect(id: "\(product.id)_mask", in: namespace)
                                        )
                                        .frame(height: 350)
                                        .padding(20)
                                        .sheet(item: $selectedProduct) { product in
                                            VStack {
                                                Spacer()
                                                if product.image.isEmpty {
                                                    Image("product2")
                                                        .resizable()
                                                        .aspectRatio(contentMode: .fit)
    //                                                    .cornerRadius(30)
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
    //                                                            .cornerRadius(30)
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
                                                Button(action: {showAlert = true}) {
                                                    Text("Add to cart").fontWeight(.bold)
                                                }
                                                .softButtonStyle(RoundedRectangle(cornerRadius: 20))
                                                .alert(isPresented: $showAlert) {
                                                    Alert(title: Text("Cart"), message: Text("\(product.product_name) was added to cart"), dismissButton: .default(Text("OK")))
                                                            }
                                            }
                                            .background(isDarkMode ? Color(red: 48/255, green: 49/255, blue: 53/255) : Color(red: 237/255, green: 240/255, blue: 243/255)) // Conditional background color
                                        }
                                                        
                                    }
                                }
                                
                            }
                    .background(isDarkMode ? Color(red: 48/255, green: 49/255, blue: 53/255) : Color(red: 237/255, green: 240/255, blue: 243/255))
                }
                .background(isDarkMode ? Color(red: 48/255, green: 49/255, blue: 53/255) : Color(red: 237/255, green: 240/255, blue: 243/255))
                    VStack {
                        Spacer()
                        HStack {
                            Button(action: {
                                isAddProductViewActive = true
                            }) {
                                Image(systemName: "plus")
                                    .font(.title)
                                    .clipShape(Circle())
                            }
                            .softButtonStyle(RoundedRectangle(cornerRadius: 20))
                            .padding(20)
                            .frame(maxWidth:.infinity,alignment: .trailing)
                            .sheet(isPresented: $isAddProductViewActive) {
                                AddProductView()
//                                IMageView()
                            }
                            


                        }
                        .frame(maxWidth:.infinity,alignment: .trailing)
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
    
    private var isDarkMode: Bool {
        return UIApplication.shared.windows.first?.rootViewController?.traitCollection.userInterfaceStyle == .dark
    }
}

#Preview {
    ProductsListView()
}

