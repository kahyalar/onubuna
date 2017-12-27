//
//  Currency.swift
//  Onubuna
//
//  Created by Furkan Kahyalar on 27/12/2017.
//  Copyright © 2017 kahyalar. All rights reserved.
//

import Foundation

struct Normal: Decodable {
    let rates: Rate?
}

struct Rate: Decodable {
    var tl: Double?
    var usd: Double?
}

struct Crypto: Decodable {
    let symbol: String
    let price_eur: String
}
