//
//  DataManager.swift
//  EjercicioMP
//
//  Created by daniel on 7/2/19.
//  Copyright © 2019 Daniel Gonzalez. All rights reserved.
//

import Foundation

class DM: NSObject {
    public static let shared = DM()
    
    public func createCollectionData(data:[Metodo], callback:@escaping ([CollectionData])->()){
        let finalData = data.compactMap {CollectionData(nombre: $0.name, imagen: $0.secure_thumbnail, id: $0.id)}
        callback(finalData)
    }
    
    public func createCollectionData(data:[Banco], callback:@escaping ([CollectionData])->()){
        let finalData = data.compactMap {CollectionData(nombre: $0.name, imagen: $0.secure_thumbnail, id: $0.id)}
        if finalData.count == 0  {
            let fd = CollectionData(nombre: APPConfig.Sin_Bancos, imagen: nil, id: nil)
            let cd = [fd]
            callback(cd)
        }else{
            callback(finalData)
        }
    }
}
