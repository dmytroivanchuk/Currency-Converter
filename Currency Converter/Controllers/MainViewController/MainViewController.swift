//
//  MainViewController.swift
//  Currency Converter
//
//  Created by Dmytro Ivanchuk on 09.09.2022.
//

import UIKit
import RealmSwift

class MainViewController: UIViewController {
    
    let mainScreenScrollView = UIScrollView()
    let mainScreenContentView = UIView()
    let backgroundImageView = UIImageView()
    let rateCalculationView = UIView()
    let currencyOperationSegmentedControl = UISegmentedControl()
    let currencyRatesStackView = UIStackView()
    let baseCurrencyStackView = UIStackView()
    let baseCurrencyButton = UIButton()
    let baseCurrencyTextField = UITextField()
    let secondCurrencyStackView = UIStackView()
    let thirdCurrencyStackView = UIStackView()
    let addCurrencyButton = UIButton()
    let shareButton = UIButton()
    let updateInfoLabel = UILabel()
    let lastYearRateButton = UIButton()
    
    var neededForRateCalculation: [UIButton: UITextField] = [:]
    var inHistoricalRatesViewMode = false
    let realm = try! Realm()
    
    let currencyHTTPClient = MockHTTPClient()
    let currencyConverter = CurrencyConverter()
    var middleRateCurrencies: Results<MiddleRateCurrencyData>?
    var middleRateCurrenciesHistorical: Results<MiddleRateCurrencyHistoricalData>?
    var buySellRateCurrencies: Results<BuySellRateCurrencyData>?
    var middleRateCurrencySections: Results<MiddleRateCurrencySectionData>?
    var middleRateCurrencySectionsHistorical: Results<MiddleRateCurrencySectionHistoricalData>?
    var buySellRateCurrencySections: Results<BuySellRateCurrencySectionData>?
    var middleRateCurrencyDate: Results<MiddleRateCurrencyDateData>?
    var middleRateCurrencyDateHistorical: Results<MiddleRateCurrencyDateHistoricalData>?
    var buySellRateCurrencyDate: Results<BuySellRateCurrencyDateData>?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        
        configureNavigationItem()
        configureMainScreenScrollView()
        confiqureMainScreenContentView()
        configureBackgroundShapes()
        configureRateCalculationView()
        configureCurrencyOperationSegmentedControl()
        configureCurrencyRatesStackView()
        configureCurrenciesStackViews()
        configureAddCurrencyButton()
        configureShareButton()
        configureUpdateInfoLabel()
        setTextToUpdateInfoLabel(dateUpdated: middleRateCurrencyDate?.first?.dateUpdated)
        configureLastYearRateButton()
        print(realm.configuration.fileURL)
        currencyHTTPClient.fetchMiddleRate { [weak self] result in
            switch result {
            case .success(let middleRateModel):
                for currency in middleRateModel.currencies {
                    do {
                        try self?.realm.write {
                            let data = MiddleRateCurrencyData(currencyCode: currency.currencyCode,
                                                              baseCurrency: currency.baseCurrency,
                                                              middleRate: currency.middleRate,
                                                              buyRate: nil,
                                                              sellRate: nil,
                                                              currencyString: currency.currencyString)
                            self?.realm.add(data)
                        }
                    } catch {
                        fatalError("Error saving realm data.")
                    }
                }
                self?.middleRateCurrencies = self?.realm.objects(MiddleRateCurrencyData.self)
                
                for currencySection in middleRateModel.currencySections {
                    do {
                        try self?.realm.write {
                            let data = MiddleRateCurrencySectionData(title: currencySection.title)
                            for currencyString in currencySection.currencyStrings {
                                data.currencyStrings.append(currencyString)
                            }
                            self?.realm.add(data)
                        }
                    } catch {
                        fatalError("Error saving realm data.")
                    }
                }
                self?.middleRateCurrencySections = self?.realm.objects(MiddleRateCurrencySectionData.self)
                
                do {
                    try self?.realm.write {
                        let data = MiddleRateCurrencyDateData(dateUpdated: middleRateModel.dateUpdated)
                        self?.realm.add(data)
                    }
                } catch {
                    fatalError("Error saving realm data.")
                }
                self?.middleRateCurrencyDate = self?.realm.objects(MiddleRateCurrencyDateData.self)
                self?.setTextToUpdateInfoLabel(dateUpdated: self?.middleRateCurrencyDate?.first?.dateUpdated)
                
            case .failure(_):
                self?.middleRateCurrencies = self?.realm.objects(MiddleRateCurrencyData.self)
                self?.middleRateCurrencySections = self?.realm.objects(MiddleRateCurrencySectionData.self)
                self?.middleRateCurrencyDate = self?.realm.objects(MiddleRateCurrencyDateData.self)
                self?.setTextToUpdateInfoLabel(dateUpdated: self?.middleRateCurrencyDate?.first?.dateUpdated)
                print("1")
            }
        }
    }
}
