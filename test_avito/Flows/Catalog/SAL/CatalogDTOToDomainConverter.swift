//
//  CatalogDTOToDomainConverter.swift
//  test_avito
//
//  Created by Diana Nikulina on 24.08.2023.
//

import Foundation

struct CatalogDTOToDomainConverter {
    func convert(from value: AdvertisementDTO) -> AdvertisementDomainModel? {
        guard let url = URL(string: value.imageUrl) else { return nil }
        
        return AdvertisementDomainModel(
            id: value.id,
            title: value.title,
            price: value.price,
            location: value.location,
            imageURL: url,
            date: value.createdDate
        )
    }
}
