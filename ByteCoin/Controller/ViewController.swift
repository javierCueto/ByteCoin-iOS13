//
//  ViewController.swift
//  ByteCoin
//
//  Created by Angela Yu on 11/09/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UIPickerViewDataSource, UIPickerViewDelegate {
    var coinManager = CoinManager()
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return coinManager.currencyArray.count
    }
    

    @IBOutlet weak var bitcoinLabel: UILabel!
    @IBOutlet weak var currencyLabel: UILabel!
    @IBOutlet weak var currencyPicker: UIPickerView!
    override func viewDidLoad() {
        super.viewDidLoad()
        currencyPicker.dataSource = self
        currencyPicker.delegate = self
        coinManager.delegate = self
        // Do any additional setup after loading the view.
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return coinManager.currencyArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let selectedCurrency = coinManager.currencyArray[row]
        coinManager.getCoinPrince(for: selectedCurrency)
    }

}


//MARK: - CoinManager
extension ViewController: CoinManagerDelegate {
    func didUpdateBitCoin(_ coinManager: CoinManager, lastCoin: Double,_ currency : String) {
        DispatchQueue.main.async {
            self.bitcoinLabel.text = String(format: "%.2f",lastCoin )
            self.currencyLabel.text = currency
        }
    }
    
//en case of error appear a messege just in console, fix this part
    func didFailWithError(error: Error) {

        print("###########################################")
              DispatchQueue.main.async {
        // create the alert
        let alert = UIAlertController(title: ":(", message: "Lo sentimos pero no existe lo que busca, ella no te ama.", preferredStyle: UIAlertController.Style.alert)

        // add an action (button)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))

        // show the alert
        self.present(alert, animated: true, completion: nil)
        }
        print(error)
         print("###########################################")
    }
}

