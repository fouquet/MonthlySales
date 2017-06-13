//
//  SettingsViewController.swift
//  MonthlySales
//
//  Created by René Fouquet on 11.06.17.
//  Copyright © 2017 René Fouquet. All rights reserved.
//

import UIKit

protocol SettingsViewControllerDelegate:class {
    func refreshData()
}

class SettingsViewController: UIViewController, DependencyInjected {
    @IBOutlet var userNameLabel: UILabel!
    @IBOutlet var currencyLabel: UILabel!

    var dependencies: Depenencies!
    
    weak var delegate: SettingsViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        setLabels()
    }

    private func setLabels() {
        if let name = dependencies.appSettings.getStringFor(key: .username) {
            userNameLabel.text = name
        } else {
            userNameLabel.text = "Unknown"
        }

        if let currency = dependencies.appSettings.getStringFor(key: .currencySymbol) {
            currencyLabel.text = currency
        } else {
            currencyLabel.text = "Unknown"
        }
    }

    @IBAction func refreshAccountData() {
        dependencies.apiMethods.fetchUserInfo(completion: { [weak self] (returnValue: (user: String?, currencySymbol: String?)) in
            guard let user = returnValue.user, let currency = returnValue.currencySymbol else { return }
            self?.dependencies.appSettings.setString(user, for: .username)
            self?.dependencies.appSettings.setString(currency, for: .currencySymbol)
            self?.setLabels()
            self?.delegate?.refreshData()
        })
    }
}
