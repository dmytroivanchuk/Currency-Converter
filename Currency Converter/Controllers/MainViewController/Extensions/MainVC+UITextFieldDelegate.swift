//
//  MainViewController+UITextFieldDelegate.swift
//  Currency Converter
//
//  Created by Dmytro Ivanchuk on 06.10.2022.
//

import Foundation
import UIKit

extension MainViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if let input = textField.text {
            if !string.isEmpty {
                if !NSPredicate(format: "SELF MATCHES %@", #"^[\d\.]+"#).evaluate(with: string) {
                    return false
                }
                if input.contains(".") {
                    if input.components(separatedBy: ".")[1].count == 2 {
                        return false
                    }
                }
            }
        }
        return true
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        if let input = textField.text {
            convertCurrency(baseCurrencyButton.configuration?.title, amount: Double(input))
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.layer.borderWidth = 1.0
        textField.layer.borderColor = UIColor.systemBlue.cgColor
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        textField == baseCurrencyTextField ? true : false
    }
}
