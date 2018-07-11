//
//  Helper.swift
//  Poc.Mauro.Bianchelli
//
//  Created by Mauro on 10/7/18.
//  Copyright © 2018 Mauro. All rights reserved.
//

import Foundation
import Lottie


class Helper{
    
    static let animation = LOTAnimationView(name: "animation")
    
    
    
    static func initAnimation(view:UIView){
        
        
        let size:CGFloat = 251
        let screenWidth = view.frame.size.width
        animation.contentMode = .scaleAspectFill
        animation.frame = CGRect(x: screenWidth / 2 - size / 2, y: 10 , width: size, height: size)
        view.addSubview(animation)
    }
    
    static func startAnimating(){
        animation.loopAnimation = true
        animation.play()
    }

    static func stopAnimating(){
        animation.stop()
    }
}
