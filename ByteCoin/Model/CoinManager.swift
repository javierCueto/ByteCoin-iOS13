//
//  CoinManager.swift
//  ByteCoin
//
//  Created by Angela Yu on 11/09/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import Foundation

protocol CoinManagerDelegate{
    func didUpdateBitCoin(_ coinManager: CoinManager, lastCoin: Double)
    func didFailWithError(error: Error)
}

struct CoinManager {
    var delegate : CoinManagerDelegate?
    let baseURL = "https://apiv2.bitcoinaverage.com/indices/global/ticker/BTC"
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    
    func getCoinPrince(for currency: String){
        let urlString = "\(baseURL)\(currency)"
        print(urlString)
        performRequest(with : urlString)
    }
    
    
    
    func performRequest(with urlString : String){
        print("Esta realizando una busqueda...")
        let urlStringParsed = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        if let url = URL(string: urlStringParsed!){
            print("is url")
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                print("create the request")
                if error != nil{
                    print("request is null")
                    print("fallo al buscar")
                 //   self.delegate?.didFailWithError(error : error!)
                    return
                }
                
                if let safeData = data {
                    print("trae datos")
                   // let dataString = String(data: safeData, encoding: .utf8)
                    //print(dataString)
                    if let lastCoin = self.parseJSON(safeData) {
                        //print("regresa los datos")
                        // this line call a delegated method, this method is in the controller
                        self.delegate?.didUpdateBitCoin(self, lastCoin: lastCoin)
                    }
                }
                
            }
            print("finaliza la peticion")
            task.resume()
        }
        print("no es url")
    }
    
    
    func parseJSON(_ data: Data) -> Double?{
        let decoder = JSONDecoder()
        do{
            let decodedData = try decoder.decode(CoinData.self, from: data)
            let lastPrice = decodedData.last
            return lastPrice
        }catch {
            print("problemas de conexion")
            delegate?.didFailWithError(error : error)
            return nil
        }
    }
}
