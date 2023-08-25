//
//  CatalogPresenter.swift
//  test_avito
//
//  Created by Diana Nikulina on 24.08.2023.
//

import Foundation
import UIKit

protocol CatalogFlowOutput: AnyObject {
    var viewModels: [CatalogViewModel] { get }
    
    func viewDidLoad()
    func didSelectItem(at index: Int)
    func loadImage(for url: URL, completion: @escaping (UIImage?) -> Void)
}

protocol CatalogPresenterNavigationDelegate: AnyObject {
    func catalogPresenterDidRequestOpenDetailsFlow(
        _ preseneter: CatalogPresenter,
        with container: ProductDetailsFlowDependenciesContainer
    )
}

final class CatalogPresenter: CatalogFlowOutput {
    
    weak var input: CatalogFlowInput?
    
    private(set) var viewModels: [CatalogViewModel] = []
    
    private let client: NetworkClient
    private let imagesProvider: ImagesProvider
    
    private weak var navigationDelegate: CatalogPresenterNavigationDelegate?
    private var models: [AdvertisementDomainModel] = []
    
    init(
        navigationDelegate: CatalogPresenterNavigationDelegate
    ) {
        self.navigationDelegate = navigationDelegate
        self.client = NetworkClient()
        self.imagesProvider = ImagesProvider()
    }
    
    func viewDidLoad() {
        loadData()
    }
    
    func loadImage(for url: URL, completion: @escaping (UIImage?) -> Void) {
        imagesProvider.image(url, completion: completion)
    }
    
    func didSelectItem(at index: Int) {
        guard let model = models[safe: index] else { return }
        
        let container = ProductDetailsFlowDependenciesContainer(
            id: model.id,
            title: model.title,
            imagesProvider: imagesProvider
        )

        navigationDelegate?.catalogPresenterDidRequestOpenDetailsFlow(self, with: container)
    }
}

extension CatalogPresenter {
    private func loadData() {
        client.fetch(.catalog) { [weak self] (result: Result<CatalogDTO, Error>) in
            guard let self else { return }
            
            switch result {
            case .success(let dto):
                let converter = CatalogDTOToDomainConverter()
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "dd.mm.yyyy"
                self.models = dto.advertisements.compactMap { converter.convert(from: $0) }
                self.viewModels = self.models.map { CatalogViewModel(with: $0, dateFormatter: dateFormatter) }
                self.input?.reloadData()
                
            case .failure:
                self.input?.showError()
            }
        }
    }
}

private extension NetworkAPI {
    static let catalog = NetworkAPI(path: "main-page.json", method: .get)
}

extension CatalogViewModel {
    init(with domainMode: AdvertisementDomainModel, dateFormatter: DateFormatter) {
        self.title = domainMode.title
        self.price = domainMode.price
        self.location = domainMode.location
        self.imageURL = domainMode.imageURL
        self.date = dateFormatter.string(from: domainMode.date)
    }
}
