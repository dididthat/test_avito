//
//  CatalogDTO.swift
//  test_avito
//
//  Created by Diana Nikulina on 24.08.2023.
//

import Foundation

struct CatalogDTO: Decodable {
    let advertisements: [AdvertisementDTO]
}

struct AdvertisementDTO: Decodable {
    let id: String
    let title: String
    let price: String
    let location: String
    let imageUrl: String
    let createdDate: Date
}
