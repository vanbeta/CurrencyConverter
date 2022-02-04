//
//  ViewController.swift
//  CurrencyConverter
//
//  Created by Ivan Poderegin on 24.01.2022.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var fromCountryTextField: UITextField!
    @IBOutlet weak var toCountryTextField: UITextField!
    @IBOutlet weak var fromValueTextField: UITextField!
    @IBOutlet weak var toValueTextField: UITextField!
    
    private let presenter = Presenter()
    weak private var viewOutputDelegate: ViewOutputDelegate?
    
    var selectedCountry: String?
    var countryList: [Country] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.setViewInputDelegate(viewInputDelegate: self)
        self.viewOutputDelegate = presenter
        
        self.viewOutputDelegate?.getData()
        
        settingCountryTextField(textField: fromCountryTextField)
        settingCountryTextField(textField: toCountryTextField)
        
        settingValueTextField(textField: fromValueTextField)
        settingValueTextField(textField: toValueTextField)
    }
    
    func settingValueTextField(textField: UITextField) {
        textField.delegate = self
        textField.textAlignment = .center
        textField.keyboardType = .numberPad
    }
    
    func settingCountryTextField(textField: UITextField) {
        textField.textAlignment = .center
        createPickerView(for: textField)
        dismissPickerView(for: textField)
    }
}

extension ViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let invalidCharacters = CharacterSet(charactersIn: "0123456789").inverted
        return (string.rangeOfCharacter(from: invalidCharacters) == nil)
    }
}

extension ViewController: UIPickerViewDelegate,
                          UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return countryList.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return countryList[row].currencyName
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedCountry = countryList[row].currencyName
        
        if (pickerView == fromCountryTextField.inputView) {
            fromCountryTextField.text = selectedCountry
        }
        if (pickerView == toCountryTextField.inputView) {
            toCountryTextField.text = selectedCountry
        }
    }
    
    func createPickerView(for textField: UITextField) {
        let pickerView = UIPickerView()
        pickerView.delegate = self
        textField.inputView = pickerView
    }
    
    func dismissPickerView(for textField: UITextField) {
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        let button = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.action))
        toolBar.setItems([button], animated: true)
        toolBar.isUserInteractionEnabled = true
        textField.inputAccessoryView = toolBar
    }
    
    @objc func action() {
        view.endEditing(true)
    }
}

extension ViewController: ViewInputDelegate {
    func setupData(data: ([Country])) {
        self.countryList = data
        self.countryList.sort(by: {$0.currencyName! < $1.currencyName!}) // !!!
    }
}

