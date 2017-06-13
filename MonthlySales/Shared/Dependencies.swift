//
//  Dependencies.swift
//  MonthlySales
//
//  Created by René Fouquet on 12.06.17.
//  Copyright © 2017 René Fouquet. All rights reserved.
//

import UIKit

protocol DependencyInjected {
    var dependencies: Depenencies! { get set }
}

extension DependencyInjected {
    mutating func setDependencies(_ dependencies: Depenencies) {
        self.dependencies = dependencies
    }
}

final class Depenencies {
    let fiscalMonths:[FiscalMonth]
    let formatters:FormattersProtocol
    let apiMethods:ApiMethodsProtocol
    let apiParser:ApiParserProtocol
    let appSettings:AppSettingsProtocol
    let calendar: InternalCalendarProtocol

    init(apiMethods: ApiMethodsProtocol, apiParser: ApiParserProtocol, formatters: FormattersProtocol, appSettings: AppSettingsProtocol, calendar: InternalCalendarProtocol, fiscalMonths: [FiscalMonth]) {
        self.apiMethods = apiMethods
        self.apiParser = apiParser
        self.formatters = formatters
        self.fiscalMonths = fiscalMonths
        self.appSettings = appSettings
        self.calendar = calendar
    }
}
