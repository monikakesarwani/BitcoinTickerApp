//
//  ViewController.swift
//  BitcoinTicker
//
//  Created by Angela Yu on 23/01/2016.
//  Copyright © 2016 London App Brewery. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

/*The UIPicker is the scroll wheel that shows all the available currencies that we can query for a Bitcoin price. for that we have to conform UIPickerViewDataSource, UIPickerViewDelegate in our viewcontroller as well as its delegates methods too.
 First, add the method numberOfComponents(in:) to determine how many columns we want in our picker.
 1.numberOfComponents
 Next, we need to tell Xcode how many rows this picker should have using the pickerView(numberOfRowsInComponent:) method.
 2.numberOfRowsInComponent
 Finally, let’s fill the picker row titles with the Strings from our currencyArray using the pickerView:titleForRow: method.
 3.titleForRow

 Place this delegate method below the other methods we just created to tell the picker what to do when the user selects a particular row.
 4.didSelectRow

 and also mention that this class will the delegate of this protoclo therefore we wrote these two line of code in viewDidLoad
 currencyPicker.delegate = self
 currencyPicker.dataSource = self
 
 */

class ViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    var ask: Double = 0.0
    let baseURL = "https://apiv2.bitcoinaverage.com/indices/global/ticker/BTC"
    
    var currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    
    let currencySymbolsArray = ["$", "R$", "$", "¥", "€", "£", "$", "Rp", "₪", "₹", "¥", "$", "kr", "$", "zł", "lei", "₽", "kr", "$", "$", "R"]
    //to tract current currency index with symbol
    var currentSymbol = ""
    
    //to make finalURL add baseURL + currencyArray[row]
    var finalURL = ""

    //Pre-setup IBOutlets
    @IBOutlet weak var bitcoinPriceLabel: UILabel!
    @IBOutlet weak var currencyPicker: UIPickerView!
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        currencyPicker.delegate = self
        currencyPicker.dataSource = self
       
    }

    
    //TODO: Place your 3 UIPickerView delegate methods here
    
    // determine number of columns
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // determine number of rows
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return currencyArray.count
    }
    
    // fill in each row with title from array
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return currencyArray[row]
    }

    /*We have all the currency names stored in the currencyArray already. Let’s use that and the row selected to make up the finalURL.
     https://apiv2.bitcoinaverage.com/indices/global/ticker/BTC<Currency>

     e.g. https://apiv2.bitcoinaverage.com/indices/global/ticker/BTCUSD
     
     baseURL made is stored in a variable. so we also to add baseURL + currencyArray[row] to make finalURL */
    
    
    // Print something when you select a row
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        //print(currencyArray[row])
        
        finalURL = baseURL + currencyArray[row]
        //print(finalURL)
        
        currentSymbol = currencySymbolsArray[row]
      
        getCurencyData(url: finalURL)
        
        
        
    }
    
//    //MARK: - Networking
//    /***************************************************************/
   
    func getCurencyData(url: String) {
        
        Alamofire.request(url, method: .get)
            .responseJSON { response in
                if response.result.isSuccess {
                    print("Sucess! Got Currency data")
                    
                    let currencyJSON : JSON = JSON(response.result.value!)
                    print(currencyJSON)

                    self.updateData(json: currencyJSON)

                } else {
                    print("Error: \(String(describing: response.result.error))")
                    
                    self.bitcoinPriceLabel.text = "Connection Issues"
                }
            }

    }

    
    
    
    
//    //MARK: - JSON Parsing
//    /***************************************************************/
    
    func updateData(json : JSON) {
        
        if let currencyResult = json["ask"].double {
            bitcoinPriceLabel.text = "\(currentSymbol)\(currencyResult)"

        } else{
            bitcoinPriceLabel.text = "Currency Unavailable"
        }
        
        
       // updateUIWithWeatherData()
    }
    




}

