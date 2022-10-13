//
//  UITableViewDataSource.swift
//  Currency Converter
//
//  Created by Dmytro Ivanchuk on 06.10.2022.
//

import Foundation
import UIKit

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
        
        if let currencySections = middleRateCurrencySectionsHistorical {
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
        
        if let currencySections = middleRateCurrencySectionsHistorical {
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
        
        if let currencySections = middleRateCurrencySectionsHistorical {
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
        
        if let currencySections = middleRateCurrencySectionsHistorical {
            return filteredSections.isEmpty ? currencySections[section].title : filteredSections[section].title
        }
        
        if let currencySections = buySellRateCurrencySections {
            return filteredSections.isEmpty ? currencySections[section].title : filteredSections[section].title
        }
        
        return nil
    }
}
