//
//  CurrencyViewController.swift
//  Currency Converter
//
//  Created by Dmytro Ivanchuk on 06.10.2022.
//

import Foundation
import UIKit

extension CurrencyViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let currencySections = middleRateCurrencySections {
            let currency = filteredSections.isEmpty ? currencySections[indexPath.section].currencyStrings[indexPath.row] : filteredSections[indexPath.section].currencyStrings[indexPath.row]
            
            didSelectCurrencyCompletionHandler?(String(currency.prefix(3)))
        }
        
        if let currencySections = middleRateCurrencySectionsHistorical {
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
