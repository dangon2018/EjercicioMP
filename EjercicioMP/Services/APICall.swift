//
//  APICall.swift
//  EjercicioMP
//
//  Created by daniel on 7/2/19.
//  Copyright © 2019 Daniel Gonzalez. All rights reserved.
//

import Foundation
import Alamofire

class APICall: NSObject {
    public static let shared = APICall()
    private let afc = AFCon.shared
    
    public func requestTarjetas(callback: (([Metodo])->())?){
        let urlString = APIConfig.Base_Url
        let parametros: Parameters = [APIConfig.Public_key: APIConfig.Public_key_Data]
        afc.conectar(url_base: urlString, parametros: parametros as! [String : String]) { (datos) in
            do {
                let decoder = JSONDecoder()
                let respuesta = try decoder.decode([Metodo].self, from: datos)
                //Filtra solo las tarjetas de credito
                let tarjetas = respuesta.filter({ (metodo) -> Bool in
                    metodo.payment_type_id == APIConfig.Payment_Type_Id
                })
                callback!(tarjetas)
            } catch let err {
                print(APPError.ERMetodo.rawValue, err)
            }
        }
    }
    
    public func requestBancos(metodoId:String, callback: (([Banco])->())?){
        let urlString = APIConfig.Sel_Banco
        let parametros: Parameters = [APIConfig.Public_key: APIConfig.Public_key_Data, APIConfig.Payment_Method_Id: metodoId]
        afc.conectar(url_base: urlString, parametros: parametros as! [String : String]) { (datos) in
            do {
                let decoder = JSONDecoder()
                let bancos = try decoder.decode([Banco].self, from: datos)
                callback!(bancos)
            } catch let err {
                print(APPError.ERBancos.rawValue, err)
            }
        }
    }
    
    public func requestCuotas(monto: String, metodo: String, banco:String, callback: ((String)->())?){
        let urlString = APIConfig.Sel_Cuotas
        let parametros: Parameters = [APIConfig.Public_key: APIConfig.Public_key_Data, APIConfig.Payment_Amount: monto, APIConfig.Payment_Method_Id: metodo, APIConfig.Issuer_Id: banco]
        var stringFinal = ""
        afc.conectar(url_base: urlString, parametros: parametros as! [String : String]) { (datos) in
            do {
                let decoder = JSONDecoder()
                let cuotas = try decoder.decode([Cuotas].self, from: datos).first
                guard let cuotasFinales = cuotas?.payer_costs else{return}
                for cuota in cuotasFinales{
                    guard let cuotaRecomendada = cuota.recommended_message else {return}
                    let strCuota = cuotaRecomendada + "\n"
                    stringFinal.append(strCuota)
                }
            } catch let err {
                print(APPError.ERCuotas.rawValue, err)
            }
            callback!(stringFinal)
        }
    }
}
