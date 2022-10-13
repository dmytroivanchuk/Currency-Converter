//
//  CurrencyViewController+ConfigureLayout.swift
//  Currency Converter
//
//  Created by Dmytro Ivanchuk on 06.10.2022.
//

import Foundation
import UIKit

extension CurrencyViewController {

    func configureNavigationItem() {
        navigationItem.title = "Currency"
        let backToConverterButton = UIButton(type: .custom)
        var confiquration = UIButton.Configuration.plain()
        confiquration.title = "Converter"
        confiquration.image = UIImage(systemName: "chevron.left")
        confiquration.imagePlacement = .leading
        confiquration.preferredSymbolConfigurationForImage = UIImage.SymbolConfiguration(pointSize: 18.0, weight: .medium)
        confiquration.contentInsets = NSDirectionalEdgeInsets(top: 0.0, leading: 0.0, bottom: 0.0, trailing: 0.0)
        backToConverterButton.configuration = confiquration
        backToConverterButton.addTarget(self, action: #selector(dismissSelf), for: .touchUpInside)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backToConverterButton)
    }
    
    func configureCurrencySearchBar() {
        currencySearchBar.sizeToFit()
        currencySearchBar.searchBarStyle = .minimal
        currencySearchBar.searchTextField.translatesAutoresizingMaskIntoConstraints = false
        currencySearchBar.searchTextField.topAnchor.constraint(equalTo: currencySearchBar.topAnchor, constant: 16.0).isActive = true
        currencySearchBar.searchTextField.leadingAnchor.constraint(equalTo: currencySearchBar.leadingAnchor, constant: 16.0).isActive = true
        currencySearchBar.searchTextField.trailingAnchor.constraint(equalTo: currencySearchBar.trailingAnchor, constant: -16.0).isActive = true
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.08
        currencySearchBar.searchTextField.attributedPlaceholder = NSMutableAttributedString(string: "Search Currency", attributes: [
            NSAttributedString.Key.kern: -0.41,
            NSAttributedString.Key.paragraphStyle: paragraphStyle,
            NSAttributedString.Key.font: UIFont(name: "Lato-Regular", size: 17)!
        ])
    }
    
    func configureCurrencyTableView() {
        view.addSubview(currencyTableView)
        currencyTableView.translatesAutoresizingMaskIntoConstraints = false
        currencyTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        currencyTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        currencyTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        currencyTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        currencyTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        currencyTableView.backgroundColor = .clear
        currencyTableView.layer.shadowColor = UIColor.systemGray4.cgColor
        currencyTableView.layer.shadowOffset = CGSize(width: 0.0, height: 4.0)
        currencyTableView.layer.shadowRadius = 4.0
        currencyTableView.layer.shadowOpacity = 1.0
        currencyTableView.tableHeaderView = currencySearchBar
    }
}
