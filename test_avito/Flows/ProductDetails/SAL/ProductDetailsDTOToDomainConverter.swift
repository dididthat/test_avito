//
//  ProductDetailsDTOToDomainConverter.swift
//  test_avito
//
//  Created by Diana Nikulina on 25.08.2023.
//

import Foundation

struct ProductDetailsDTOToDomainConverter{
    func convert(from value: ProductDetailsDTO) -> ProductDetailsDomainModel? {
        guard let url = URL(string: value.imageUrl) else { return nil }
        
        return ProductDetailsDomainModel(
            id: value.id,
            title: value.title,
            price: value.price,
            location: value.location,
            imageURL: url,
            date: value.createdDate,
            description: value.description,
            email: value.email,
            phoneNumber: value.phoneNumber,
            address: value.address
        )
    }
}
