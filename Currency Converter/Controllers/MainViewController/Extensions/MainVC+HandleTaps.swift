//
//  MainViewController+HandleTaps.swift
//  Currency Converter
//
//  Created by Dmytro Ivanchuk on 06.10.2022.
//

import Foundation
import UIKit

extension MainViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
        baseCurrencyTextField.layer.borderWidth = 0.0
    }
}
