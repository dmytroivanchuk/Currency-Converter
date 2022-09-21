//
//  CurrencyViewController.swift
//  Currency Converter
//
//  Created by Dmytro Ivanchuk on 10.09.2022.
//

import UIKit
import RealmSwift

class CurrencyViewController: UIViewController {
    
    private let currencySearchBar = UISearchBar()
    private let currencyTableView = UITableView(frame: .zero, style: .insetGrouped)
    
    private var middleRateCurrencySections: Results<MiddleRateCurrencySectionData>?
    private var buySellRateCurrencySections: Results<BuySellRateCurrencySectionData>?
    
    private var filteredSections: [CurrencySection] = []
    private var sectionsIsFilteredWithNoMatches = false
    public var didSelectCurrencyCompletionHandler: ((String) -> Void)?
    
    init(sections: Results<MiddleRateCurrencySectionData>?) {
        middleRateCurrencySections = sections
        super.init(nibName: nil, bundle: nil)
    }
    
    init(sections: Results<BuySellRateCurrencySectionData>?) {
        buySellRateCurrencySections = sections
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGroupedBackground
        currencySearchBar.delegate = self
        currencyTableView.delegate = self
        currencyTableView.dataSource = self
        configureNavigationItem()
        configureCurrencySearchBar()
        configureCurrencyTableView()
    }
    
    @objc private func dismissSelf() {
        dismiss(animated: true)
    }
    
    
    //MARK: - Confiqure Navigation Item
    
    private func configureNavigationItem() {
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
    
    
    //MARK: - Confiqure UI Elements
    
    private func configureCurrencySearchBar() {
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
    
    private func configureCurrencyTableView() {
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


//MARK: - UITableView Delegate Methods

extension CurrencyViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let currencySections = middleRateCurrencySections {
            let currency = filteredSections.isEmpty ? currencySections[indexPath.section].currencyStrings[indexPath.row] : filteredSections[indexPath.section].currencyStrings[indexPath.row]
            
            didSelectCurrencyCompletionHandler?(String(currency.prefix(3)))
        }
        if let currencySections = buySellRateCurrencySections {
            let currency = filteredSections.isEmpty ? currencySections[indexPath.section].currencyStrings[indexPath.row] : filteredSections[indexPath.section].currencyStrings[indexPath.row]
            
            didSelectCurrencyCompletionHandler?(String(currency.prefix(3)))
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
        dismiss(animated: true)
    }
}


//MARK: - UITableView Data Source Methods

extension CurrencyViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if let currencySections = middleRateCurrencySections {
            if sectionsIsFilteredWithNoMatches {
                return 0
            } else if filteredSections.isEmpty {
                return currencySections.count
            } else {
                return filteredSections.count
            }
        }
        
        if let currencySections = buySellRateCurrencySections {
            if sectionsIsFilteredWithNoMatches {
                return 0
            } else if filteredSections.isEmpty {
                return currencySections.count
            } else {
                return filteredSections.count
            }
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let currencySections = middleRateCurrencySections {
            return filteredSections.isEmpty ? currencySections[section].currencyStrings.count : filteredSections[section].currencyStrings.count
        }
        
        if let currencySections = buySellRateCurrencySections {
            return filteredSections.isEmpty ? currencySections[section].currencyStrings.count : filteredSections[section].currencyStrings.count
        }
        
        return 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        var content = cell.defaultContentConfiguration()
        
        if let currencySections = middleRateCurrencySections {
            let currency = filteredSections.isEmpty ? currencySections[indexPath.section].currencyStrings[indexPath.row] : filteredSections[indexPath.section].currencyStrings[indexPath.row]
            
            content.attributedText = NSMutableAttributedString(string: currency, attributes: [
                NSAttributedString.Key.font: UIFont(name: "Lato-Regular", size: 17)!
            ])
            cell.contentConfiguration = content
        }
        
        if let currencySections = buySellRateCurrencySections {
            let currency = filteredSections.isEmpty ? currencySections[indexPath.section].currencyStrings[indexPath.row] : filteredSections[indexPath.section].currencyStrings[indexPath.row]
            
            content.attributedText = NSMutableAttributedString(string: currency, attributes: [
                NSAttributedString.Key.font: UIFont(name: "Lato-Regular", size: 17)!
            ])
            cell.contentConfiguration = content
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if let currencySections = middleRateCurrencySections {
            return filteredSections.isEmpty ? currencySections[section].title : filteredSections[section].title
        }
        
        if let currencySections = buySellRateCurrencySections {
            return filteredSections.isEmpty ? currencySections[section].title : filteredSections[section].title
        }
        
        return nil
    }
}


//MARK: - UISearchBar Delegate Methods

extension CurrencyViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredSections.removeAll()
        
        if let currencySections = middleRateCurrencySections {
            for section in currencySections {
                let filteredCurrencyStrings = Array(section.currencyStrings.filter { $0.lowercased().contains(searchText.lowercased()) })
                if filteredCurrencyStrings.count != 0 {
                    filteredSections.append(CurrencySection(title: section.title, currencyStrings: filteredCurrencyStrings))
                }
            }
        }
        
        
        sectionsIsFilteredWithNoMatches = !searchText.isEmpty && filteredSections.isEmpty ? true : false
        currencyTableView.reloadData()
    }
}
