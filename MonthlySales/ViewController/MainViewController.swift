//
//  ViewController.swift
//  MonthlySales
//
//  Created by René Fouquet on 11.06.17.
//  Copyright © 2017 René Fouquet. All rights reserved.
//

import UIKit

class MainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, FiscalMonthsViewControllerDelegate, SettingsViewControllerDelegate, DependencyInjected {
    @IBOutlet var fiscalMonthTitleLabel: UILabel!
    @IBOutlet var fiscalMonthRangeLabel: UILabel!
    @IBOutlet var revenueLabel: UILabel!
    @IBOutlet var daysLeftLabel: UILabel!
    @IBOutlet var estimationLabel: UILabel!
    @IBOutlet var tableView: UITableView!

    private let refreshControl = UIRefreshControl()
    
    var dependencies: Dependencies!
    
    private var sales = [Sale]()
    private var selectedFiscalMonth: FiscalMonth!
    private var currencySymbol = ""
    
    private var currentFiscalMonth: FiscalMonth {
        if let fiscalMonth = dependencies.fiscalMonths.filter({
            dependencies.formatters.today().isBetween(firstDate: $0.firstDay, lastDate: $0.lastDay)
        }).first {
            return fiscalMonth
        } else {
            return FiscalMonth(title: "Unknown Fiscal Month", firstDay: dependencies.formatters.today(), lastDay: dependencies.formatters.today())
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setSelectedFiscalMonth(currentFiscalMonth)

        setupRefreshControl()

        if let symbol = dependencies.appSettings.getStringFor(key: .currencySymbol) {
            currencySymbol = symbol

            toggleRefreshData(showRefreshControl: true)
        } else {
            dependencies.apiMethods.fetchUserInfo(completion: { [weak self] (returnValue: (user: String?, currencySymbol: String?)) in
                guard let user = returnValue.user, let currency = returnValue.currencySymbol else { return }
                self?.dependencies.appSettings.setString(user, for: .username)
                self?.dependencies.appSettings.setString(currency, for: .currencySymbol)
                self?.refreshData()
            })
        }
    }

    private func setupRefreshControl() {
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        tableView.addSubview(refreshControl)
    }

    func refreshData() {
        toggleRefreshData(showRefreshControl: false)
    }

    private func toggleRefreshData(showRefreshControl: Bool) {
        if showRefreshControl {
            refreshControl.beginRefreshing()
            tableView.setContentOffset(CGPoint(x: 0, y: tableView.contentOffset.y - refreshControl.frame.size.height), animated: true)
        }

        dependencies.apiMethods.getSalesDataFor(startDate: selectedFiscalMonth.firstDay, endDate: selectedFiscalMonth.lastDay) { [weak self] (data: Data?) in
            guard let data = data, let sales = self?.dependencies.apiParser.parseSalesData(data) else {
                DispatchQueue.main.async {
                    self?.refreshControl.endRefreshing()
                    self?.tableView.reloadData()
                    self?.setInfoLabels()
                }
                return
            }
            
            DispatchQueue.main.async {
                self?.sales = sales
                self?.refreshControl.endRefreshing()
                self?.tableView.reloadData()
                self?.setInfoLabels()
            }
        }
    }

    private func setSelectedFiscalMonth(_ fiscalMonth: FiscalMonth) {
        selectedFiscalMonth = fiscalMonth

        fiscalMonthTitleLabel.text = selectedFiscalMonth.title
        fiscalMonthRangeLabel.text = "\(dependencies.formatters.prettyFromDate(selectedFiscalMonth.firstDay))–\(dependencies.formatters.prettyFromDate(selectedFiscalMonth.lastDay))"

        setInfoLabels()
    }

    private func setInfoLabels() {
        var numberOfEntries = 0
        let numberOfDaysTotal = dependencies.calendar.numberOfDaysBetween(firstDate: selectedFiscalMonth.firstDay, secondDate: selectedFiscalMonth.lastDay)
        var totalSales: Decimal = 0.0

        sales.forEach({
            if !(dependencies.calendar.isDateInYesterday($0.date) && $0.revenue == 0.0) { // If the date is yesterday AND the revenue is 0, we need to assume that Apple hasn't released today's reports yet
                numberOfEntries += 1
            }
            totalSales += $0.revenue
        })

        let average = (totalSales / Decimal(numberOfEntries)) * Decimal(numberOfDaysTotal)

        daysLeftLabel.text = "\(numberOfDaysTotal - numberOfEntries)"
        revenueLabel.text = dependencies.formatters.currency(value: totalSales, symbol: currencySymbol)
        estimationLabel.text = dependencies.formatters.currency(value: average, symbol: currencySymbol)
    }

    // MARK: - TableView Delegate & DataSource

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sales.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "salesCell")

        if cell == nil {
            cell = UITableViewCell(style: .value1, reuseIdentifier: "salesCell")
        }

        let sale = sales[indexPath.row]

        cell?.textLabel?.text = dependencies.formatters.currency(value: sale.revenue, symbol: currencySymbol)
        cell?.detailTextLabel?.text = dependencies.formatters.prettyFromDate(sale.date)

        return cell!
    }

    // MARK: - Select Fiscal Month

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showFiscalMonths" {
            if let navVC = segue.destination as? UINavigationController, var vc = navVC.topViewController as? FiscalMonthsViewController {
                vc.delegate = self
                vc.setDependencies(dependencies)
            }
        } else if segue.identifier == "showSettings" {
            if let navVC = segue.destination as? UINavigationController, var vc = navVC.topViewController as? SettingsViewController {
                vc.delegate = self
                vc.setDependencies(dependencies)
            }
        }
    }

    func selectedFiscalMonth(_ month: FiscalMonth) {
        setSelectedFiscalMonth(month)

        toggleRefreshData(showRefreshControl: true)
    }
}
