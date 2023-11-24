//
//  AddProductView.swift
//  Verde-Lucid
//
//  Created by Siddarth Reddy on 18/11/23.
//


import SwiftUI
import PhotosUI
//import Amplify
//import AWSS3
import Neumorphic

struct AddProductView: View {
    
    @StateObject var viewModel = AddProductViewModel()
    
    var body: some View {
        
        VStack {
            Text("Add Products")
                .font(.title.weight(.bold))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading, 20)
                .padding(.top,20)
            
            TextField("Product Name", text: $viewModel.productName)
                .textFieldStyle(NeumorphicTextFieldStyle())
                .padding(.horizontal, 20)
                .padding(.top, 20)
            
            Button(action: {
                viewModel.isDropdownVisible.toggle()
            }) {
                HStack {
                    Text("Category")
                    Spacer()
                    Image(systemName: "chevron.down")
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.gray.opacity(0.2))
                .clipShape(RoundedRectangle(cornerRadius: 10))
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)
            .popover(isPresented: $viewModel.isDropdownVisible, arrowEdge: .top) {
                VStack {
                    ForEach(viewModel.productTypes, id: \.self) { type in
                        Button(action: {
                            viewModel.productType = type
                            viewModel.isDropdownVisible.toggle()
                        }) {
                            Text(type)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.gray.opacity(0.1))
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                        }
                    }
                }
            }
            
            TextField("Price", text: $viewModel.price)
                .keyboardType(.numberPad)
                .textFieldStyle(NeumorphicTextFieldStyle())
                .padding(.horizontal, 20)
                .padding(.top, 20)
            
            TextField("Tax", text: $viewModel.tax)
                .keyboardType(.decimalPad)
                .textFieldStyle(NeumorphicTextFieldStyle())
                .padding(.horizontal, 20)
                .padding(.top, 20)
            PhotosPicker(
                selection: $viewModel.selectedImage,
                maxSelectionCount: 1,
                matching: .images
            ) {
                Text("Select Image").fontWeight(.bold)
                    .padding(20)
            }

            .onChange(of: viewModel.selectedImage) { _ in
                viewModel.handleSelectedImageChange()
            }
            
            
            Button("Submit") {
                viewModel.addProduct()
            }
            .softButtonStyle(RoundedRectangle(cornerRadius: 20))
            .alert(isPresented: $viewModel.showAlert) {
                Alert(title: Text("Product Addition"), message: Text(viewModel.responseString), dismissButton: .default(Text("OK")))
                        }
            .padding()
            .frame(maxWidth: .infinity)
            .padding(.horizontal, 20)
            .padding(.bottom, 40)
            Spacer()
        }
        .background(DarkModeManager.isDarkMode ? Color(red: 48/255, green: 49/255, blue: 53/255) : Color(red: 237/255, green: 240/255, blue: 243/255))
    }
    
}

//#Preview {
//    AddProductView()
//}
