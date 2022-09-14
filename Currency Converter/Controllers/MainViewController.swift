//
//  MainViewController.swift
//  Currency Converter
//
//  Created by Dmytro Ivanchuk on 09.09.2022.
//

import UIKit

class MainViewController: UIViewController {
    
    private let mainScreenScrollView = UIScrollView()
    private let mainScreenContentView = UIView()
    private let backgroundImageView = UIImageView()
    private let rateCalculationView = UIView()
    private let currencyOperationSegmentedControl = UISegmentedControl()
    private let currencyRatesStackView = UIStackView()
    private let baseCurrencyStackView = UIStackView()
    private let baseCurrencyButton = UIButton()
    private let baseCurrencyTextField = UITextField()
    private let secondCurrencyStackView = UIStackView()
    private let thirdCurrencyStackView = UIStackView()
    private let addCurrencyButton = UIButton()
    private let shareButton = UIButton()
    private let updateInfoLabel = UILabel()
    private let lastYearRateButton = UIButton()
    
    private let currencyHTTPClient = MockCurrencyHTTPClient()
    private var currencySections = [Section]()
    private var currencyRates = [String: Any]()
    private var neededForRateCalculation = [UIButton: UITextField]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        
        configureNavigationItem()
        configureMainScreenScrollView()
        confiqureMainScreenContentView()
        confiqureBackgroundImageView()
        configureRateCalculationView()
        configureCurrencyOperationSegmentedControl()
        configureCurrencyRatesStackView()
        configureCurrenciesStackViews()
        configureAddCurrencyButton()
        configureShareButton()
        configureUpdateInfoLabel()
        configureLastYearRateButton()
        
