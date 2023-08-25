//
//  ProductDetailsDTO.swift
//  test_avito
//
//  Created by Diana Nikulina on 25.08.2023.
//

import Foundation

struct ProductDetailsDTO: Decodable {
    let id: String
    let title: String
    let price: String
    let location: String
    let imageUrl: String
    let createdDate: Date
    let description: String
    let email: String
    let phoneNumber: String
    let address: String
}
