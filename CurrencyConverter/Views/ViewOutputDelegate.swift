//
//  ViewOutputDelegate.swift
//  CurrencyConverter
//
//  Created by Ivan Poderegin on 25.01.2022.
//

import Foundation

protocol ViewOutputDelegate: AnyObject {


    func getData()
    func enterFromValue()
    func enterToVaue()
    func chenageCurrentCounries()
}
