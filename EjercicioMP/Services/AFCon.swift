//
//  AFCon.swift
//  EjercicioMP
//
//  Created by daniel on 7/2/19.
//  Copyright © 2019 Daniel Gonzalez. All rights reserved.
//

import Foundation
import Alamofire

class AFCon:NSObject {
    public static let shared = AFCon()
    
    public func conectar(url_base:String, parametros:[String:String], callback:@escaping (Data)->()) {
        guard let url = URL(string: url_base) else{
            print(APPError.ERUrl.rawValue)
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.get.rawValue
        do {
            try request =  Alamofire.URLEncoding().encode(request as URLRequestConvertible, with: parametros)
        } catch let err {
            print(APPError.ERParametros.rawValue, err)
        }
        AF.request(request).responseData() { data in
            guard data.error == nil, let datos = data.value else{
                print(APPError.ERRespuesta.rawValue)
                return
            }
            callback(datos)
        }
    }
}
