//
//  Layout.swift
//  Currency Converter
//
//  Created by Dmytro Ivanchuk on 05.10.2022.
//

import Foundation
import UIKit

extension MainViewController {
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
    }
    
    func configureBackgroundShapes() {
        let screenRect = UIScreen.main.bounds
        let screenWidth = screenRect.size.width
        let screenHeight = screenRect.size.height
        
        let rectangle = UIBezierPath(rect: CGRect(x: -0.315 * screenWidth, y: -0.364 * screenHeight, width: 1.432 * screenWidth, height: 0.493 * screenHeight))
        let rectangleShape = CAShapeLayer()
        rectangleShape.path = rectangle.cgPath
        rectangleShape.fillColor = UIColor.systemBlue.cgColor
        mainScreenContentView.layer.addSublayer(rectangleShape)
        
        let firstOval = UIBezierPath(ovalIn: CGRect(x: -0.120 * screenWidth, y: -0.080 * screenHeight, width: 1.240 * screenWidth, height: 0.417 * screenHeight))
        let firstShape = CAShapeLayer()
        firstShape.path = firstOval.cgPath
        firstShape.fillColor = UIColor.systemBlue.cgColor
        mainScreenContentView.layer.addSublayer(firstShape)
        
        let secondOval = UIBezierPath(ovalIn: CGRect(x: -0.240 * screenWidth, y: -0.167 * screenHeight, width: 1.250 * screenWidth, height: 0.431 * screenHeight))
        let secondShape = CAShapeLayer()
        secondShape.path = secondOval.cgPath
        secondShape.fillColor = UIColor(red: 0.102, green: 0.529, blue: 1.000, alpha: 1.000).cgColor
        mainScreenContentView.layer.addSublayer(secondShape)
        
        let thirdOval = UIBezierPath(ovalIn: CGRect(x: -0.315 * screenWidth, y: -0.167 * screenHeight, width: 1.250 * screenWidth, height: 0.431 * screenHeight))
        let thirdShape = CAShapeLayer()
        thirdShape.path = thirdOval.cgPath
        thirdShape.fillColor = UIColor(red: 0.200, green: 0.584, blue: 1.000, alpha: 1.000).cgColor
        mainScreenContentView.layer.addSublayer(thirdShape)
    }
    
    func configureNavigationItem() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Currency Converter"
        let appearance = UINavigationBarAppearance()
        appearance.largeTitleTextAttributes = [
            NSAttributedString.Key.font: UIFont(name: "Lato-Black", size: 24)!,
            NSAttributedString.Key.foregroundColor: UIColor.white
        ]
        navigationItem.standardAppearance = appearance
    }
    
    func configureMainScreenScrollView() {
        view.addSubview(mainScreenScrollView)
        mainScreenScrollView.frame = view.bounds
        mainScreenScrollView.backgroundColor = .systemBackground
        mainScreenScrollView.contentSize = view.frame.size
        mainScreenScrollView.contentInsetAdjustmentBehavior = .never
    }
    
    func confiqureMainScreenContentView() {
        mainScreenScrollView.addSubview(mainScreenContentView)
        mainScreenContentView.frame.size = mainScreenScrollView.frame.size
    }
    
    func configureRateCalculationView() {
        mainScreenContentView.addSubview(rateCalculationView)
        rateCalculationView.translatesAutoresizingMaskIntoConstraints = false
        rateCalculationView.topAnchor.constraint(equalTo: mainScreenContentView.topAnchor, constant: 171.0).isActive = true
        rateCalculationView.leadingAnchor.constraint(equalTo: mainScreenContentView.leadingAnchor, constant: 16.0).isActive = true
        rateCalculationView.trailingAnchor.constraint(equalTo: mainScreenContentView.trailingAnchor, constant: -16.0).isActive = true
        let rateCalculationViewHeightConstraint = rateCalculationView.heightAnchor.constraint(equalToConstant: 398.0)
        rateCalculationViewHeightConstraint.identifier = "rateCalculationViewHeightConstraint"
        rateCalculationViewHeightConstraint.isActive = true
        rateCalculationView.backgroundColor = .systemBackground
        rateCalculationView.layer.cornerRadius = 10.0
        rateCalculationView.layer.borderWidth = 1.0
        rateCalculationView.layer.borderColor = UIColor.systemGray5.cgColor
        rateCalculationView.layer.shadowColor = UIColor.systemGray4.cgColor
        rateCalculationView.layer.shadowOffset = CGSize(width: 0.0, height: 4.0)
        rateCalculationView.layer.shadowRadius = 4.0
        rateCalculationView.layer.shadowOpacity = 1.0
    }
    
    func configureCurrencyOperationSegmentedControl() {
        rateCalculationView.addSubview(currencyOperationSegmentedControl)
        currencyOperationSegmentedControl.translatesAutoresizingMaskIntoConstraints = false
        currencyOperationSegmentedControl.topAnchor.constraint(equalTo: rateCalculationView.topAnchor, constant: 16.0).isActive = true
        currencyOperationSegmentedControl.leadingAnchor.constraint(equalTo: rateCalculationView.leadingAnchor, constant: 16.0).isActive = true
        currencyOperationSegmentedControl.trailingAnchor.constraint(equalTo: rateCalculationView.trailingAnchor, constant: -16.0).isActive = true
        currencyOperationSegmentedControl.heightAnchor.constraint(equalToConstant: 44.0).isActive = true
        currencyOperationSegmentedControl.insertSegment(withTitle: "Middle", at: 0, animated: false)
        currencyOperationSegmentedControl.insertSegment(withTitle: "Sell", at: 1, animated: false)
        currencyOperationSegmentedControl.insertSegment(withTitle: "Buy", at: 2, animated: false)
        currencyOperationSegmentedControl.isEnabledForSegment(at: 0)
        currencyOperationSegmentedControl.selectedSegmentTintColor = .systemBlue
        currencyOperationSegmentedControl.setTitleTextAttributes([
            NSAttributedString.Key.font: UIFont(name: "Lato-Regular", size: 18)!,
            NSAttributedString.Key.foregroundColor: UIColor.label
        ], for: .normal)
        currencyOperationSegmentedControl.setTitleTextAttributes([
            NSAttributedString.Key.foregroundColor: UIColor.white], for: .selected)
        currencyOperationSegmentedControl.selectedSegmentIndex = 0
        currencyOperationSegmentedControl.addTarget(self, action: #selector(didTapSegment(_:)), for: .valueChanged)
    }
    
    func configureCurrencyRatesStackView() {
        rateCalculationView.addSubview(currencyRatesStackView)
        currencyRatesStackView.translatesAutoresizingMaskIntoConstraints = false
        currencyRatesStackView.topAnchor.constraint(equalTo: currencyOperationSegmentedControl.bottomAnchor, constant: 40.0).isActive = true
        currencyRatesStackView.leadingAnchor.constraint(equalTo: rateCalculationView.leadingAnchor, constant: 16.0).isActive = true
        currencyRatesStackView.trailingAnchor.constraint(equalTo: rateCalculationView.trailingAnchor, constant: -16.0).isActive = true
        currencyRatesStackView.axis = .vertical
        currencyRatesStackView.spacing = 16.0
        currencyRatesStackView.distribution = .fillEqually
    }
    
    func configureCurrenciesStackViews() {
        var confiquration = UIButton.Configuration.plain()
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
        
        baseCurrencyButton.configuration = confiquration
        let secondCurrencyButton = UIButton(configuration: confiquration)
        let thirdCurrencyButton = UIButton(configuration: confiquration)
        baseCurrencyButton.configuration?.title = "USD"
        secondCurrencyButton.configuration?.title = "EUR"
        thirdCurrencyButton.configuration?.title = "UAH"
        [baseCurrencyButton, secondCurrencyButton, thirdCurrencyButton].forEach {
            $0.contentHorizontalAlignment = .leading
            $0.addTarget(self, action: #selector(didTapAddCurrency(_:)), for: .touchUpInside)
        }
        
        let secondCurrencyTextField = UITextField()
        let thirdCurrencyTextField = UITextField()
        [baseCurrencyTextField, secondCurrencyTextField, thirdCurrencyTextField].forEach {
            $0.widthAnchor.constraint(equalToConstant: 206.0).isActive = true
            $0.backgroundColor = .tertiarySystemGroupedBackground
            $0.borderStyle = .none
            $0.layer.cornerRadius = 6.0
            $0.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 16.0, height: $0.frame.height))
            $0.leftViewMode = .always
        }
        [secondCurrencyTextField, thirdCurrencyTextField].forEach {
            $0.isUserInteractionEnabled = false
            $0.textColor = .systemGray
            $0.font = UIFont(name: "Lato-Regular", size: 14.0)
        }
        baseCurrencyTextField.textColor = .label
        baseCurrencyTextField.font = UIFont(name: "Lato-Regular", size: 14.0)
        baseCurrencyTextField.keyboardType = .decimalPad
        baseCurrencyTextField.delegate = self
        baseCurrencyTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        baseCurrencyTextField.clearButtonMode = .always
        
        
        neededForRateCalculation[secondCurrencyButton] = secondCurrencyTextField
        neededForRateCalculation[thirdCurrencyButton] = thirdCurrencyTextField
        
        
        
        [baseCurrencyStackView, secondCurrencyStackView, thirdCurrencyStackView].forEach {
            currencyRatesStackView.addArrangedSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.heightAnchor.constraint(equalToConstant: 44.0).isActive = true
            $0.axis = .horizontal
        }
        
        baseCurrencyStackView.addArrangedSubview(baseCurrencyButton)
        baseCurrencyStackView.addArrangedSubview(baseCurrencyTextField)
        secondCurrencyStackView.addArrangedSubview(secondCurrencyButton)
        secondCurrencyStackView.addArrangedSubview(secondCurrencyTextField)
        thirdCurrencyStackView.addArrangedSubview(thirdCurrencyButton)
        thirdCurrencyStackView.addArrangedSubview(thirdCurrencyTextField)
    }
    
    func configureAddCurrencyButton() {
        rateCalculationView.addSubview(addCurrencyButton)
        addCurrencyButton.translatesAutoresizingMaskIntoConstraints = false
        addCurrencyButton.topAnchor.constraint(equalTo: currencyRatesStackView.bottomAnchor, constant: 40.0).isActive = true
        addCurrencyButton.leadingAnchor.constraint(equalTo: rateCalculationView.leadingAnchor, constant: 16.0).isActive = true
        addCurrencyButton.trailingAnchor.constraint(equalTo: rateCalculationView.trailingAnchor, constant: -16.0).isActive = true
        addCurrencyButton.heightAnchor.constraint(equalToConstant: 44.0).isActive = true
        var confiquration = UIButton.Configuration.plain()
        confiquration.title = "Add Currency"
        confiquration.image = UIImage(systemName: "plus.circle.fill")
        confiquration.imagePadding = 6.0
        confiquration.imagePlacement = .leading
        confiquration.preferredSymbolConfigurationForImage = UIImage.SymbolConfiguration(scale: .small)
        confiquration.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { incoming in
            var outgoing = incoming
            outgoing.font = UIFont(name: "Lato-Regular", size: 13)
            return outgoing
        }
        addCurrencyButton.configuration = confiquration
        addCurrencyButton.addTarget(self, action: #selector(didTapAddCurrency(_:)), for: .touchUpInside)
    }
    
    func configureShareButton() {
        rateCalculationView.addSubview(shareButton)
        shareButton.translatesAutoresizingMaskIntoConstraints = false
        shareButton.bottomAnchor.constraint(equalTo: rateCalculationView.bottomAnchor, constant: -4.0).isActive = true
        shareButton.trailingAnchor.constraint(equalTo: rateCalculationView.trailingAnchor, constant: -4.0).isActive = true
        shareButton.heightAnchor.constraint(equalToConstant: 44.0).isActive = true
        shareButton.widthAnchor.constraint(equalToConstant: 44.0).isActive = true
        var confiquration = UIButton.Configuration.plain()
        confiquration.image = UIImage(systemName: "square.and.arrow.up")
        confiquration.preferredSymbolConfigurationForImage = UIImage.SymbolConfiguration(pointSize: 20.0)
        confiquration.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
        confiquration.baseForegroundColor = .systemGray
        shareButton.configuration = confiquration
        shareButton.addTarget(self, action: #selector(shareButtonPressed(_:)), for: .touchUpInside)
    }
    
    func configureUpdateInfoLabel() {
        mainScreenContentView.addSubview(updateInfoLabel)
        updateInfoLabel.translatesAutoresizingMaskIntoConstraints = false
        updateInfoLabel.topAnchor.constraint(equalTo: rateCalculationView.bottomAnchor, constant: 16.0).isActive = true
        updateInfoLabel.leadingAnchor.constraint(equalTo: mainScreenContentView.leadingAnchor, constant: 16.0).isActive = true
        updateInfoLabel.trailingAnchor.constraint(equalTo: mainScreenContentView.trailingAnchor, constant: -16.0).isActive = true
        updateInfoLabel.numberOfLines = 0
        updateInfoLabel.font = UIFont(name: "Lato-Regular", size: 12)
        updateInfoLabel.textColor = UIColor(red: 0.342, green: 0.342, blue: 0.342, alpha: 1)
    }
    
    func configureLastYearRateButton() {
        mainScreenContentView.addSubview(lastYearRateButton)
        lastYearRateButton.translatesAutoresizingMaskIntoConstraints = false
        lastYearRateButton.topAnchor.constraint(equalTo: rateCalculationView.bottomAnchor, constant: 101.0).isActive = true
        lastYearRateButton.leadingAnchor.constraint(equalTo: mainScreenContentView.leadingAnchor, constant: 16.0).isActive = true
        lastYearRateButton.trailingAnchor.constraint(equalTo: mainScreenContentView.trailingAnchor, constant: -16.0).isActive = true
        lastYearRateButton.heightAnchor.constraint(equalToConstant: 56.0).isActive = true
        var confiquration = UIButton.Configuration.plain()
        confiquration.title = "Last Year Exchange Rates"
        confiquration.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { incoming in
            var outgoing = incoming
            outgoing.font = UIFont(name: "Lato-Bold", size: 18)
            return outgoing
        }
        lastYearRateButton.configuration = confiquration
        lastYearRateButton.layer.borderWidth = 1.0
        lastYearRateButton.layer.borderColor = UIColor.systemBlue.cgColor
        lastYearRateButton.layer.cornerRadius = 14.0
        lastYearRateButton.addTarget(self, action: #selector(didTapLastYearRateButton(_:)), for: .touchUpInside)
    }
    
    func setTextToUpdateInfoLabel(dateUpdated: Date?) {
        if let date = dateUpdated {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "d MMMM yyyy HH:mm"
            let dateFormatted = dateFormatter.string(from: date)
            
            let titleText = "Last Updated\n\(dateFormatted)"
            let attrString = NSMutableAttributedString(string: titleText)
            let style = NSMutableParagraphStyle()
            style.lineSpacing = 7.0
            attrString.addAttribute(NSAttributedString.Key.paragraphStyle, value: style, range: NSRange(location: 0, length: titleText.count))
            updateInfoLabel.attributedText = attrString
        } else {
            updateInfoLabel.text = "Last Updated\n"
        }
    }
}
