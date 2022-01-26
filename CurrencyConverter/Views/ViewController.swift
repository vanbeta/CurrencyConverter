//
//  ViewController.swift
//  CurrencyConverter
//
//  Created by Ivan Poderegin on 24.01.2022.
//

import UIKit

class ViewController: UIViewController {
    private let presenter = Presenter()
    weak private var viewOutputDelegate: ViewOutputDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.setViewInputDelegate(viewInputDelegate: self)
        self.viewOutputDelegate = presenter
        self.viewOutputDelegate?.getData()
    }
}

extension ViewController: ViewInputDelegate {
    
}

