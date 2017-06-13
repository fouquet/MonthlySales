//
//  AppDelegate.swift
//  MonthlySales
//
//  Created by René Fouquet on 11.06.17.
//  Copyright © 2017 René Fouquet. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        let formatters = Formatters()
        let fiscalMonths = loadFiscalData(formatters: formatters)
        
        let dependencies = Depenencies(apiMethods: ApiMethods(formatters: formatters), apiParser: ApiParser(formatters: formatters), formatters: formatters, appSettings: AppSettings(), calendar: InternalCalendar(), fiscalMonths: fiscalMonths)
        
        /* Dependency injection */
        if let navController = window?.rootViewController as? UINavigationController, var mainViewController = navController.topViewController as? MainViewController {
            mainViewController.setDependencies(dependencies)
        } else {
            fatalError("Error during dependency injection")
        }

        return true
    }

    private func loadFiscalData(formatters: FormattersProtocol) -> [FiscalMonth] {
        if let filePath = Bundle.main.path(forResource: "AppleFiscalMonths", ofType: "json"), let jsonData = try? Data(contentsOf: URL(fileURLWithPath: filePath), options: .mappedIfSafe) {

            /*
             Fiscal Calendar data based on https://itunesconnect.apple.com/WebObjects/iTunesConnect.woa/wa/jumpTo?page=fiscalcalendar
             */

            /*
             Force try is intentional here. If parsing fails, we need to crash.
             */

            var fiscalMonths = [FiscalMonth]()
            
            let json = try! JSONSerialization.jsonObject(with: jsonData, options: [])
            guard let array = json as? [[String: Any]] else { fatalError("Error parsing the fiscal data") }

            try! array.forEach({ fiscalMonths.append(try FiscalMonth(json: $0, formatters: formatters)) })
           
            return fiscalMonths
        } else {
            fatalError("Error parsing the fiscal data")
        }
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
}
