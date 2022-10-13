//
//  MainViewController+FetchHistorical.swift
//  Currency Converter
//
//  Created by Dmytro Ivanchuk on 06.10.2022.
//

import Foundation
import UIKit

extension MainViewController {
    @objc func didTapLastYearRateButton(_ sender: UIButton) {
        self.inHistoricalRatesViewMode = !self.inHistoricalRatesViewMode
        
        if inHistoricalRatesViewMode {
            
            currencyHTTPClient.fetchMiddleRateHistorical { [weak self] result in
                switch result {
                case .success(let middleRateHistoricalModel):
                    for currency in middleRateHistoricalModel.currencies {
                        do {
                            try self?.realm.write {
                                let data = MiddleRateCurrencyHistoricalData(currencyCode: currency.currencyCode,
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
                    self?.middleRateCurrenciesHistorical = self?.realm.objects(MiddleRateCurrencyHistoricalData.self)
                    
                    for currencySection in middleRateHistoricalModel.currencySections {
                        do {
                            try self?.realm.write {
                                let data = MiddleRateCurrencySectionHistoricalData(title: currencySection.title)
                                for currencyString in currencySection.currencyStrings {
                                    data.currencyStrings.append(currencyString)
                                }
                                self?.realm.add(data)
                            }
                        } catch {
                            fatalError("Error saving realm data.")
                        }
                    }
                    self?.middleRateCurrencySectionsHistorical = self?.realm.objects(MiddleRateCurrencySectionHistoricalData.self)
                    
                    do {
                        try self?.realm.write {
                            let data = MiddleRateCurrencyDateHistoricalData(dateUpdated: middleRateHistoricalModel.dateUpdated)
                            self?.realm.add(data)
                        }
                    } catch {
                        fatalError("Error saving realm data.")
                    }
                    self?.middleRateCurrencyDateHistorical = self?.realm.objects(MiddleRateCurrencyDateHistoricalData.self)
                    self?.setTextToUpdateInfoLabel(dateUpdated: self?.middleRateCurrencyDateHistorical?.first?.dateUpdated)
                    
                case .failure(_):
                    print(2)
                    print(self?.realm.objects(MiddleRateCurrencyDateHistoricalData.self))
                    self?.middleRateCurrenciesHistorical = self?.realm.objects(MiddleRateCurrencyHistoricalData.self)
                    self?.middleRateCurrencySectionsHistorical = self?.realm.objects(MiddleRateCurrencySectionHistoricalData.self)
                    self?.middleRateCurrencyDateHistorical = self?.realm.objects(MiddleRateCurrencyDateHistoricalData.self)
                    self?.setTextToUpdateInfoLabel(dateUpdated: self?.middleRateCurrencyDateHistorical?.first?.dateUpdated)
                }
            }
            
            self.lastYearRateButton.configuration?.title = "Back to Latest Exchange Rates"
            self.currencyOperationSegmentedControl.removeSegment(at: 2, animated: true)
            self.currencyOperationSegmentedControl.removeSegment(at: 1, animated: true)
            if let baseCurrency = self.baseCurrencyButton.configuration?.title, let amount = self.baseCurrencyTextField.text {
                self.convertCurrency(baseCurrency, amount: Double(amount))
            }
        } else {
            self.lastYearRateButton.configuration?.title = "Last Year Exchange Rates"
            currencyOperationSegmentedControl.insertSegment(withTitle: "Sell", at: 1, animated: true)
            currencyOperationSegmentedControl.insertSegment(withTitle: "Buy", at: 2, animated: true)
            self.setTextToUpdateInfoLabel(dateUpdated: self.middleRateCurrencyDate?.first?.dateUpdated)
            if let baseCurrency = self.baseCurrencyButton.configuration?.title, let amount = self.baseCurrencyTextField.text {
                self.convertCurrency(baseCurrency, amount: Double(amount))
            }
        }
    }
}
