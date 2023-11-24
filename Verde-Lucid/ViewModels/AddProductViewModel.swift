//
//  AddProductViewModel.swift
//  Verde-Lucid
//
//  Created by Siddarth Reddy on 24/11/23.
//

import Foundation
import _PhotosUI_SwiftUI

class AddProductViewModel: ObservableObject {
    @Published var productName = ""
    @Published var productType = ""
    @Published var price = ""
    @Published var tax = ""
    @Published var selectedImage: [PhotosPickerItem] = []
    @Published var showAlert = false
    @Published var responseString = ""
    @Published var data: Data?
    @Published var isDropdownVisible = false
    
    let productTypes = ["Type A", "Type B", "Type C"]
    
    func addProduct() {
        guard !productName.isEmpty else {
            showAlert = true
            responseString = "Product Name is empty."
            return
        }
        
        guard !productType.isEmpty else {
            showAlert = true
            responseString = "Product Type not selected."
            return
        }
        
        guard let _ = Float(price) else {
            showAlert = true
            responseString = "Given Price value is neither a float nor an integer."
            return
        }
        
        guard let _ = Float(tax) else {
            showAlert = true
            responseString = "Given tax value is neither a float nor an integer."
            return
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
        
        URLSession.shared.dataTask(with: request) { [self] data, response, error in
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
                                    print(jsonResponse ?? "JSON missing")
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
                            let alert = UIAlertController(title: "Product Addition", message: self.responseString, preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                            
                            self.resetFields()
                            self.showAlert.toggle()
                            
                        }
                    } catch {
                        print("Error decoding JSON:", error)
                    }
                }
            }.resume()
        
    }
    
    func handleSelectedImageChange() {
        guard let item = selectedImage.first else {
            return
        }
        item.loadTransferable(type: Data.self) { result in
            switch result {
            case .success(let data):
                if let imageData = data {
                    self.data = imageData
                } else {
                    print("Data is nil")
                }
            case .failure(let failure):
                print("Error loading image data:", failure)
            }
        }
    }
    
    private func resetFields() {
        productName = ""
        productType = ""
        price = ""
        tax = ""
        selectedImage = []
    }
}
