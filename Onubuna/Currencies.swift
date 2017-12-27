//
//  Currencies.swift
//  Onubuna
//
//  Created by Furkan Kahyalar on 27/12/2017.
//  Copyright © 2017 kahyalar. All rights reserved.
//

import Foundation

enum Currencies: String{
    case tl = "TRY"
    case usd = "USD"
    case eur = "EUR"
    case btc = "BTC"
    case eth = "ETH"
    
    static func getAllCurrencies() -> [Currencies]{
        let allCurrencies: [Currencies] =
        [
            .tl,
            .usd,
            .eur,
            .btc,
            .eth
        ]
        return allCurrencies
    }
}
