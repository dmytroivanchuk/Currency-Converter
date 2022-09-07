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
    
    let currencyHTTPClient = MockCurrencyHTTPClient()
    var sections = [Section]()
    
    @IBAction func addCurrencyButtonPressed(_ sender: UIButton) {
        let addCurrencyViewController = AddCurrencyViewController()
        addCurrencyViewController.sections = sections
        let navController = UINavigationController(rootViewController: addCurrencyViewController) // Creating a navigation controller with VC1 at the root of the navigation stack.
        self.present(navController, animated:true, completion: nil)
    }
    
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
        
        currencyHTTPClient.fetchRate { result in
            switch result {
            case .success(let currencyModel):
                self.sections = currencyModel.sections
            case .failure(_):
                print("error")
            }
        }
    }
    
    private func configureRateView() {
        rateView.backgroundColor = .systemBackground
        rateView.layer.cornerRadius = 10.0
        rateView.layer.borderWidth = 1.0
        rateView.layer.borderColor = UIColor.systemGray5.cgColor
        rateView.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.15).cgColor
        rateView.layer.shadowOffset = CGSize(width: 0, height: 3)
        rateView.layer.shadowRadius = 2
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
        confiquration.imagePadding = 10.0
        confiquration.imagePlacement = .trailing
        confiquration.preferredSymbolConfigurationForImage = UIImage.SymbolConfiguration(scale: .small)
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
        [firstCurrencyTextField, secondCurrencyTextField, thirdCurrencyTextField].forEach {
            $0?.backgroundColor = UIColor(red: 0.98, green: 0.969, blue: 0.992, alpha: 1)
            $0?.borderStyle = .none
            $0?.layer.cornerRadius = 6.0
        }
    }
    
    private func configureAddCurrencyButton() {
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
    }
    
    private func configureShareButton() {
        var confiquration = UIButton.Configuration.plain()
        confiquration.image = UIImage(systemName: "square.and.arrow.up")
        confiquration.preferredSymbolConfigurationForImage = UIImage.SymbolConfiguration(pointSize: 20.0)
        confiquration.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
        confiquration.baseForegroundColor = .systemGray
        shareButton.configuration = confiquration
    }
    
    private func configureUpdateInfoLabel() {
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
}

