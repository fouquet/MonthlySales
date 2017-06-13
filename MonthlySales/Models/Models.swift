//
//  Sale.swift
//  MonthlySales
//
//  Created by René Fouquet on 11.06.17.
//  Copyright © 2017 René Fouquet. All rights reserved.
//

import Foundation

enum SerializationError: Error {
    case missing(String)
    case invalid(String, Any)
}

struct Sale {
    var date: Date
    var revenue: Decimal
}

struct FiscalMonth {
    var title: String
    var firstDay: Date
    var lastDay: Date
}

struct User {
    var name: String
    var currency: String
}

struct Currency {
    var iso: String
    var symbol: String
}

extension Sale {
    init(json: [String: Any], formatters: FormattersProtocol) throws {
        guard let date = json["date"] as? String,
            let revenue = json["revenue"] as? String else {
                throw SerializationError.missing("date or revenue")
        }

        if let revenueFromString = Decimal(string: revenue) {
            self.revenue = revenueFromString
        } else {
            self.revenue = Decimal(0.0)
        }

        self.date = formatters.toDate(date)
    }
}

extension FiscalMonth {
    init(json: [String: Any], formatters: FormattersProtocol) throws {
        guard let title = json["title"] as? String,
            let firstDay = json["firstDay"] as? String, let lastDay = json["lastDay"] as? String else {
                throw SerializationError.missing("title, firstDay or lastDay")
        }

        self.title = title
        self.firstDay = formatters.toDate(firstDay)
        self.lastDay = formatters.toDate(lastDay)
    }
}

extension User {
    init(json: [String: Any]) throws {
        guard let name = json["name"] as? String,
            let currency = json["currency"] as? String else {
                throw SerializationError.missing("name or currency")
        }

        self.name = name
        self.currency = currency
    }
}

extension Currency {
    init(json: [String: Any]) throws {
        guard let iso = json["Currency"] as? String,
            let symbol = json["Symbol"] as? String else {
                throw SerializationError.missing("Currency or Symbol")
        }

        self.iso = iso
        self.symbol = symbol
    }

    static func symbolForISO(_ iso: String, currencies: [Currency]) -> String? {
        return currencies.filter({ $0.iso == iso }).first?.symbol
    }
}
