//
//  MicButton.swift
//  WeatherVoice
//
//  Created by Ed Negro on 10.10.18.
//  Copyright © 2018 Etienne Negro. All rights reserved.
//

import UIKit

protocol MicButtonDelegate {
    func didTouchInside()
    func didTouchUpInside()
}

@IBDesignable
class MicButton: UIButton {

    var touchDelegate: MicButtonDelegate?

    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        customizeButton()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        customizeButton()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        customizeButton()
    }

    func customizeButton() {
        layer.cornerRadius = self.frame.width / 2
        layer.masksToBounds = true
        layer.borderColor = UIColor.red.cgColor

        addTarget(self, action: #selector(MicButton.didStartRecording), for: .touchDown)
        addTarget(self, action: #selector(MicButton.didFinishRecording), for: .touchUpInside)
    }

    @objc func didStartRecording() {
        layer.borderWidth = 2.0
        touchDelegate?.didTouchInside()
    }

    @objc func didFinishRecording () {
        layer.borderWidth = 0
        touchDelegate?.didTouchUpInside()
    }

}

