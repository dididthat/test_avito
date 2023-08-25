//
//  ProductDetailsPresenter.swift
//  test_avito
//
//  Created by Diana Nikulina on 24.08.2023.
//

import UIKit

protocol ProductDetailsFlowOutput: AnyObject {
    var viewModel: ProductDetailsViewModel? { get }
    
    func viewDidLoad()
    func loadImage(for url: URL, completion: @escaping (UIImage?) -> Void)
    
    func callButtonDidTap()
    func emailButtonDidTap()
}

protocol ProductDetailsPresenterNavigationDelegate: AnyObject {
    func productDetailsPresenterDidRequestOpenEmailFlow(
        _ presenter: ProductDetailsPresenter,
        email: String
    )
}

final class ProductDetailsPresenter: ProductDetailsFlowOutput {
    weak var input: ProductDetailsFlowInput?
    
    private(set) var viewModel: ProductDetailsViewModel?
    
    private let id: String
    private let imagesProvider: ImagesProvider
    private let client: NetworkClient
    private let messageFlowAvailablityChecker: MessageFlowAvailablityChecker
    
    private weak var navigationDelegate: ProductDetailsPresenterNavigationDelegate?
    private var model: ProductDetailsDomainModel?
    
    init(
        id: String,
        imagesProvider: ImagesProvider,
        navigationDelegate: ProductDetailsPresenterNavigationDelegate
    ) {
        self.id = id
        self.imagesProvider = imagesProvider
        self.navigationDelegate = navigationDelegate
        self.client = NetworkClient()
        self.messageFlowAvailablityChecker = MessageFlowAvailablityChecker()
    }
    
    func viewDidLoad() {
        loadData()
    }
    
    func loadImage(for url: URL, completion: @escaping (UIImage?) -> Void) {
        imagesProvider.image(url, completion: completion)
    }
    
    func callButtonDidTap() {
        guard
            let model,
            let url = URL(string: "tel://\(model.phoneNumber.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression, range: nil))"),
            UIApplication.shared.canOpenURL(url)
        else {
            return
        }
        UIApplication.shared.open(url)
    }
    
    func emailButtonDidTap() {
        if messageFlowAvailablityChecker.check(), let model {
            navigationDelegate?.productDetailsPresenterDidRequestOpenEmailFlow(self, email: model.email)
        } else {
            UIPasteboard.general.string = model?.email
            InAppNotificationManager.shared.showNotification(message: "Почта скопирована")
            UIImpactFeedbackGenerator(style: .light).impactOccurred()
        }
    }
}

private extension NetworkAPI {
    static func details(id: String) -> NetworkAPI {
        NetworkAPI(path: "details/\(id).json", method: .get)
    }
}

extension ProductDetailsPresenter {
    private func loadData() {
        client.fetch(.details(id: id)) { [weak self] (result: Result<ProductDetailsDTO, Error>) in
            guard let self else { return }

            switch result {
            case .success(let dto):
                let converter = ProductDetailsDTOToDomainConverter()
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "dd.mm.yyyy"
               
                guard let model = converter.convert(from: dto) else {
                    self.input?.showError()
                    return
                }
                let viewModel = ProductDetailsViewModel(with: model, dateFormatter: dateFormatter)
                self.model = model
                self.viewModel = viewModel
                
                self.input?.updateUI(with: viewModel)

            case .failure:
                self.input?.showError()
            }
        }
    }
}

extension ProductDetailsViewModel {
    init(with domainMode: ProductDetailsDomainModel, dateFormatter: DateFormatter) {
        self.title = domainMode.title
        self.price = domainMode.price
        self.location = domainMode.location
        self.imageURL = domainMode.imageURL
        self.date = dateFormatter.string(from: domainMode.date)
        self.description = domainMode.description
        self.address = domainMode.address
    }
}
