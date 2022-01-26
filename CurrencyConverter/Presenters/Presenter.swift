//
//  Presenter.swift
//  CurrencyConverter
//
//  Created by Ivan Poderegin on 24.01.2022.
//

import Foundation

class Presenter {
    weak private var viewInputDelegate: ViewInputDelegate?
    var data = Countries()
    
    func setViewInputDelegate(viewInputDelegate: ViewInputDelegate?) {
         self.viewInputDelegate = viewInputDelegate
     }
}

extension Presenter: ViewOutputDelegate {
    func getData() {
        data.updateCountries()
    }
}

