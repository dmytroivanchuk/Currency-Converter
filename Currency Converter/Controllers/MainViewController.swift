//
//  MainViewController.swift
//  Currency Converter
//
//  Created by Dmytro Ivanchuk on 09.09.2022.
//

import UIKit
import RealmSwift

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
    
    private let currencyHTTPClient = MockHTTPClient()
    private let currencyConverter = CurrencyConverter()
    private var middleRateCurrencies: Results<MiddleRateCurrencyData>?
    private var middleRateCurrenciesHistorical: Results<MiddleRateCurrencyHistoricalData>?
    private var buySellRateCurrencies: Results<BuySellRateCurrencyData>?
    private var middleRateCurrencySections: Results<MiddleRateCurrencySectionData>?
    private var middleRateCurrencySectionsHistorical: Results<MiddleRateCurrencySectionHistoricalData>?
    private var buySellRateCurrencySections: Results<BuySellRateCurrencySectionData>?
    private var middleRateCurrencyDate: Results<MiddleRateCurrencyDateData>?
    private var middleRateCurrencyDateHistorical: Results<MiddleRateCurrencyDateHistoricalData>?
    private var buySellRateCurrencyDate: Results<BuySellRateCurrencyDateData>?
    private var neededForRateCalculation: [UIButton: UITextField] = [:]
    private var inHistoricalRatesViewMode = false
    private let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        
        configureNavigationItem()
        configureMainScreenScrollView()
        confiqureMainScreenContentView()
        configureBackgroundShapes()
        configureRateCalculationView()
        configureCurrencyOperationSegmentedControl()
        configureCurrencyRatesStackView()
        configureCurrenciesStackViews()
        configureAddCurrencyButton()
        configureShareButton()
        configureUpdateInfoLabel()
        configureLastYearRateButton()
        print(realm.configuration.fileURL)
        currencyHTTPClient.fetchMiddleRate { [weak self] result in
            switch result {
            case .success(let middleRateModel):
                for currency in middleRateModel.currencies {
                    do {
                        try self?.realm.write {
                            let data = MiddleRateCurrencyData(currencyCode: currency.currencyCode,
                                                              baseCurrency: currency.baseCurrency,
                                                              middleRate: currency.middleRate,
                                                              buyRate: nil,
                                                              sellRate: nil,
                                                              currencyString: currency.currencyString)
                            self?.realm.add(data)
                        }
                    } catch {
                        fatalError("Error saving realm data.")
                    }
                }
                self?.middleRateCurrencies = self?.realm.objects(MiddleRateCurrencyData.self)
                
                for currencySection in middleRateModel.currencySections {
                    do {
                        try self?.realm.write {
                            let data = MiddleRateCurrencySectionData(title: currencySection.title)
                            for currencyString in currencySection.currencyStrings {
                                data.currencyStrings.append(currencyString)
                            }
                            self?.realm.add(data)
                        }
                    } catch {
                        fatalError("Error saving realm data.")
                    }
                }
                self?.middleRateCurrencySections = self?.realm.objects(MiddleRateCurrencySectionData.self)
                
                do {
                    try self?.realm.write {
                        let data = MiddleRateCurrencyDateData(dateUpdated: middleRateModel.dateUpdated)
                        self?.realm.add(data)
                    }
                } catch {
                    fatalError("Error saving realm data.")
                }
                self?.middleRateCurrencyDate = self?.realm.objects(MiddleRateCurrencyDateData.self)
                self?.setTitleToUpdateInfoLabel(dateUpdated: self?.middleRateCurrencyDate?.first?.dateUpdated)
                
            case .failure(_):
                self?.middleRateCurrencies = self?.realm.objects(MiddleRateCurrencyData.self)
                self?.middleRateCurrencySections = self?.realm.objects(MiddleRateCurrencySectionData.self)
                self?.middleRateCurrencyDate = self?.realm.objects(MiddleRateCurrencyDateData.self)
                self?.setTitleToUpdateInfoLabel(dateUpdated: self?.middleRateCurrencyDate?.first?.dateUpdated)
                print("1")
            }
        }
    }
    
    private func setTitleToUpdateInfoLabel(dateUpdated: Date?) {
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
        }
        
            
    }
    
    @objc private func didTapSegment(_ sender: UISegmentedControl) {
        let animator = UIViewPropertyAnimator(duration: 0.5, dampingRatio: 0.6) {
            switch sender.selectedSegmentIndex {
            case 1, 2:
                self.currencyHTTPClient.fetchBuySellRate { [weak self] result in
                    switch result {
                    case .success(let buySellRateModel):
                        for currency in buySellRateModel.currencies {
                            do {
                                try self?.realm.write {
                                    let data = BuySellRateCurrencyData(currencyCode: currency.currencyCode,
                                                                       baseCurrency: currency.baseCurrency,
                                                                       middleRate: nil,
                                                                       buyRate: currency.buyRate,
                                                                       sellRate: currency.sellRate,
                                                                       currencyString: currency.currencyString)
                                    self?.realm.add(data)
                                }
                            } catch {
                                fatalError("Error saving realm data.")
                            }
                        }
                        self?.buySellRateCurrencies = self?.realm.objects(BuySellRateCurrencyData.self)
                        
                        for currencySection in buySellRateModel.currencySections {
                            do {
                                try self?.realm.write {
                                    let data = BuySellRateCurrencySectionData(title: currencySection.title)
                                    for currencyString in currencySection.currencyStrings {
                                        data.currencyStrings.append(currencyString)
                                    }
                                    self?.realm.add(data)
                                }
                            } catch {
                                fatalError("Error saving realm data.")
                            }
                        }
                        self?.buySellRateCurrencySections = self?.realm.objects(BuySellRateCurrencySectionData.self)
                        
                        do {
                            try self?.realm.write {
                                let data = BuySellRateCurrencyDateData(dateUpdated: buySellRateModel.dateUpdated)
                                self?.realm.add(data)
                            }
                        } catch {
                            fatalError("Error saving realm data.")
                        }
                        self?.buySellRateCurrencyDate = self?.realm.objects(BuySellRateCurrencyDateData.self)
                        self?.setTitleToUpdateInfoLabel(dateUpdated: self?.buySellRateCurrencyDate?.first?.dateUpdated)
                        
                    case .failure(_):
                        self?.buySellRateCurrencies = self?.realm.objects(BuySellRateCurrencyData.self)
                        self?.buySellRateCurrencySections = self?.realm.objects(BuySellRateCurrencySectionData.self)
                        self?.buySellRateCurrencyDate = self?.realm.objects(BuySellRateCurrencyDateData.self)
                        self?.setTitleToUpdateInfoLabel(dateUpdated: self?.buySellRateCurrencyDate?.first?.dateUpdated)
                        print("3")
                    }
                }
                
                self.neededForRateCalculation.removeAll()
                self.currencyRatesStackView.subviews.forEach {
                    $0.subviews.forEach {
                        $0.removeFromSuperview()
                    }
                    $0.removeFromSuperview()
                }
                self.addCurrencyButton.removeFromSuperview()
                self.rateCalculationView.constraints.forEach {
                    if $0.identifier == "rateCalculationViewHeightConstraint" {
                        $0.constant = 326
                    }
                }
                self.rateCalculationView.updateConstraints()
                self.mainScreenScrollView.contentSize = self.view.frame.size
                self.mainScreenContentView.frame.size = self.mainScreenScrollView.frame.size
                self.configureCurrencyRatesStackView()
                self.configureCurrenciesStackViews()
                self.setTitleToUpdateInfoLabel(dateUpdated: self.buySellRateCurrencyDate?.first?.dateUpdated)
                if let baseCurrency = self.baseCurrencyButton.configuration?.title, let amount = self.baseCurrencyTextField.text {
                    self.convertCurrency(baseCurrency, amount: Double(amount))
                }
            default:
                self.neededForRateCalculation.removeAll()
                self.currencyRatesStackView.subviews.forEach {
                    $0.subviews.forEach {
                        $0.removeFromSuperview()
                    }
                    $0.removeFromSuperview()
                }
                self.rateCalculationView.constraints.forEach {
                    if $0.identifier == "rateCalculationViewHeightConstraint" {
                        $0.constant = 398
                    }
                }
                self.rateCalculationView.updateConstraints()
                self.configureCurrencyRatesStackView()
                self.configureCurrenciesStackViews()
                self.configureAddCurrencyButton()
                self.setTitleToUpdateInfoLabel(dateUpdated: self.middleRateCurrencyDate?.first?.dateUpdated)
                if let baseCurrency = self.baseCurrencyButton.configuration?.title, let amount = self.baseCurrencyTextField.text {
                    self.convertCurrency(baseCurrency, amount: Double(amount))
                }
            }
        }
        animator.startAnimation()
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
    
    private func configureBackgroundShapes() {
        let rectangle = UIBezierPath(rect: CGRect(x: -118.0, y: -295.5, width: 537.0, height: 400.0))
        let rectangleShape = CAShapeLayer()
        rectangleShape.path = rectangle.cgPath
        rectangleShape.fillColor = UIColor.systemBlue.cgColor
        mainScreenContentView.layer.addSublayer(rectangleShape)
        
        let firstOval = UIBezierPath(ovalIn: CGRect(x: -45.0, y: -65.0, width: 465.0, height: 339.0))
        let firstShape = CAShapeLayer()
        firstShape.path = firstOval.cgPath
        firstShape.fillColor = UIColor.systemBlue.cgColor
        mainScreenContentView.layer.addSublayer(firstShape)
        
        let secondOval = UIBezierPath(ovalIn: CGRect(x: -90.0, y: -136.0, width: 468.62, height: 349.65))
        let secondShape = CAShapeLayer()
        secondShape.path = secondOval.cgPath
        secondShape.fillColor = UIColor(red: 0.102, green: 0.529, blue: 1.000, alpha: 1.000).cgColor
        mainScreenContentView.layer.addSublayer(secondShape)
        
        let thirdOval = UIBezierPath(ovalIn: CGRect(x: -118.0, y: -136.0, width: 468.62, height: 349.65))
        let thirdShape = CAShapeLayer()
        thirdShape.path = thirdOval.cgPath
        thirdShape.fillColor = UIColor(red: 0.200, green: 0.584, blue: 1.000, alpha: 1.000).cgColor
        mainScreenContentView.layer.addSublayer(thirdShape)
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
        addCurrencyButton.addTarget(self, action: #selector(didTapAddCurrency(_:)), for: .touchUpInside)
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
        
        if let dateUpdated = middleRateCurrencyDate?.first?.dateUpdated {
            let titleText = "Last Updated\n\(dateUpdated)"
            let attrString = NSMutableAttributedString(string: titleText)
            let style = NSMutableParagraphStyle()
            style.lineSpacing = 7.0
            attrString.addAttribute(NSAttributedString.Key.paragraphStyle, value: style, range: NSRange(location: 0, length: titleText.count))
            updateInfoLabel.attributedText = attrString
        } else {
            updateInfoLabel.text = "Last Updated\n"
        }
        
    }
    
    private func configureLastYearRateButton() {
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
    
    @objc private func didTapAddCurrency(_ sender: UIButton) {
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
    
    
    //MARK: - Handle Deleting Additional Currencies
    
    @objc private func didTapDeleteCurrency(_ sender: UIButton) {
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
    
    
    //MARK: - Handle Fetching Historical Rate

    @objc private func didTapLastYearRateButton(_ sender: UIButton) {
        self.inHistoricalRatesViewMode = !self.inHistoricalRatesViewMode
        
        if inHistoricalRatesViewMode {
            
            currencyHTTPClient.fetchMiddleRateHistorical { [weak self] result in
                switch result {
                case .success(let middleRateHistoricalModel):
                    for currency in middleRateHistoricalModel.currencies {
                        do {
                            try self?.realm.write {
                                let data = MiddleRateCurrencyHistoricalData(currencyCode: currency.currencyCode,
                                                                  baseCurrency: currency.baseCurrency,
                                                                  middleRate: currency.middleRate,
                                                                  buyRate: nil,
                                                                  sellRate: nil,
                                                                  currencyString: currency.currencyString)
                                self?.realm.add(data)
                            }
                        } catch {
                            fatalError("Error saving realm data.")
                        }
                    }
                    self?.middleRateCurrenciesHistorical = self?.realm.objects(MiddleRateCurrencyHistoricalData.self)
                    
                    for currencySection in middleRateHistoricalModel.currencySections {
                        do {
                            try self?.realm.write {
                                let data = MiddleRateCurrencySectionHistoricalData(title: currencySection.title)
                                for currencyString in currencySection.currencyStrings {
                                    data.currencyStrings.append(currencyString)
                                }
                                self?.realm.add(data)
                            }
                        } catch {
                            fatalError("Error saving realm data.")
                        }
                    }
                    self?.middleRateCurrencySectionsHistorical = self?.realm.objects(MiddleRateCurrencySectionHistoricalData.self)
                    
                    do {
                        try self?.realm.write {
                            let data = MiddleRateCurrencyDateHistoricalData(dateUpdated: middleRateHistoricalModel.dateUpdated)
                            self?.realm.add(data)
                        }
                    } catch {
                        fatalError("Error saving realm data.")
                    }
                    self?.middleRateCurrencyDateHistorical = self?.realm.objects(MiddleRateCurrencyDateHistoricalData.self)
                    self?.setTitleToUpdateInfoLabel(dateUpdated: self?.middleRateCurrencyDateHistorical?.first?.dateUpdated)
                    
                case .failure(_):
                    print(2)
                    print(self?.realm.objects(MiddleRateCurrencyDateHistoricalData.self))
                    self?.middleRateCurrenciesHistorical = self?.realm.objects(MiddleRateCurrencyHistoricalData.self)
                    self?.middleRateCurrencySectionsHistorical = self?.realm.objects(MiddleRateCurrencySectionHistoricalData.self)
                    self?.middleRateCurrencyDateHistorical = self?.realm.objects(MiddleRateCurrencyDateHistoricalData.self)
                    self?.setTitleToUpdateInfoLabel(dateUpdated: self?.middleRateCurrencyDateHistorical?.first?.dateUpdated)
                }
            }
            
            self.lastYearRateButton.configuration?.title = "Back to Latest Exchange Rates"
            self.currencyOperationSegmentedControl.removeSegment(at: 2, animated: true)
            self.currencyOperationSegmentedControl.removeSegment(at: 1, animated: true)
            if let baseCurrency = self.baseCurrencyButton.configuration?.title, let amount = self.baseCurrencyTextField.text {
                self.convertCurrency(baseCurrency, amount: Double(amount))
            }
        } else {
            self.lastYearRateButton.configuration?.title = "Last Year Exchange Rates"
            currencyOperationSegmentedControl.insertSegment(withTitle: "Sell", at: 1, animated: true)
            currencyOperationSegmentedControl.insertSegment(withTitle: "Buy", at: 2, animated: true)
            self.setTitleToUpdateInfoLabel(dateUpdated: self.middleRateCurrencyDate?.first?.dateUpdated)
            if let baseCurrency = self.baseCurrencyButton.configuration?.title, let amount = self.baseCurrencyTextField.text {
                self.convertCurrency(baseCurrency, amount: Double(amount))
            }
        }
    }
    
    
    //MARK: - Handle Rate Calculation
    
    private func convertCurrency(_ currency: String?, amount: Double?) {
        if let currency = currency, let amount = amount {
            for button in neededForRateCalculation.keys {

                switch currencyOperationSegmentedControl.selectedSegmentIndex {
                case 1:
                    if let additionalBuySellCurrency = buySellRateCurrencies?.first(where: { $0.currencyCode == button.configuration?.title }),
                       let baseBuySellCurrency = buySellRateCurrencies?.first(where: { $0.currencyCode == currency }) {
                        if let additional = additionalBuySellCurrency.sellRate, let base = baseBuySellCurrency.sellRate {
                            let convertedAmount = currencyConverter.convertCurrency(additionalCurrencyRate: additional, baseCurrencyRate: base, amount: amount)
                            neededForRateCalculation[button]?.text = String(format: "%.2f", convertedAmount)
                        }
                    }
                case 2:
                    if let additionalBuySellCurrency = buySellRateCurrencies?.first(where: { $0.currencyCode == button.configuration?.title }),
                       let baseBuySellCurrency = buySellRateCurrencies?.first(where: { $0.currencyCode == currency }) {
                        if let additional = additionalBuySellCurrency.buyRate, let base = baseBuySellCurrency.buyRate {
                            let convertedAmount = currencyConverter.convertCurrency(additionalCurrencyRate: additional, baseCurrencyRate: base, amount: amount)
                            neededForRateCalculation[button]?.text = String(format: "%.2f", convertedAmount)
                        }
                    }
                default:
                    if inHistoricalRatesViewMode {
                        if let additionalMiddleCurrency = middleRateCurrenciesHistorical?.first(where: { $0.currencyCode == button.configuration?.title }),
                           let baseMiddleCurrency = middleRateCurrenciesHistorical?.first(where: { $0.currencyCode == currency }) {
                            if let additional = additionalMiddleCurrency.middleRate, let base = baseMiddleCurrency.middleRate {
                                let convertedAmount = currencyConverter.convertCurrency(additionalCurrencyRate: additional, baseCurrencyRate: base, amount: amount)
                                neededForRateCalculation[button]?.text = String(format: "%.2f", convertedAmount)
                            }
                        }
                    } else {
                        if let additionalMiddleCurrency = middleRateCurrencies?.first(where: { $0.currencyCode == button.configuration?.title }),
                           let baseMiddleCurrency = middleRateCurrencies?.first(where: { $0.currencyCode == currency }) {
                            if let additional = additionalMiddleCurrency.middleRate, let base = baseMiddleCurrency.middleRate {
                                let convertedAmount = currencyConverter.convertCurrency(additionalCurrencyRate: additional, baseCurrencyRate: base, amount: amount)
                                neededForRateCalculation[button]?.text = String(format: "%.2f", convertedAmount)
                            }
                        }
                    }
                }
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
