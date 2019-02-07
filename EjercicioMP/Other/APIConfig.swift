//
//  APIConfig.swift
//  EjercicioMP
//
//  Created by daniel on 7/2/19.
//  Copyright © 2019 Daniel Gonzalez. All rights reserved.
//

import Foundation

struct APIConfig{
    static let Public_key = "public_key"
    static let Payment_Method_Id = "payment_method_id"
    static let Payment_Type_Id = "credit_card"
    static let Payment_Amount = "amount"
    static let Issuer_Id = "issuer.id"
    static let Public_key_Data = "444a9ef5-8a6b-429f-abdf-587639155d88"
    static let Base_Url =  "https://api.mercadopago.com/v1/payment_methods"
    static let Sel_Banco = Base_Url + "/card_issuers"
    static let Sel_Cuotas = Base_Url + "/installments"
}
