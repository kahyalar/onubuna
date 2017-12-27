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
    let currencies = ["TRY", "EUR", "USD", "BTC", "ETH"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        return currencies[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == inputPickerView{
            inputCurrency.text = currencies[row]
        }
        else{
            outputCurrency.text = currencies[row]
        }
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    @IBAction func actionConvert(_ sender: UIButton) {
        debugPrint("Tık")
    }
    
    
    

}

