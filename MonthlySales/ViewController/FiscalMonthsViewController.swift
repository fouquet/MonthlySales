//
//  FiscalMonthsViewController.swift
//  MonthlySales
//
//  Created by René Fouquet on 11.06.17.
//  Copyright © 2017 René Fouquet. All rights reserved.
//

import UIKit

protocol FiscalMonthsViewControllerDelegate: class {
    func selectedFiscalMonth(_ month: FiscalMonth)
}

class FiscalMonthsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, DependencyInjected {
    @IBOutlet var tableView: UITableView!

    var dependencies: Dependencies!
    
    weak var delegate: FiscalMonthsViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    // MARK: - TableView Delegate & DataSource

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dependencies.fiscalMonths.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "fiscalCell")

        if cell == nil {
            cell = UITableViewCell(style: .value1, reuseIdentifier: "fiscalCell")
        }

        let month = dependencies.fiscalMonths[indexPath.row]

        cell?.textLabel?.text = month.title
        cell?.detailTextLabel?.text = "\(dependencies.formatters.prettyFromDate(month.firstDay))–\(dependencies.formatters.prettyFromDate(month.lastDay))"

        if month.firstDay > dependencies.formatters.today() {
            cell?.isUserInteractionEnabled = false
            cell?.textLabel?.textColor = UIColor.lightGray.withAlphaComponent(0.6)
            cell?.detailTextLabel?.textColor = UIColor.lightGray.withAlphaComponent(0.6)
        } else {
            cell?.isUserInteractionEnabled = true
            cell?.alpha = 0.5
            cell?.textLabel?.textColor = UIColor.black
            cell?.detailTextLabel?.textColor = UIColor.gray
        }

        return cell!
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let month = dependencies.fiscalMonths[indexPath.row]

        delegate?.selectedFiscalMonth(month)

        dismiss(animated: true, completion: nil)
    }
}
