//
//  WeatherViewController.swift
//  AutolabsTask
//
//  Created by Rab Gábor on 2018. 07. 25..
//  Copyright © 2018. Rab Gábor. All rights reserved.
//

import UIKit

class WeatherViewController: UIViewController {

    var background1ImageView = UIImageView()
    var background2ImageView = UIImageView()
    var background3ImageView = UIImageView()

    var userMessageLabel = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()

        background1ImageView.transform = CGAffineTransform(translationX: 0, y: UIScreen.main.bounds.height)
        background2ImageView.transform = CGAffineTransform(translationX: 0, y: UIScreen.main.bounds.height)

        userMessageLabel.alpha = 0.0

        placeParallaxImageView(background3ImageView, motionEffectRatio: 0.02)
        placeParallaxImageView(background2ImageView, motionEffectRatio: 0.045)
        placeParallaxImageView(background1ImageView, motionEffectRatio: 0.08)

        placeUserMessageLabel()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        UIView.animate(withDuration: 0.9,
                       delay: 0.0,
                       options: .curveEaseOut,
                       animations: { self.background1ImageView.transform = CGAffineTransform.identity }
        )

        UIView.animate(withDuration: 0.9,
                       delay: 0.2,
                       options: .curveEaseOut,
                       animations: { self.background2ImageView.transform = CGAffineTransform.identity }
        )

        UIView.animate(withDuration: 0.5,
                       delay: 0.6,
                       animations: { self.userMessageLabel.alpha = 1 }
        )
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    func placeParallaxImageView(_ imageView: UIImageView, motionEffectRatio: CGFloat) {
        view.addSubview(imageView)

        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false

        let smallerEdge = min(UIScreen.main.bounds.height, UIScreen.main.bounds.width)
        let horizontalMotionEffectConstant = smallerEdge * motionEffectRatio
        let verticalMotionEffectConstant = smallerEdge * motionEffectRatio

        imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: -horizontalMotionEffectConstant).isActive = true
        imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: horizontalMotionEffectConstant).isActive = true
        imageView.topAnchor.constraint(equalTo: view.topAnchor, constant: -verticalMotionEffectConstant).isActive = true
        imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: verticalMotionEffectConstant).isActive = true

        imageView.clipsToBounds = true

        let horizontalMotionEffect = UIInterpolatingMotionEffect(keyPath: "layer.position.x", type: .tiltAlongHorizontalAxis)
        horizontalMotionEffect.minimumRelativeValue = -horizontalMotionEffectConstant
        horizontalMotionEffect.maximumRelativeValue = horizontalMotionEffectConstant
        imageView.addMotionEffect(horizontalMotionEffect)

        let verticalMotionEffect = UIInterpolatingMotionEffect(keyPath: "layer.position.y", type: .tiltAlongVerticalAxis)
        verticalMotionEffect.minimumRelativeValue = -verticalMotionEffectConstant
        verticalMotionEffect.maximumRelativeValue = verticalMotionEffectConstant
        imageView.addMotionEffect(verticalMotionEffect)
    }

    func placeUserMessageLabel() {
        view.addSubview(userMessageLabel)

        let smallerEdge = min(UIScreen.main.bounds.height, UIScreen.main.bounds.width)
        let sizeRatio: CGFloat = 0.9

        userMessageLabel.textColor = .white
        userMessageLabel.adjustsFontSizeToFitWidth = true
        userMessageLabel.textAlignment = .center
        userMessageLabel.font = UIFont.boldSystemFont(ofSize: 60.0)

        userMessageLabel.translatesAutoresizingMaskIntoConstraints = false
        userMessageLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        userMessageLabel.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        userMessageLabel.bottomAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        userMessageLabel.widthAnchor.constraint(equalToConstant: smallerEdge * sizeRatio).isActive = true
    }
}
