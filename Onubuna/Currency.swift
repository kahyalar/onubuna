//
//  Currency.swift
//  Onubuna
//
//  Created by Furkan Kahyalar on 27/12/2017.
//  Copyright © 2017 kahyalar. All rights reserved.
//

import Foundation

struct Noncrypto: Decodable {
    let rates: Rates
}

struct Rates: Decodable {
    let TRY: Double
    let USD: Double
}

struct Crypto: Decodable {
    let symbol: String
    let price_eur: String
}
