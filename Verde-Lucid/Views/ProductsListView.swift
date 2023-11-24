//
//  ProductsListView.swift
//  Verde-Lucid
//
//  Created by Siddarth Reddy on 16/11/23.
//

import SwiftUI
import Neumorphic


struct ProductsListView: View {
    @Namespace var namespace
    @StateObject var viewModel = ProductsListViewModel()
    
    var body: some View {
        ZStack {
            if viewModel.isLoading {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
            } else {
                VStack {
                    Text("All Products")
                        .font(.title.weight(.bold))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.leading, 20)
                    
                    TextField("Search", text: $viewModel.searchText)
                        .textFieldStyle(NeumorphicTextFieldStyle())
                        .padding(.horizontal, 20)
                        .padding(.trailing, 20)
                    
                    ProductsScrollView(viewModel: viewModel, namespace: namespace)
                        .background(DarkModeManager.isDarkMode ? Color(red: 48/255, green: 49/255, blue: 53/255) : Color(red: 237/255, green: 240/255, blue: 243/255))
                }
                .background(DarkModeManager.isDarkMode ? Color(red: 48/255, green: 49/255, blue: 53/255) : Color(red: 237/255, green: 240/255, blue: 243/255))
                
                AddProductButtonView(viewModel: viewModel)
            }
        }
        .onAppear {
            viewModel.fetchProducts()
        }
        .onChange(of: viewModel.searchText) {
            viewModel.filterProducts()
        }
    }
}






//struct ProductsListView: View {
//    @Namespace var namespace
//    @StateObject var viewModel = ProductsListViewModel()
//    
//    var body: some View {
//        ZStack {
//            if viewModel.isLoading {
//                            ProgressView()
//                                .progressViewStyle(CircularProgressViewStyle())
//            } else {
//                VStack {
//                    Text("All Products")
//                    .font(.title.weight(.bold))
//                    .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/,alignment: .leading)
//                    .padding(.leading, 20)
////                            Divider()
//                    TextField("Search", text: $viewModel.searchText)
//                            .textFieldStyle(NeumorphicTextFieldStyle())
//                            .padding(.leading,20)
//                            .padding(.trailing,20)
//                    ScrollView
//                        {
//                            if viewModel.filteredProducts.isEmpty && viewModel.searchText.isEmpty {
//                                ForEach(viewModel.products, id: \.id) { product in
//                                    ProductItemView(selectedProduct: $viewModel.selectedProduct, product: product, namespace: namespace)
//                                }
//                                                }
//                            else if viewModel.filteredProducts.isEmpty {
//                                                    Text("No matching products")
//                                                        .foregroundColor(.gray)
//                                                } else {
//                                    ForEach(viewModel.filteredProducts, id: \.id) { product in
//                                        ProductItemView(selectedProduct: $viewModel.selectedProduct, product: product, namespace: namespace)
//                                    }
//                                }
//                                
//                            }
//                        .background(DarkModeManager.isDarkMode ? Color(red: 48/255, green: 49/255, blue: 53/255) : Color(red: 237/255, green: 240/255, blue: 243/255))
//                }
//                .background(DarkModeManager.isDarkMode ? Color(red: 48/255, green: 49/255, blue: 53/255) : Color(red: 237/255, green: 240/255, blue: 243/255))
//                    VStack {
//                        Spacer()
//                        HStack {
//                            Button(action: {
//                                viewModel.isAddProductViewActive = true
//                            }) {
//                                Image(systemName: "plus")
//                                    .font(.title)
//                                    .clipShape(Circle())
//                            }
//                            .softButtonStyle(RoundedRectangle(cornerRadius: 20))
//                            .padding(20)
//                            .frame(maxWidth:.infinity,alignment: .trailing)
//                            .sheet(isPresented: $viewModel.isAddProductViewActive) {
//                                AddProductView()
////                                IMageView()
//                            }
//                            
//
//
//                        }
//                        .frame(maxWidth:.infinity,alignment: .trailing)
//                    }
//                
//            }
//        }
//        .onAppear {
//            viewModel.fetchProducts()
//        }
//        .onChange(of: viewModel.searchText) { newValue in
//            viewModel.filterProducts()
//                }
//    }
//    
//}

//#Preview {
//    ProductsListView()
//}
//
