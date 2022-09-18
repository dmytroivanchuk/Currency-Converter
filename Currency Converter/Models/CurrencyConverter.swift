//
//  CurrencyConverter.swift
//  Currency Converter
//
//  Created by Dmytro Ivanchuk on 18.09.2022.
//

struct CurrencyConverter {
    func convertCurrency(additionalCurrencyRate additional: Double, baseCurrencyRate base: Double, amount: Double) -> Double {
        additional / base * amount
    }
}
