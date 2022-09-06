//
//  ViewController.swift
//  Currency Converter
//
//  Created by Dmytro Ivanchuk on 05.09.2022.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var rateView: UIView!
    @IBOutlet var sellBuySegmentedControl: UISegmentedControl!
    @IBOutlet var firstCurrencyButton: UIButton!
    @IBOutlet var secondCurrencyButton: UIButton!
    @IBOutlet var thirdCurrencyButton: UIButton!
    @IBOutlet var firstCurrencyTextField: UITextField!
    @IBOutlet var secondCurrencyTextField: UITextField!
    @IBOutlet var thirdCurrencyTextField: UITextField!
    @IBOutlet var addCurrencyButton: UIButton!
    @IBOutlet var shareButton: UIButton!
    @IBOutlet var updateInfoLabel: UILabel!
    @IBOutlet var lastYearRateButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Currency Converter"
        let appearance = UINavigationBarAppearance()
        appearance.largeTitleTextAttributes = [
            NSAttributedString.Key.font: UIFont(name: "Lato-Black", size: 24)!,
            NSAttributedString.Key.foregroundColor: UIColor.white
        ]
        navigationItem.standardAppearance = appearance
        
        configureRateView()
        configureSellBuySegmentedControl()
        configureCurrencyButtons()
        configureCurrencyTextFields()
        configureAddCurrencyButton()
        configureShareButton()
        configureUpdateInfoLabel()
        configureLastYearRateButton()
    }
    
    private func configureRateView() {
        rateView.backgroundColor = .systemBackground
        rateView.layer.cornerRadius = 10.0
        rateView.layer.borderWidth = 1.0
        rateView.layer.borderColor = UIColor.systemGray5.cgColor
        rateView.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.15).cgColor
        rateView.layer.shadowOffset = CGSize(width: 0, height: 4)
        rateView.layer.shadowRadius = 4
        rateView.layer.shadowOpacity = 1
    }
    
    private func configureSellBuySegmentedControl() {
        sellBuySegmentedControl.setTitle("Sell", forSegmentAt: 0)
        sellBuySegmentedControl.setTitle("Buy", forSegmentAt: 1)
        sellBuySegmentedControl.selectedSegmentTintColor = .systemBlue
        sellBuySegmentedControl.setTitleTextAttributes([
            NSAttributedString.Key.font: UIFont(name: "Lato-Regular", size: 18)!,
            NSAttributedString.Key.foregroundColor: UIColor(red: 0, green: 0.191, blue: 0.4, alpha: 1)
        ], for: .normal)
        sellBuySegmentedControl.setTitleTextAttributes([
            NSAttributedString.Key.foregroundColor: UIColor.white], for: .selected)
    }
    
    private func configureCurrencyButtons() {
        var confiquration = UIButton.Configuration.plain()
        confiquration.image = UIImage(systemName: "chevron.right")
        confiquration.imagePadding = 5
        confiquration.imagePlacement = .trailing
        confiquration.preferredSymbolConfigurationForImage = UIImage.SymbolConfiguration(scale: .medium)
        confiquration.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { incoming in
            var outgoing = incoming
            outgoing.font = UIFont(name: "Lato-Regular", size: 14)
            return outgoing
        }
        confiquration.baseForegroundColor = UIColor(red: 0, green: 0.191, blue: 0.4, alpha: 1)
        confiquration.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
        
        [firstCurrencyButton, secondCurrencyButton, thirdCurrencyButton].forEach {
            $0?.contentHorizontalAlignment = .left
            $0?.configuration = confiquration
        }
        
        firstCurrencyButton.configuration?.title = "UAH"
        secondCurrencyButton.configuration?.title = "USD"
        thirdCurrencyButton.configuration?.title = "EUR"
    }
    
    private func configureCurrencyTextFields() {
        
    }
    
    private func configureAddCurrencyButton() {
        
    }
    
    private func configureShareButton() {
        
    }
    
    private func configureUpdateInfoLabel() {
        
    }
    
    private func configureLastYearRateButton() {
        
    }
}

