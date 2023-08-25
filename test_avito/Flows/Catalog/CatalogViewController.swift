//
//  CatalogViewController.swift
//  test_avito
//
//  Created by Diana Nikulina on 24.08.2023.
//

import UIKit

protocol CatalogFlowInput: AnyObject {
    func reloadData()
    func showError()
}

final class CatalogViewController: UIViewController {
    
    private let output: CatalogFlowOutput
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        collectionView.backgroundColor = .white
        collectionView.allowsSelection = true
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(
            CatalogCollectionViewCell.self,
            forCellWithReuseIdentifier: CatalogCollectionViewCell.indentifire
        )
        collectionView.dataSource = self
        collectionView.delegate = self
        return collectionView
    }()
    
    private let activityIndicatorView: UIActivityIndicatorView = {
        let activityIndicatorView = UIActivityIndicatorView(style: .large)
        activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        activityIndicatorView.isHidden = true
        return activityIndicatorView
    }()
    
    private let errorImageView: UIImageView = {
        let errorImageView = UIImageView()
        errorImageView.image = UIImage(named: "error")
        errorImageView.translatesAutoresizingMaskIntoConstraints = false
        errorImageView.isHidden = true
        errorImageView.contentMode = .scaleAspectFit
        return errorImageView
    }()
    
    private let errorLabel: UILabel = {
        let errorLabel = UILabel()
        errorLabel.textColor = .red
        errorLabel.font = UIFont.boldSystemFont(ofSize: 20)
        errorLabel.text = "ERROR"
        errorLabel.translatesAutoresizingMaskIntoConstraints = false
        errorLabel.isHidden = true
        return errorLabel
    }()
    
    init(output: CatalogFlowOutput) {
        self.output = output
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Товары"
        view.backgroundColor = .white
        
        changeLoadingState(for: true)
        setupUI()
        setupBackButton()
        
        output.viewDidLoad()
    }
    
    private func setupBackButton() {
        let backButton = UIBarButtonItem()
        backButton.title = ""
        backButton.tintColor = .black
        navigationItem.backBarButtonItem = backButton
    }
    
    private func setupUI() {
        view.addSubview(collectionView)
        view.addSubview(activityIndicatorView)
        view.addSubview(errorImageView)
        view.addSubview(errorLabel)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            view.bottomAnchor.constraint(equalTo: collectionView.bottomAnchor),
            view.trailingAnchor.constraint(equalTo: collectionView.trailingAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            
            activityIndicatorView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicatorView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            errorImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            errorImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            errorImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            view.trailingAnchor.constraint(equalTo: errorImageView.trailingAnchor, constant: 50),
            
            errorLabel.topAnchor.constraint(equalTo: errorImageView.bottomAnchor),
            errorLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
    }
    
    private func createLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .estimated(200))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .estimated(200))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 2)
        let spacing = CGFloat(20)
        group.interItemSpacing = .fixed(spacing)
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = spacing
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: spacing, bottom: 0, trailing: spacing)
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
    
    private func changeLoadingState(for isLoading: Bool) {
        activityIndicatorView.isHidden = !isLoading
        collectionView.isHidden = isLoading
        
        if isLoading {
            activityIndicatorView.startAnimating()
        } else {
            activityIndicatorView.stopAnimating()
        }
    }
}

// MARK: - UICollectionViewDataSource
extension CatalogViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return output.viewModels.count
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: CatalogCollectionViewCell.indentifire,
                for: indexPath
            ) as? CatalogCollectionViewCell,
            let viewModel = output.viewModels[safe: indexPath.row]
        else {
            return UICollectionViewCell()
        }
        
        cell.configure(with: viewModel)
        output.loadImage(for: viewModel.imageURL) { [weak cell] image in
            DispatchQueue.main.async {
                cell?.image = image
            }
        }
        
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension CatalogViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        output.didSelectItem(at: indexPath.row)
    }
}

// MARK: - CatalogFlowInput
extension CatalogViewController: CatalogFlowInput {
    func reloadData() {
        DispatchQueue.main.async {
            self.collectionView.reloadData()
            self.changeLoadingState(for: false)
        }
    }
    
    func showError() {
        DispatchQueue.main.async {
            self.errorImageView.isHidden = false
            self.errorLabel.isHidden = false
            self.changeLoadingState(for: false)
        }
    }
}
