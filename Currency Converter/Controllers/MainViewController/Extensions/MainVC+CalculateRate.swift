//
//  MainViewController+CalculateRate.swift
//  Currency Converter
//
//  Created by Dmytro Ivanchuk on 06.10.2022.
//

import Foundation

extension MainViewController {
    func convertCurrency(_ currency: String?, amount: Double?) {
        if let currency = currency, let amount = amount {
            for button in neededForRateCalculation.keys {

                switch currencyOperationSegmentedControl.selectedSegmentIndex {
                case 1:
                    if let additionalBuySellCurrency = buySellRateCurrencies?.first(where: { $0.currencyCode == button.configuration?.title }),
                       let baseBuySellCurrency = buySellRateCurrencies?.first(where: { $0.currencyCode == currency }) {
                        if let additional = additionalBuySellCurrency.sellRate, let base = baseBuySellCurrency.sellRate {
                            let convertedAmount = currencyConverter.convertCurrency(additionalCurrencyRate: additional, baseCurrencyRate: base, amount: amount)
                            neededForRateCalculation[button]?.text = String(format: "%.2f", convertedAmount)
                        }
                    }
                case 2:
                    if let additionalBuySellCurrency = buySellRateCurrencies?.first(where: { $0.currencyCode == button.configuration?.title }),
                       let baseBuySellCurrency = buySellRateCurrencies?.first(where: { $0.currencyCode == currency }) {
                        if let additional = additionalBuySellCurrency.buyRate, let base = baseBuySellCurrency.buyRate {
                            let convertedAmount = currencyConverter.convertCurrency(additionalCurrencyRate: additional, baseCurrencyRate: base, amount: amount)
                            neededForRateCalculation[button]?.text = String(format: "%.2f", convertedAmount)
                        }
                    }
                default:
                    if inHistoricalRatesViewMode {
                        if let additionalMiddleCurrency = middleRateCurrenciesHistorical?.first(where: { $0.currencyCode == button.configuration?.title }),
                           let baseMiddleCurrency = middleRateCurrenciesHistorical?.first(where: { $0.currencyCode == currency }) {
                            if let additional = additionalMiddleCurrency.middleRate, let base = baseMiddleCurrency.middleRate {
                                let convertedAmount = currencyConverter.convertCurrency(additionalCurrencyRate: additional, baseCurrencyRate: base, amount: amount)
                                neededForRateCalculation[button]?.text = String(format: "%.2f", convertedAmount)
                            }
                        }
                    } else {
                        if let additionalMiddleCurrency = middleRateCurrencies?.first(where: { $0.currencyCode == button.configuration?.title }),
                           let baseMiddleCurrency = middleRateCurrencies?.first(where: { $0.currencyCode == currency }) {
                            if let additional = additionalMiddleCurrency.middleRate, let base = baseMiddleCurrency.middleRate {
                                let convertedAmount = currencyConverter.convertCurrency(additionalCurrencyRate: additional, baseCurrencyRate: base, amount: amount)
                                neededForRateCalculation[button]?.text = String(format: "%.2f", convertedAmount)
                            }
                        }
                    }
                }
            }
        } else {
            for button in neededForRateCalculation.keys {
                neededForRateCalculation[button]?.text = ""
            }
        }
    }
}
