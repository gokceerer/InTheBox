//
//  PopUpViewWithTextFieldVC.swift
//  InTheBox
//
//  Created by G on 2023-04-14.
//

import Foundation
import UIKit

class PopUpWithTextFieldVC: UIViewController {

    private let popUpView = PopUpWithTextField()
    private var buttonAction: ((String) -> ())?
    
    init(title: String, buttonText: String, buttonAction: @escaping (String) -> ()) {
        super.init(nibName: nil, bundle: nil)
        modalTransitionStyle = .crossDissolve
        modalPresentationStyle = .overCurrentContext
        
        popUpView.popUpTitle.text = title
        popUpView.popUpButton.setAttributedTitle(        NSAttributedString(string: buttonText), for: .normal)
        popUpView.popUpButton.addTarget(self, action: #selector(dismissView), for: .touchUpInside)
        view = popUpView
        self.buttonAction = buttonAction
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    @objc func dismissView(){
        self.dismiss(animated: true, completion: nil)
        guard let buttonAction = buttonAction else { return }
        buttonAction(popUpView.popUpTextField.text ?? "")
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let firstTouch = touches.first {
            let hitView = self.view.hitTest(firstTouch.location(in: self.view), with: event)

            if hitView !== popUpView.popUpBackground {
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
}
