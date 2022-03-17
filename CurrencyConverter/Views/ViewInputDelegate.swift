//
//  ViewInputDelegate.swift
//  CurrencyConverter
//
//  Created by Ivan Poderegin on 25.01.2022.
//

import Foundation

protocol ViewInputDelegate: AnyObject {
 
    
    func setupData(data: ([Country]))
    func getCountriesForCurrencyExchange() -> (from: String, to: String)
    func getDataForCurrencyExchange() -> (from: Int, to: Int)
    func getFromValueTextField() -> String
    func setFromValueTextField(value: Float)
    func getToValueTextField() -> String
    func setToValueTextField(value: Float)
    func setDefaultCountries(from: String, to: String)
    func setCurrentRateLabel(text: String)
    func getFromCountry() -> String
    func getToCountry() -> String
}
