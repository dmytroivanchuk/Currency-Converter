//
//  MainViewController+SegmentChanged.swift
//  Currency Converter
//
//  Created by Dmytro Ivanchuk on 06.10.2022.
//

import Foundation
import UIKit

extension MainViewController {
    @objc func didTapSegment(_ sender: UISegmentedControl) {
        let animator = UIViewPropertyAnimator(duration: 0.5, dampingRatio: 0.6) {
            switch sender.selectedSegmentIndex {
            case 1, 2:
                self.currencyHTTPClient.fetchBuySellRate { [weak self] result in
                    switch result {
                    case .success(let buySellRateModel):
                        for currency in buySellRateModel.currencies {
                            do {
                                try self?.realm.write {
                                    let data = BuySellRateCurrencyData(currencyCode: currency.currencyCode,
                                                                       baseCurrency: currency.baseCurrency,
                                                                       middleRate: nil,
                                                                       buyRate: currency.buyRate,
                                                                       sellRate: currency.sellRate,
                                                                       currencyString: currency.currencyString)
                                    self?.realm.add(data)
                                }
                            } catch {
                                fatalError("Error saving realm data.")
                            }
                        }
                        self?.buySellRateCurrencies = self?.realm.objects(BuySellRateCurrencyData.self)
                        
                        for currencySection in buySellRateModel.currencySections {
                            do {
                                try self?.realm.write {
                                    let data = BuySellRateCurrencySectionData(title: currencySection.title)
                                    for currencyString in currencySection.currencyStrings {
                                        data.currencyStrings.append(currencyString)
                                    }
                                    self?.realm.add(data)
                                }
                            } catch {
                                fatalError("Error saving realm data.")
                            }
                        }
                        self?.buySellRateCurrencySections = self?.realm.objects(BuySellRateCurrencySectionData.self)
                        
                        do {
                            try self?.realm.write {
                                let data = BuySellRateCurrencyDateData(dateUpdated: buySellRateModel.dateUpdated)
                                self?.realm.add(data)
                            }
                        } catch {
                            fatalError("Error saving realm data.")
                        }
                        self?.buySellRateCurrencyDate = self?.realm.objects(BuySellRateCurrencyDateData.self)
                        self?.setTextToUpdateInfoLabel(dateUpdated: self?.buySellRateCurrencyDate?.first?.dateUpdated)
                        
                    case .failure(_):
                        self?.buySellRateCurrencies = self?.realm.objects(BuySellRateCurrencyData.self)
                        self?.buySellRateCurrencySections = self?.realm.objects(BuySellRateCurrencySectionData.self)
                        self?.buySellRateCurrencyDate = self?.realm.objects(BuySellRateCurrencyDateData.self)
                        self?.setTextToUpdateInfoLabel(dateUpdated: self?.buySellRateCurrencyDate?.first?.dateUpdated)
                        print("3")
                    }
                }
                
                self.neededForRateCalculation.removeAll()
                self.currencyRatesStackView.subviews.forEach {
                    $0.subviews.forEach {
                        $0.removeFromSuperview()
                    }
                    $0.removeFromSuperview()
                }
                self.addCurrencyButton.removeFromSuperview()
                self.rateCalculationView.constraints.forEach {
                    if $0.identifier == "rateCalculationViewHeightConstraint" {
                        $0.constant = 326
                    }
                }
                self.rateCalculationView.updateConstraints()
                self.mainScreenScrollView.contentSize = self.view.frame.size
                self.mainScreenContentView.frame.size = self.mainScreenScrollView.frame.size
                self.configureCurrencyRatesStackView()
                self.configureCurrenciesStackViews()
                self.setTextToUpdateInfoLabel(dateUpdated: self.buySellRateCurrencyDate?.first?.dateUpdated)
                if let baseCurrency = self.baseCurrencyButton.configuration?.title, let amount = self.baseCurrencyTextField.text {
                    self.convertCurrency(baseCurrency, amount: Double(amount))
                }
            default:
                self.neededForRateCalculation.removeAll()
                self.currencyRatesStackView.subviews.forEach {
                    $0.subviews.forEach {
                        $0.removeFromSuperview()
                    }
                    $0.removeFromSuperview()
                }
                self.rateCalculationView.constraints.forEach {
                    if $0.identifier == "rateCalculationViewHeightConstraint" {
                        $0.constant = 398
                    }
                }
                self.rateCalculationView.updateConstraints()
                self.configureCurrencyRatesStackView()
                self.configureCurrenciesStackViews()
                self.configureAddCurrencyButton()
                self.setTextToUpdateInfoLabel(dateUpdated: self.middleRateCurrencyDate?.first?.dateUpdated)
                if let baseCurrency = self.baseCurrencyButton.configuration?.title, let amount = self.baseCurrencyTextField.text {
                    self.convertCurrency(baseCurrency, amount: Double(amount))
                }
            }
        }
        animator.startAnimation()
    }
}
