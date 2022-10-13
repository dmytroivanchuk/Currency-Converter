//
//  CurrencyViewController.swift
//  Currency Converter
//
//  Created by Dmytro Ivanchuk on 10.09.2022.
//

import UIKit
import RealmSwift

class CurrencyViewController: UIViewController {
    
    let currencySearchBar = UISearchBar()
    let currencyTableView = UITableView(frame: .zero, style: .insetGrouped)
    
    var middleRateCurrencySections: Results<MiddleRateCurrencySectionData>?
    var middleRateCurrencySectionsHistorical: Results<MiddleRateCurrencySectionHistoricalData>?
    var buySellRateCurrencySections: Results<BuySellRateCurrencySectionData>?
    
    var filteredSections: [CurrencySection] = []
    var sectionsIsFilteredWithNoMatches = false
    public var didSelectCurrencyCompletionHandler: ((String) -> Void)?
    
    init(sections: Results<MiddleRateCurrencySectionData>?) {
        middleRateCurrencySections = sections
        super.init(nibName: nil, bundle: nil)
    }
    
    init(sections: Results<MiddleRateCurrencySectionHistoricalData>?) {
        middleRateCurrencySectionsHistorical = sections
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
    
    @objc func dismissSelf() {
        dismiss(animated: true)
    }
}
