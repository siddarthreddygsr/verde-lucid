//
//  ProductItemView.swift
//  Verde-Lucid
//
//  Created by Siddarth Reddy on 24/11/23.
//

import SwiftUI

struct ProductItemView: View {
    @Binding var selectedProduct: Product?
    var product: Product
    var namespace: Namespace.ID
    @State private var showAlert = false
    
    var body: some View {
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
            .background(DarkModeManager.isDarkMode ? Color(red: 48/255, green: 49/255, blue: 53/255) : Color(red: 237/255, green: 240/255, blue: 243/255)) // Conditional background color
        }
        
    }
}
