//
//  MainViewController+AddingCurrencies.swift
//  Currency Converter
//
//  Created by Dmytro Ivanchuk on 06.10.2022.
//

import Foundation
import UIKit

extension MainViewController {
    private func configureAdditionalCurrencyStackView(currency: String) {
        let additionalCurrencyButton = UIButton()
        var confiquration = UIButton.Configuration.plain()
        confiquration.title = currency
        confiquration.image = UIImage(systemName: "chevron.right")
        confiquration.imagePadding = 10.0
        confiquration.imagePlacement = .trailing
        confiquration.preferredSymbolConfigurationForImage = UIImage.SymbolConfiguration(scale: .small)
        confiquration.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { incoming in
            var outgoing = incoming
            outgoing.font = UIFont(name: "Lato-Regular", size: 14)
            return outgoing
        }
        confiquration.baseForegroundColor = UIColor.label
        confiquration.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
        additionalCurrencyButton.configuration = confiquration
        additionalCurrencyButton.contentHorizontalAlignment = .leading
        additionalCurrencyButton.addTarget(self, action: #selector(didTapAddCurrency(_:)), for: .touchUpInside)
        
        let additionalCurrencyTextField = UITextField()
        additionalCurrencyTextField.widthAnchor.constraint(equalToConstant: 206.0).isActive = true
        additionalCurrencyTextField.backgroundColor = .tertiarySystemGroupedBackground
        additionalCurrencyTextField.borderStyle = .none
        additionalCurrencyTextField.layer.cornerRadius = 6.0
        additionalCurrencyTextField.textColor = .systemGray
        additionalCurrencyTextField.font = UIFont(name: "Lato-Regular", size: 14.0)
        additionalCurrencyTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: additionalCurrencyTextField.frame.height))
        additionalCurrencyTextField.leftViewMode = .always
        additionalCurrencyTextField.delegate = self
        
        let deleteCurrencyButton = UIButton()
        var configuration = UIButton.Configuration.plain()
        configuration.baseForegroundColor = .red
        configuration.image = UIImage(systemName: "trash")
        configuration.preferredSymbolConfigurationForImage = UIImage.SymbolConfiguration(scale: .default)
        confiquration.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
        deleteCurrencyButton.configuration = configuration
        deleteCurrencyButton.contentHorizontalAlignment = .trailing
        deleteCurrencyButton.addTarget(self, action: #selector(didTapDeleteCurrency(_:)), for: .touchUpInside)
        additionalCurrencyTextField.rightView = deleteCurrencyButton
        additionalCurrencyTextField.rightViewMode = .always

        
        neededForRateCalculation[additionalCurrencyButton] = additionalCurrencyTextField
        
        
        let additionalCurrencyStackView = UIStackView()
        currencyRatesStackView.addArrangedSubview(additionalCurrencyStackView)
        additionalCurrencyStackView.translatesAutoresizingMaskIntoConstraints = false
        additionalCurrencyStackView.heightAnchor.constraint(equalToConstant: 44.0).isActive = true
        additionalCurrencyStackView.axis = .horizontal
        additionalCurrencyStackView.addArrangedSubview(additionalCurrencyButton)
        additionalCurrencyStackView.addArrangedSubview(additionalCurrencyTextField)
        
        rateCalculationView.constraints.forEach {
            if $0.identifier == "rateCalculationViewHeightConstraint" {
                $0.constant += 60.0
            }
        }
        rateCalculationView.updateConstraints()
        mainScreenContentView.frame.size.height += 60.0
        mainScreenScrollView.contentSize.height += 60.0
    }
    
    @objc func didTapAddCurrency(_ sender: UIButton) {
        var currencyViewController: CurrencyViewController
        
        switch currencyOperationSegmentedControl.selectedSegmentIndex {
        case 0:
            currencyViewController = inHistoricalRatesViewMode ? CurrencyViewController(sections: middleRateCurrencySectionsHistorical) : CurrencyViewController(sections: middleRateCurrencySections)
        default:
            currencyViewController = CurrencyViewController(sections: buySellRateCurrencySections)
        }
        
        switch sender {
        case addCurrencyButton:
            currencyViewController.didSelectCurrencyCompletionHandler = { [weak self] name in
                DispatchQueue.main.async {
                    self?.configureAdditionalCurrencyStackView(currency: name)
                    if let baseCurrency = self?.baseCurrencyButton.configuration?.title, let amount = self?.baseCurrencyTextField.text {
                        self?.convertCurrency(baseCurrency, amount: Double(amount))
                    }
                }
            }
        case baseCurrencyButton:
            currencyViewController.didSelectCurrencyCompletionHandler = { [weak self] name in
                DispatchQueue.main.async {
                    for button in self!.neededForRateCalculation.keys {
                        if button.configuration?.title == name {
                            button.configuration?.title = self?.baseCurrencyButton.configuration?.title
                        }
                    }
                    
                    self?.baseCurrencyButton.configuration?.title = name
                    if let baseCurrency = self?.baseCurrencyButton.configuration?.title, let amount = self?.baseCurrencyTextField.text {
                        self?.convertCurrency(baseCurrency, amount: Double(amount))
                    }
                }
            }
        default:
            currencyViewController.didSelectCurrencyCompletionHandler = { [weak self] name in
                DispatchQueue.main.async {
                    sender.configuration?.title = name
                    if let baseCurrency = self?.baseCurrencyButton.configuration?.title, let amount = self?.baseCurrencyTextField.text {
                        self?.convertCurrency(baseCurrency, amount: Double(amount))
                    }
                }
            }
        }

        let additionalNavigationController = UINavigationController(rootViewController: currencyViewController)
        present(additionalNavigationController, animated: true)
    }
    
    @objc func didTapDeleteCurrency(_ sender: UIButton) {
        for (key, value) in neededForRateCalculation where value == sender.superview {
            self.neededForRateCalculation.removeValue(forKey: key)
        }
        let animator = UIViewPropertyAnimator(duration: 0.5, dampingRatio: 0.6) {
            sender.superview?.superview?.removeFromSuperview()
            self.rateCalculationView.constraints.forEach {
                if $0.identifier == "rateCalculationViewHeightConstraint" {
                    $0.constant -= 60.0
                }
            }
            self.rateCalculationView.updateConstraints()
            self.mainScreenContentView.frame.size.height -= 60.0
            self.mainScreenScrollView.contentSize.height -= 60.0
        }
        animator.startAnimation()
    }
}
