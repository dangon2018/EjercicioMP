//
//  CollectionViewController.swift
//  EjercicioMP
//
//  Created by daniel on 7/2/19.
//  Copyright © 2019 Daniel Gonzalez. All rights reserved.
//

import Foundation
import TinyConstraints
import SDWebImage


class CollectionViewController: UIViewController {
    
    fileprivate var monto:String?
    fileprivate var metodoPago:String?
    fileprivate var datos:[CollectionData]?
    
    fileprivate lazy var myCollectionView: UICollectionView! = {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        let cv: UICollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        cv.dataSource = self
        cv.delegate = self
        cv.backgroundColor = UIColor.lightGray
        cv.register(Celda.self, forCellWithReuseIdentifier: APPConfig.Celda)
        layout.scrollDirection = .vertical
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.isScrollEnabled = true
        return cv
    }()
    
    init(datos:[CollectionData]?, monto:String?, metodo:String?, titulo:String){
        super.init(nibName: nil, bundle: nil)
        self.monto = monto
        self.metodoPago = metodo
        self.title = titulo
        self.datos = datos
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError(APPError.ERInit.rawValue)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(myCollectionView)
        myCollectionView.edgesToSuperview()
        
    }
    
}

extension CollectionViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let datosFinales = datos else {return 0}
        return datosFinales.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: APPConfig.Celda, for: indexPath) as! Celda
        cell.backgroundColor  = .white
        cell.layer.cornerRadius = 5
        cell.layer.shadowOpacity = 2
        if let ima = datos?[indexPath.row].imagen {
            cell.imageView.sd_setImage(with: URL(string: ima), placeholderImage: UIImage(named: APPConfig.Imagen_Base))
        }else {
            cell.imageView.image = UIImage(named: APPConfig.Imagen_Base)
        }
        cell.textLabel.text = datos?[indexPath.row].nombre
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width - 60 , height: 250)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let titulo = self.title else {return}
        guard let id = datos?[indexPath.row].id else {return}
        
        switch titulo {
        case APPConfig.PTMetodo:
            APICall.shared.requestBancos(metodoId: id){ bancos in
                DM.shared.createCollectionData(data: bancos, callback: { collectionData in
                    let vc = CollectionViewController(datos: collectionData, monto: self.monto, metodo: id, titulo: APPConfig.PTBanco)
                    self.navigationController?.pushViewController(vc, animated: true)
                })
            }
        case APPConfig.PTBanco:
            guard let montoFinal = self.monto,let metodoFinal = self.metodoPago, let nombreBanco = datos?[indexPath.row].nombre else {return}
            var recommended_message:String = "MONTO: $ \(montoFinal)\n" + "METODO DE PAGO: \(metodoFinal.uppercased())\n" + "BANCO: \(nombreBanco.uppercased())\n"
            APICall.shared.requestCuotas(monto: montoFinal, metodo: metodoFinal, banco: id) { cuotas in
                recommended_message.append(cuotas)
                print(recommended_message)
                self.navigationController?.popToRootViewController(animated: true, completion: {
                    NotificationCenter.default.post(name: Notification.Name(rawValue: APPConfig.Noti_Name), object: recommended_message)
                })
            }
        default:
            print(APPError.ERPantalla.rawValue)
        }
    }
}

extension UINavigationController {
    private func doAfterAnimatingTransition(animated: Bool, completion: @escaping (() -> Void)) {
        if let coordinator = transitionCoordinator, animated {
            coordinator.animate(alongsideTransition: nil, completion: { _ in
                completion()
            })
        } else {
            DispatchQueue.main.async {
                completion()
            }
        }
    }
    
    func popToRootViewController(animated: Bool, completion: @escaping (() -> Void)) {
        popToRootViewController(animated: animated)
        doAfterAnimatingTransition(animated: animated, completion: completion)
    }
}


