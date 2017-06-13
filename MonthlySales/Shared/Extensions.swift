//
//  Extensions.swift
//  MonthlySales
//
//  Created by René Fouquet on 11.06.17.
//  Copyright © 2017 René Fouquet. All rights reserved.
//

import Foundation

extension Date {
    func isBetween(firstDate: Date, lastDate: Date) -> Bool {
        return (firstDate...lastDate).contains(self)
    }
}
