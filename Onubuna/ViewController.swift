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
    @IBOutlet weak var outputAmount: UITextField!
    @IBOutlet weak var buttonConvert: UIButton!
    
    let inputPickerView = UIPickerView()
    let outputPickerView = UIPickerView()
    let currencies = Currencies.getAllCurrencies()
    
    var prices: Dictionary =
    [
        Currencies.btc.rawValue: -1.0,
        Currencies.eth.rawValue: -1.0,
        Currencies.eur.rawValue: -1.0,
        Currencies.tl.rawValue: -1.0,
        Currencies.usd.rawValue: -1.0
    ]
    
    var cryptoPrices = [Crypto]()
    
    func getCurrencyDatas(){
        getNonCryptoCurrencyData()
        getCryptoCurrencyData()
    }
    
    func getNonCryptoCurrencyData(){
        let url = URL(string: "https://api.fixer.io/latest?symbols=USD,TRY?base=EUR")
        Alamofire.request(url!).responseJSON { response in
            let data = response.data
            do {
                self.cryptoPrices = try JSONDecoder().decode([Crypto].self, from: data!)
                for currency in self.cryptoPrices {
                    self.prices.updateValue(Double(currency.price_eur)!, forKey: currency.symbol)
                }
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
                self.cryptoPrices = try JSONDecoder().decode([Crypto].self, from: data!)
                for currency in self.cryptoPrices {
                    self.prices.updateValue(Double(currency.price_eur)!, forKey: currency.symbol)
                }
            } catch {
                print("Error!")
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getCurrencyDatas()
        disableOutputAmountTextField()
        createPickerView()
    }
    
    func disableOutputAmountTextField(){
        outputAmount.isUserInteractionEnabled = false
    }
    
    func createPickerView(){
        inputPickerView.delegate = self
        outputPickerView.delegate = self
        inputCurrency.inputView = inputPickerView
        outputCurrency.inputView = outputPickerView
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return currencies.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return currencies[row].rawValue
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == inputPickerView{
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
        if self.inputCurrency.hasText && self.outputCurrency.hasText && self.inputAmount.hasText{
            let inputCurrency = self.inputCurrency.text
            let inputAmount = self.inputAmount.text
            let outputCurrency = self.outputCurrency.text
            let result = Double(self.prices[inputCurrency!]!) * Double(inputAmount!)! / Double(self.prices[outputCurrency!]!)
            self.outputAmount.text = String(format: "%.5f",result)
        }
        else {
            let alert = UIAlertController(title: "Whoops", message: "Please fill all fields before converting!", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        
    }
    
    
    

}

