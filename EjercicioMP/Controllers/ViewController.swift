//
//  ViewController.swift
//  EjercicioMP
//
//  Created by daniel on 7/2/19.
//  Copyright © 2019 Daniel Gonzalez. All rights reserved.
//

import UIKit
import TinyConstraints

class ViewController: UIViewController {

    private var monto:String = "0"
    private let label:UILabel = {
        let label = UILabel()
        label.textColor = .gray
        label.text = "Ingrese el Monto"
        label.font = UIFont.boldSystemFont(ofSize: 33)
        label.textAlignment = .center
        return label
    }()
    
    private let textField:UITextField = {
        let tf = UITextField()
        tf.font = UIFont.boldSystemFont(ofSize: 44)
        tf.textColor = .black
        tf.placeholder = "0"
        tf.keyboardType = .numberPad
        tf.textAlignment = .center
        return tf
    }()
    
    private let botonContinuar:UIButton = {
        let bc = UIButton()
        bc.setTitle("Continuar", for: .normal)
        bc.setTitleColor(.white, for: .normal)
        bc.backgroundColor = UIColor(red: 0/255, green:114/255,blue: 188/255, alpha:1)
        bc.addTarget(self, action: #selector(enviarData), for: .touchUpInside)
        bc.layer.cornerRadius = 20
        return bc
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.mostrarResultado(_:)), name:NSNotification.Name(rawValue: APPConfig.Noti_Name), object: nil)
        
    }
    
    @objc private func mostrarResultado(_ notification: Notification) {
        textField.text = ""
        let resultado : String = notification.object as! String
        mostrarAlerta(titulo: "CUOTAS", mensaje: resultado)
    }
    
    
    @objc private func enviarData(){
        verificarIngresoMonto()
    }
    
    private func setupViews(){
        self.title = APPConfig.PTMonto
        view.addSubview(label)
        view.addSubview(textField)
        view.addSubview(botonContinuar)
        textField.size(CGSize(width: 200, height: 50))
        textField.top(to: view, offset: view.frame.height/2)
        textField.centerX(to: view)
        label.size(CGSize(width: view.frame.width - 60, height: 50))
        label.bottom(to: textField, offset: -50)
        label.centerX(to: textField)
        botonContinuar.size(CGSize(width: view.frame.width - 40, height: 50))
        botonContinuar.bottom(to: view, offset: -40)
        botonContinuar.centerX(to: view)
    }
    
    private func verificarIngresoMonto(){
        guard let montoIngresado = textField.text, textField.text?.count != 0 , textField.text != "0" else{
            mostrarAlerta(titulo: "AGREGAR MONTO", mensaje: "Por favor Ingrese un monto valido")
            return}
        self.monto = montoIngresado
        presentMediosPagos()
        
    }
    
    private func presentMediosPagos(){
        APICall.shared.requestTarjetas { mediosPago in
            DM.shared.createCollectionData(data: mediosPago, callback: { collectionData in
                let vc = CollectionViewController(datos: collectionData, monto: self.monto, metodo: nil, titulo: APPConfig.PTMetodo)
                self.navigationController?.pushViewController(vc, animated: true)
            })
        }
    }
    
    private func mostrarAlerta(titulo:String, mensaje:String)  {
        let alertController = UIAlertController(title: titulo, message: mensaje, preferredStyle: .alert)
        let action1 = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction) in
            print("Alerta: \(titulo) \(mensaje)");
        }
        alertController.addAction(action1)
        self.present(alertController, animated: true, completion: nil)
    }
    
}

extension ViewController: UITextFieldDelegate{
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for txt in self.view.subviews {
            if txt.isKind(of: UITextField.self) && txt.isFirstResponder {
                txt.resignFirstResponder()
            }
        }
    }
}

