//
//  Celda.swift
//  EjercicioMP
//
//  Created by daniel on 7/2/19.
//  Copyright © 2019 Daniel Gonzalez. All rights reserved.
//

import Foundation
import UIKit
import TinyConstraints

class Celda: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError(APPError.ERInit.rawValue)
    }
    
    public let imageView: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = UIImageView.ContentMode.scaleAspectFit
        image.backgroundColor = UIColor.clear
        return image
    }()
    
    public let textLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 22)
        label.text = "Tarjeta"
        return label
    }()
    
    private func setupView(){
        addSubview(imageView)
        addSubview(textLabel)
        imageView.size(CGSize(width: 100, height: 50))
        imageView.centerInSuperview()
        textLabel.size(CGSize(width: frame.width, height: 50))
        textLabel.bottomToSuperview()
        textLabel.centerX(to: imageView)
    }
}
