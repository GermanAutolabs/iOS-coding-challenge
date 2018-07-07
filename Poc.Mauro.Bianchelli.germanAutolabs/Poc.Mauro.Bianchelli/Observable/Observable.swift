//
//  Observable.swift
//  Poc.Mauro.Bianchelli
//
//  Created by Mauro on 15/5/18.
//  Copyright © 2018 Mauro. All rights reserved.
//

import Foundation

class Observable<T>{
    typealias Listener = (T) -> Void
    var listener: Listener?
    var value:T{
        didSet{
            listener?(value)
        }
    }
    
    
    init(_ value: T){
        self.value = value
    }
    
    func bind(listener:Listener?){
        self.listener = listener
        listener?(value)
    }
}
