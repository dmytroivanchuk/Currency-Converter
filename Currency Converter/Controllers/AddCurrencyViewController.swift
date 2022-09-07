//
//  AddCurrencyViewController.swift
//  Currency Converter
//
//  Created by Dmytro Ivanchuk on 06.09.2022.
//

import UIKit

class AddCurrencyViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    private let currencyTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return tableView
    }()
    
    private let currencySearchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.searchBarStyle = .minimal
        searchBar.sizeToFit()
        searchBar.isTranslucent = false
        return searchBar
    }()
    
    var sections = [Section]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        currencyTableView.delegate = self
        currencyTableView.dataSource = self
        view.backgroundColor = .systemBackground
        
        configureNavigationItem()
        configureCurrencySearchBar()
//        configureCurrencyTableView()
        view.addSubview(currencyTableView)
        currencyTableView.frame = view.bounds
        currencyTableView.tableHeaderView = currencySearchBar
        
    }
    
    private func configureNavigationItem() {
        let backbutton = UIButton(type: .custom)
        backbutton.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
        var confiquration = UIButton.Configuration.plain()
        confiquration.title = "Converter"
        confiquration.image = UIImage(systemName: "chevron.left")
        confiquration.imagePadding = 2
        confiquration.imagePlacement = .leading
        confiquration.preferredSymbolConfigurationForImage = UIImage.SymbolConfiguration(pointSize: 20, weight: .medium, scale: .large)
        confiquration.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
        backbutton.configuration = confiquration
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backbutton)
        navigationItem.title = "Currency"
    }
    
    @objc func backButtonPressed() {
        dismiss(animated: true)
    }
    
    private func configureCurrencySearchBar() {
        view.addSubview(currencySearchBar)
        currencySearchBar.translatesAutoresizingMaskIntoConstraints = false
        currencySearchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        currencySearchBar.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16).isActive = true
        currencySearchBar.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16).isActive = true
    }
    
    private func configureCurrencyTableView() {
        view.addSubview(currencyTableView)
        currencyTableView.translatesAutoresizingMaskIntoConstraints = false
        currencyTableView.topAnchor.constraint(equalTo: currencySearchBar.bottomAnchor, constant: 16).isActive = true
        currencyTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16).isActive = true
        currencyTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16).isActive = true
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let section = sections[section]
        return section.letter
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        sections[section].names.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let currency = sections[indexPath.section].names[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = currency
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
//        let model = models[indexPath.section].options[indexPath.row]
//        model.handler()
    }
}
