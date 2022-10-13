//
//  UISearchBarDelegate.swift
//  Currency Converter
//
//  Created by Dmytro Ivanchuk on 06.10.2022.
//

import Foundation
import UIKit

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
        
        if let currencySections = middleRateCurrencySectionsHistorical {
            for section in currencySections {
                let filteredCurrencyStrings = Array(section.currencyStrings.filter { $0.lowercased().contains(searchText.lowercased()) })
                if filteredCurrencyStrings.count != 0 {
                    filteredSections.append(CurrencySection(title: section.title, currencyStrings: filteredCurrencyStrings))
                }
            }
        }
        
        if let currencySections = buySellRateCurrencySections {
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
