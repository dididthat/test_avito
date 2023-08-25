//
//  ProductDetailsFlowFactory.swift
//  test_avito
//
//  Created by Diana Nikulina on 24.08.2023.
//

import UIKit

struct ProductDetailsFlowFactory {
    func productDetailsFlow(
        container: ProductDetailsFlowDependenciesContainer,
        navigationDelegate: ProductDetailsPresenterNavigationDelegate
    ) -> UIViewController {
        let presenter = ProductDetailsPresenter(
            id: container.id,
            imagesProvider: container.imagesProvider,
            navigationDelegate: navigationDelegate
        )
        let viewController = ProductDetailsViewController(
            output: presenter,
            title: container.title
        )
        presenter.input = viewController
        return viewController
    }
}
