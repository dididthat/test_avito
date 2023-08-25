//
//  NetworkAPI.swift
//  test_avito
//
//  Created by Diana Nikulina on 24.08.2023.
//

import Foundation

struct NetworkAPI {
    let path: String
    let method: NetworkMethod
}

enum NetworkMethod {
    case get
}
