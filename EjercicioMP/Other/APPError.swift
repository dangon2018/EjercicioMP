//
//  APPError.swift
//  EjercicioMP
//
//  Created by daniel on 7/2/19.
//  Copyright © 2019 Daniel Gonzalez. All rights reserved.
//

import Foundation

enum APPError: String {
    case ERCuotas = "Error Obteniendo Cuotas"
    case ERBancos = "Error Obteniendo Bancos"
    case ERMetodo = "Error Obteniendo Metodos de Pago"
    case ERUrl = "Error Obteniendo la Url"
    case ERParametros = "Error Obteniendo Parametros"
    case ERRespuesta = "Error Obteniendo la Respuesta"
    case ERPantalla = "Error en la Seleccion de Pantallas"
    case ERInit = "init(coder:) has not been implemented"
}
