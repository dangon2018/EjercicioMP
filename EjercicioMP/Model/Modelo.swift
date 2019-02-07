//
//  Modelo.swift
//  EjercicioMP
//
//  Created by daniel on 7/2/19.
//  Copyright © 2019 Daniel Gonzalez. All rights reserved.
//

import Foundation

struct Metodo: Codable {
    var name: String?
    var secure_thumbnail: String?
    var payment_type_id: String?
    var id: String?
}

struct Banco: Codable {
    var name: String?
    var secure_thumbnail: String?
    var id: String?
}

struct Cuotas: Codable {
    let payer_costs: [Costo]
    struct Costo: Codable {
        var recommended_message: String?
    }
}

struct CollectionData {
    var nombre: String?
    var imagen: String?
    var id: String?
    init(nombre: String?,imagen:String?,id:String?) {
        self.nombre = nombre
        self.imagen = imagen
        self.id = id
    }
}
