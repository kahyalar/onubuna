//
//  ViewController.swift
//  Onubuna
//
//  Created by Furkan Kahyalar on 19/12/2017.
//  Copyright © 2017 kahyalar. All rights reserved.
//

import UIKit
import Alamofire

class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource{

    @IBOutlet weak var inputCurrency: UITextField!
    @IBOutlet weak var inputAmount: UITextField!
    @IBOutlet weak var outputCurrency: UITextField!
    @IBOutlet weak var outputAmount: UILabel!
    @IBOutlet weak var buttonConvert: UIButton!
    
    let pickerView = UIPickerView()
    let currencies = Currencies.getAllCurrencies()
    
    var prices: Dictionary =
        [
            Currencies.btc.rawValue: 0.0,
            Currencies.eth.rawValue: 0.0,
            Currencies.eur.rawValue: 1.0,
            Currencies.tl.rawValue: 0.0,
            Currencies.usd.rawValue: 0.0
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getCurrencyDatas()
        createPickerView()
    }

    func getCurrencyDatas(){
        getNonCryptoCurrencyData()
        getCryptoCurrencyData()
    }
    
    func getNonCryptoCurrencyData(){
        guard let url = URL(string: "https://api.fixer.io/latest?symbols=USD,TRY?base=EUR") else {
            
            return
        }
        
        Alamofire.request(url).responseJSON { response in
            let data = response.data
            do {
                let noncryptoPrices = try JSONDecoder().decode(Noncrypto.self, from: data!)
                self.prices.updateValue(1/(noncryptoPrices.rates.TRY), forKey: Currencies.tl.rawValue)
                self.prices.updateValue(1/(noncryptoPrices.rates.USD), forKey: Currencies.usd.rawValue)
            } catch {
                print("Error!")
            }
        }
    }
    
    func getCryptoCurrencyData(){
        
        let url = URL(string: "https://api.coinmarketcap.com/v1/ticker/?convert=EUR&limit=2")
        Alamofire.request(url!).responseJSON { response in
            let data = response.data
            do {
                let cryptoPrices = try JSONDecoder().decode([Crypto].self, from: data!)
                for currency in cryptoPrices {
                    self.prices.updateValue(Double(currency.price_eur)!, forKey: currency.symbol)
                }
            } catch {
                print("Error!")
            }
        }
    }
    
    func createPickerView(){
        pickerView.delegate = self
        inputCurrency.inputView = pickerView
        outputCurrency.inputView = pickerView
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return currencies.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return currencies[row].rawValue
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if component == 0{
            inputCurrency.text = currencies[row].rawValue
        }
        else{
            outputCurrency.text = currencies[row].rawValue
        }
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    @IBAction func actionConvert(_ sender: UIButton) {
        guard let inputCurrencyContent = self.inputCurrency.text, !inputCurrencyContent.isEmpty else { self.alertInputMissing(); return }
        guard let outputCurrencyContent = self.outputCurrency.text, !outputCurrencyContent.isEmpty else { self.alertInputMissing(); return }
        guard let inputAmountContent = self.inputAmount.text, !inputAmountContent.isEmpty else { self.alertInputMissing(); return }
        
        let result = Double(self.prices[inputCurrencyContent]!) * Double(inputAmountContent)! / Double(self.prices[outputCurrencyContent]!)
        self.outputAmount.text = String(format: "%.5f \(outputCurrencyContent)",result)
    }
    
    func alertInputMissing()
    {
        let alert = UIAlertController(title: "Whoops", message: "Please fill all fields before converting!", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Try again!", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