        currencyHTTPClient.fetchRate { [weak self] result in
            switch result {
            case .success(let currencyModel):
                self?.currencySections = currencyModel.sections
                self?.currencyRates = currencyModel.ratesDictionary
            case .failure(_):
                print("error")
            }
        }
    }
    
    @objc private func didTapAddCurrency(_ sender: UIButton) {
        let currencyViewController = CurrencyViewController(sections: currencySections)
        
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
    
    
    //MARK: - Confiqure Navigation Item
    
    private func configureNavigationItem() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Currency Converter"
        let appearance = UINavigationBarAppearance()
        appearance.largeTitleTextAttributes = [
            NSAttributedString.Key.font: UIFont(name: "Lato-Black", size: 24)!,
            NSAttributedString.Key.foregroundColor: UIColor.white
        ]
        navigationItem.standardAppearance = appearance
    }

    
    //MARK: - Confiqure UI Elements
    
    private func configureMainScreenScrollView() {
        view.addSubview(mainScreenScrollView)
        mainScreenScrollView.frame = view.bounds
        mainScreenScrollView.backgroundColor = .systemBackground
        mainScreenScrollView.contentSize = view.frame.size
        mainScreenScrollView.contentInsetAdjustmentBehavior = .never
    }
    
    private func confiqureMainScreenContentView() {
        mainScreenScrollView.addSubview(mainScreenContentView)
        mainScreenContentView.frame.size = mainScreenScrollView.frame.size
    }
    
    private func confiqureBackgroundImageView() {
        mainScreenContentView.addSubview(backgroundImageView)
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        backgroundImageView.topAnchor.constraint(equalTo: mainScreenContentView.topAnchor).isActive = true
        backgroundImageView.leadingAnchor.constraint(equalTo: mainScreenContentView.leadingAnchor).isActive = true
        backgroundImageView.trailingAnchor.constraint(equalTo: mainScreenContentView.trailingAnchor).isActive = true
        backgroundImageView.heightAnchor.constraint(equalToConstant: 274.0).isActive = true
        backgroundImageView.image = UIImage(named: "header")
    }
    
    private func configureRateCalculationView() {
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
    
    private func configureCurrencyOperationSegmentedControl() {
        rateCalculationView.addSubview(currencyOperationSegmentedControl)
        currencyOperationSegmentedControl.translatesAutoresizingMaskIntoConstraints = false
        currencyOperationSegmentedControl.topAnchor.constraint(equalTo: rateCalculationView.topAnchor, constant: 16.0).isActive = true
        currencyOperationSegmentedControl.leadingAnchor.constraint(equalTo: rateCalculationView.leadingAnchor, constant: 16.0).isActive = true
        currencyOperationSegmentedControl.trailingAnchor.constraint(equalTo: rateCalculationView.trailingAnchor, constant: -16.0).isActive = true
        currencyOperationSegmentedControl.heightAnchor.constraint(equalToConstant: 44.0).isActive = true
        currencyOperationSegmentedControl.insertSegment(withTitle: "Sell", at: 0, animated: false)
        currencyOperationSegmentedControl.insertSegment(withTitle: "Buy", at: 1, animated: false)
        currencyOperationSegmentedControl.selectedSegmentTintColor = .systemBlue
        currencyOperationSegmentedControl.setTitleTextAttributes([
            NSAttributedString.Key.font: UIFont(name: "Lato-Regular", size: 18)!,
            NSAttributedString.Key.foregroundColor: UIColor.label
        ], for: .normal)
        currencyOperationSegmentedControl.setTitleTextAttributes([
            NSAttributedString.Key.foregroundColor: UIColor.white], for: .selected)
    }
    
    private func configureCurrencyRatesStackView() {
        rateCalculationView.addSubview(currencyRatesStackView)
        currencyRatesStackView.translatesAutoresizingMaskIntoConstraints = false
        currencyRatesStackView.topAnchor.constraint(equalTo: currencyOperationSegmentedControl.bottomAnchor, constant: 40.0).isActive = true
        currencyRatesStackView.leadingAnchor.constraint(equalTo: rateCalculationView.leadingAnchor, constant: 16.0).isActive = true
        currencyRatesStackView.trailingAnchor.constraint(equalTo: rateCalculationView.trailingAnchor, constant: -16.0).isActive = true
        currencyRatesStackView.axis = .vertical
        currencyRatesStackView.spacing = 16.0
        currencyRatesStackView.distribution = .fillEqually
    }
    
    private func configureCurrenciesStackViews() {
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
            $0.addTarget(self, action: #selector(didTapAddCurrency), for: .touchUpInside)
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
        baseCurrencyTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
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
    
    private func configureAddCurrencyButton() {
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
        addCurrencyButton.addTarget(self, action: #selector(didTapAddCurrency), for: .touchUpInside)
    }
    
    private func configureShareButton() {
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
    }
    
    private func configureUpdateInfoLabel() {
        mainScreenContentView.addSubview(updateInfoLabel)
        updateInfoLabel.translatesAutoresizingMaskIntoConstraints = false
        updateInfoLabel.topAnchor.constraint(equalTo: rateCalculationView.bottomAnchor, constant: 16.0).isActive = true
        updateInfoLabel.leadingAnchor.constraint(equalTo: mainScreenContentView.leadingAnchor, constant: 16.0).isActive = true
        updateInfoLabel.trailingAnchor.constraint(equalTo: mainScreenContentView.trailingAnchor, constant: -16.0).isActive = true
        updateInfoLabel.numberOfLines = 0
        updateInfoLabel.font = UIFont(name: "Lato-Regular", size: 12)
        updateInfoLabel.textColor = UIColor(red: 0.342, green: 0.342, blue: 0.342, alpha: 1)
        let titleText = "Last Updated\n22 May 2021 7:03 PM"
        let attrString = NSMutableAttributedString(string: titleText)
        let style = NSMutableParagraphStyle()
        style.lineSpacing = 7.0
        attrString.addAttribute(NSAttributedString.Key.paragraphStyle, value: style, range: NSRange(location: 0, length: titleText.count))
        updateInfoLabel.attributedText = attrString
    }
    
    private func configureLastYearRateButton() {
        mainScreenContentView.addSubview(lastYearRateButton)
        lastYearRateButton.translatesAutoresizingMaskIntoConstraints = false
        lastYearRateButton.topAnchor.constraint(equalTo: rateCalculationView.bottomAnchor, constant: 101.0).isActive = true
        lastYearRateButton.leadingAnchor.constraint(equalTo: mainScreenContentView.leadingAnchor, constant: 16.0).isActive = true
        lastYearRateButton.trailingAnchor.constraint(equalTo: mainScreenContentView.trailingAnchor, constant: -16.0).isActive = true
        lastYearRateButton.heightAnchor.constraint(equalToConstant: 56.0).isActive = true
        var confiquration = UIButton.Configuration.plain()
        confiquration.title = "National Bank Exchange Rate"
        confiquration.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { incoming in
            var outgoing = incoming
            outgoing.font = UIFont(name: "Lato-Bold", size: 18)
            return outgoing
        }
        lastYearRateButton.configuration = confiquration
        lastYearRateButton.layer.borderWidth = 1.0
        lastYearRateButton.layer.borderColor = UIColor.systemBlue.cgColor
        lastYearRateButton.layer.cornerRadius = 14.0
    }
    
    //MARK: - Handle Adding Additional Currencies
    
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
        additionalCurrencyButton.addTarget(self, action: #selector(didTapAddCurrency), for: .touchUpInside)
        
        let additionalCurrencyTextField = UITextField()
        additionalCurrencyTextField.widthAnchor.constraint(equalToConstant: 206.0).isActive = true
        additionalCurrencyTextField.backgroundColor = .tertiarySystemGroupedBackground
        additionalCurrencyTextField.borderStyle = .none
        additionalCurrencyTextField.layer.cornerRadius = 6.0
        additionalCurrencyTextField.isUserInteractionEnabled = false
        additionalCurrencyTextField.textColor = .systemGray
        additionalCurrencyTextField.font = UIFont(name: "Lato-Regular", size: 14.0)
        additionalCurrencyTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: additionalCurrencyTextField.frame.height))
        additionalCurrencyTextField.leftViewMode = .always
        
        let deleteCurrencyButton = UIButton()
        var configuration = UIButton.Configuration.plain()
        configuration.baseForegroundColor = .red
        configuration.image = UIImage(systemName: "trash")
        configuration.preferredSymbolConfigurationForImage = UIImage.SymbolConfiguration(scale: .default)
        confiquration.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
        deleteCurrencyButton.configuration = configuration
        deleteCurrencyButton.contentHorizontalAlignment = .trailing
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
        
        for constraint in rateCalculationView.constraints {
            if constraint.identifier == "rateCalculationViewHeightConstraint" {
                constraint.constant += 60.0
            }
        }
        rateCalculationView.updateConstraints()
        mainScreenContentView.frame.size.height += 60.0
        mainScreenScrollView.contentSize.height += 60.0
    }
    
    
    //MARK: - Handle Rate Calculation
    
    func convertCurrency(_ currency: String, amount: Double?) {
        if let amount = amount {
            for button in neededForRateCalculation.keys {
                let converted = (currencyRates[button.titleLabel!.text!]! as! Double) / (currencyRates[currency]! as! Double) * amount
                neededForRateCalculation[button]?.text = String(format: "%.2f", converted)
            }
        } else {
            for button in neededForRateCalculation.keys {
                neededForRateCalculation[button]?.text = ""
            }
        }
    }
}


//MARK: - UITextField Delegate Methods

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
    
    @objc private func textFieldDidChange(_ textField: UITextField) {
        if let input = textField.text {
            convertCurrency(baseCurrencyButton.titleLabel!.text!, amount: Double(input))
        }
        
        
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.layer.borderWidth = 1.0
        textField.layer.borderColor = UIColor.systemBlue.cgColor
    }
}


//MARK: - Handle Taps When Editing Has Ended

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
