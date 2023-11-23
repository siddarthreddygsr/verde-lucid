//
//  Product.swift
//  Verde-Lucid
//
//  Created by Siddarth Reddy on 23/11/23.
//

import Foundation

struct Product: Codable, Hashable, Identifiable {
    let id = UUID()
    let image: String
    let price: Double
    let product_name: String
    let product_type: String
    let tax: Double
}
