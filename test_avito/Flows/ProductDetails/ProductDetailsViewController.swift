//
//  ProductDetailsViewController.swift
//  test_avito
//
//  Created by Diana Nikulina on 24.08.2023.
//

import UIKit

protocol ProductDetailsFlowInput: AnyObject {
    func updateUI(with viewModel: ProductDetailsViewModel)
    func showError()
}

final class ProductDetailsViewController: UIViewController {
    
    private let output: ProductDetailsFlowOutput
    
    private lazy var scrollView: UIScrollView = {
        let scrollview = UIScrollView()
        scrollview.frame = view.bounds
        scrollview.contentSize = contentSize
        scrollview.translatesAutoresizingMaskIntoConstraints = false
        return scrollview
    }()
    
    private var contentSize: CGSize {
        CGSize(width: view.frame.width, height: view.frame.height)
    }
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 25)
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 15)
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let locationLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray
        label.font = UIFont.systemFont(ofSize: 15)
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let addressLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray
        label.font = UIFont.systemFont(ofSize: 15)
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var emailButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .red
        button.setTitle("Написать", for: .normal)
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(emailButtonDidTap), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var callButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .blue
        button.setTitle("Позвонить", for: .normal)
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(callButtonDidTap), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let descriptionTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textAlignment = .left
        label.text = "Описание"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray
        label.font = UIFont.systemFont(ofSize: 15)
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let cellerLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textAlignment = .left
        label.text = "Продавец"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 10
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray
        label.font = UIFont.systemFont(ofSize: 15)
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
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
    
    private let activityIndicatorView: UIActivityIndicatorView = {
        let activityIndicatorView = UIActivityIndicatorView(style: .large)
        activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        activityIndicatorView.isHidden = true
        return activityIndicatorView
    }()
    
    init(
        output: ProductDetailsFlowOutput,
        title: String
    ) {
        self.output = output
        super.init(nibName: nil, bundle: nil)
        
        self.title = title
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        changeLoadingState(for: true)
        setupUI()
        
        output.viewDidLoad()
    }
    
    @objc private func callButtonDidTap() {
        output.callButtonDidTap()
    }
    
    @objc private func emailButtonDidTap() {
        output.emailButtonDidTap()
    }
    
    private func setupUI() {
        view.addSubview(scrollView)
        scrollView.addSubview(imageView)
        scrollView.addSubview(priceLabel)
        scrollView.addSubview(titleLabel)
        scrollView.addSubview(locationLabel)
        scrollView.addSubview(addressLabel)
        scrollView.addSubview(descriptionTitleLabel)
        scrollView.addSubview(descriptionLabel)
        scrollView.addSubview(cellerLabel)
        scrollView.addSubview(stackView)
        scrollView.addSubview(dateLabel)
        view.addSubview(activityIndicatorView)
        view.addSubview(errorImageView)
        view.addSubview(errorLabel)
        
        stackView.addArrangedSubview(emailButton)
        stackView.addArrangedSubview(callButton)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            imageView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: imageView.trailingAnchor),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor),
            imageView.widthAnchor.constraint(equalTo: view.widthAnchor),
            
            priceLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 4),
            priceLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            scrollView.trailingAnchor.constraint(equalTo: priceLabel.trailingAnchor, constant: 16),
            
            titleLabel.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: 4),
            titleLabel.leadingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.leadingAnchor, constant: 16),
            scrollView.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 16),
            
            locationLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            locationLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            scrollView.trailingAnchor.constraint(equalTo: locationLabel.trailingAnchor, constant: 16),
            
            addressLabel.topAnchor.constraint(equalTo: locationLabel.bottomAnchor, constant: 2),
            addressLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            scrollView.trailingAnchor.constraint(equalTo: addressLabel.trailingAnchor, constant: 16),
            
            descriptionTitleLabel.topAnchor.constraint(equalTo: addressLabel.bottomAnchor, constant: 10),
            descriptionTitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            view.trailingAnchor.constraint(equalTo: descriptionTitleLabel.trailingAnchor, constant: 16),
            
            descriptionLabel.topAnchor.constraint(equalTo: descriptionTitleLabel.bottomAnchor, constant: 4),
            descriptionLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            scrollView.trailingAnchor.constraint(equalTo: descriptionLabel.trailingAnchor, constant: 16),
            
            cellerLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 10),
            cellerLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            view.trailingAnchor.constraint(equalTo: cellerLabel.trailingAnchor, constant: 16),
            
            stackView.topAnchor.constraint(equalTo: cellerLabel.bottomAnchor, constant: 10),
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            scrollView.frameLayoutGuide.trailingAnchor.constraint(equalTo: stackView.trailingAnchor, constant: 16),
            
            dateLabel.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 4),
            dateLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            scrollView.trailingAnchor.constraint(equalTo: dateLabel.trailingAnchor, constant: 16),
            dateLabel.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            
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
    
    private func changeLoadingState(for isLoading: Bool) {
        activityIndicatorView.isHidden = !isLoading
        scrollView.isHidden = isLoading
        
        if isLoading {
            activityIndicatorView.startAnimating()
        } else {
            activityIndicatorView.stopAnimating()
        }
    }
}

// MARK: - ProductDetailsFlowInput
extension ProductDetailsViewController: ProductDetailsFlowInput {
    func showError() {
        DispatchQueue.main.async {
            self.errorImageView.isHidden = false
            self.errorLabel.isHidden = false
            self.changeLoadingState(for: false)
            self.scrollView.isHidden = true
        }
    }
    
    func updateUI(with viewModel: ProductDetailsViewModel) {
        DispatchQueue.main.async {
            self.titleLabel.text = viewModel.title
            self.priceLabel.text = viewModel.price
            self.locationLabel.text = viewModel.location
            self.addressLabel.text = viewModel.address
            self.descriptionLabel.text = viewModel.description
            self.changeLoadingState(for: false)
        }
        
        output.loadImage(for: viewModel.imageURL) { image in
            DispatchQueue.main.async {
                self.imageView.image = image
            }
        }
    }
}
