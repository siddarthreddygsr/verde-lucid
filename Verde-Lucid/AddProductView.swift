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
    @State var productName = ""
    @State var productType = ""
    @State var price = ""
    @State var tax = ""
    @State var isDropdownVisible = false
    @State var selectedImage: [PhotosPickerItem] = []
    @State private var imageURL: String = ""
    @State var data: Data?
    @State private var imgurLink: String = ""
    @State private var showAlert = false
    @State private var responseString = ""
    //    @State private var selectedImage: UIImage?
    
    let productTypes = ["Type A", "Type B", "Type C"] // Example types, replace with your types
    
    var body: some View {
        
        VStack {
            Text("Add Products")
                .font(.title.weight(.bold))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading, 20)
                .padding(.top,20)
            
            TextField("Product Name", text: $productName)
                .textFieldStyle(NeumorphicTextFieldStyle())
                .padding(.horizontal, 20)
                .padding(.top, 20)
            
            Button(action: {
                isDropdownVisible.toggle()
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
            .popover(isPresented: $isDropdownVisible, arrowEdge: .top) {
                VStack {
                    ForEach(productTypes, id: \.self) { type in
                        Button(action: {
                            productType = type
                            isDropdownVisible.toggle()
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
            
            TextField("Price", text: $price)
                .keyboardType(.numberPad)
                .textFieldStyle(NeumorphicTextFieldStyle())
                .padding(.horizontal, 20)
                .padding(.top, 20)
            
            TextField("Tax", text: $tax)
                .keyboardType(.decimalPad)
                .textFieldStyle(NeumorphicTextFieldStyle())
                .padding(.horizontal, 20)
                .padding(.top, 20)
            PhotosPicker(
                selection: $selectedImage,
                maxSelectionCount: 1,
                matching: .images
            ) {
                Text("Select Image").fontWeight(.bold)
                    .padding(20)
            }

            .onChange(of: selectedImage) { newValue in
                guard let item = selectedImage.first else{
                    return
                }
                item.loadTransferable(type: Data.self) { result in
                    switch result{
                    case .success(let data):
                        if let data = data {
                            self.data = data
                        } else {
                            print("data is nil")
                        }
                    case .failure(let failure):
                        fatalError("\(failure)")
                    }
                }
            }
            
            
            Button("Submit") {
                guard !productName.isEmpty else {
                    // Show an alert if any field is empty
                    showAlert = true
                    responseString = "Product Name is empty."
                    return
                }
                guard !productType.isEmpty else {
                    // Show an alert if any field is empty
                    showAlert = true
                    responseString = "Product Type not selected."
                    return
                }
                if let priceValue = Float(price) {
                    print("valid")
                    } else {
                        // Price is not a valid float
                        showAlert = true
                        responseString = "Given Price value is neither a float nor an integer."
                    }
                if let taxValue = Float(tax) {
                        print("valid")
                    } else {
                        // Price is not a valid float
                        showAlert = true
                        responseString = "Given tax value is neither a float nor an integer."
                    }
                guard !productName.isEmpty, !productType.isEmpty, !price.isEmpty, !tax.isEmpty else {
                    // Show an alert if any field is empty
                    showAlert = true
                    responseString = "Please fill in all fields."
                    return
                }
                
                guard let url = URL(string: "https://app.getswipe.in/api/public/add") else {
                    print("Invalid URL")
                    return
                }
                
                // Prepare the request body with form data
                var request = URLRequest(url: url)
                request.httpMethod = "POST"
                
                let boundary = "Boundary-\(UUID().uuidString)"
                request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
                
                var body = Data()
                
                // Add product_name parameter
                body.append("--\(boundary)\r\n".data(using: .utf8)!)
                body.append("Content-Disposition: form-data; name=\"product_name\"\r\n\r\n".data(using: .utf8)!)
                body.append("\(productName)\r\n".data(using: .utf8)!)
                
                // Add product_type parameter
                body.append("--\(boundary)\r\n".data(using: .utf8)!)
                body.append("Content-Disposition: form-data; name=\"product_type\"\r\n\r\n".data(using: .utf8)!)
                body.append("\(productType)\r\n".data(using: .utf8)!)
                
                // Add price parameter
                body.append("--\(boundary)\r\n".data(using: .utf8)!)
                body.append("Content-Disposition: form-data; name=\"price\"\r\n\r\n".data(using: .utf8)!)
                body.append("\(price)\r\n".data(using: .utf8)!)
                
                // Add tax parameter
                body.append("--\(boundary)\r\n".data(using: .utf8)!)
                body.append("Content-Disposition: form-data; name=\"tax\"\r\n\r\n".data(using: .utf8)!)
                body.append("\(tax)\r\n".data(using: .utf8)!)
                
                // Add image file if available
                if let imageData = data {
                    body.append("--\(boundary)\r\n".data(using: .utf8)!)
                    body.append("Content-Disposition: form-data; name=\"files[]\"; filename=\"image.jpeg\"\r\n".data(using: .utf8)!)
                    body.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
                    body.append(imageData)
                    body.append("\r\n".data(using: .utf8)!)
                }
                
                body.append("--\(boundary)--\r\n".data(using: .utf8)!)
                
                request.httpBody = body
                
                // Send the request
                URLSession.shared.dataTask(with: request) { data, response, error in
                    if let error = error {
                        print("Error:", error)
                        return
                    }
                    
                    if let data = data {
                            do {
                                let jsonResponse = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                                

                                if let success = jsonResponse?["success"] as? Bool {
                                    if success {
                                        // Product addition was successful
                                        if let productDetails = jsonResponse?["product_details"] as? [String: Any],
                                           let productName = productDetails["product_name"] as? String {
                                            print(jsonResponse)
                                            responseString = "Success: \(productName) was added successfully!\n Product ID: \(String(describing: jsonResponse?["product_id"]))"
                                        } else {
                                            responseString = "Failed: Unable to get product details."
                                        }
                                    } else {
                                        responseString = "Failed: Product addition was unsuccessful."
                                    }
                                } else {
                                    responseString = "Failed: Invalid response."
                                }

                                DispatchQueue.main.async {
                                    let alert = UIAlertController(title: "Product Addition", message: responseString, preferredStyle: .alert)
                                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                                    showAlert.toggle()
                                }
                            } catch {
                                print("Error decoding JSON:", error)
                            }
                        }
                    }.resume()
            }
            .softButtonStyle(RoundedRectangle(cornerRadius: 20))
            .alert(isPresented: $showAlert) {
                            Alert(title: Text("Product Addition"), message: Text(responseString), dismissButton: .default(Text("OK")))
                        }
            .padding()
            .frame(maxWidth: .infinity)
            .padding(.horizontal, 20)
            .padding(.bottom, 40)
            Spacer()
        }
        .background(isDarkMode ? Color(red: 48/255, green: 49/255, blue: 53/255) : Color(red: 237/255, green: 240/255, blue: 243/255))
    }
    
    public var isDarkMode: Bool {
            return UIApplication.shared.windows.first?.rootViewController?.traitCollection.userInterfaceStyle == .dark
        }
}

#Preview {
    AddProductView()
}
