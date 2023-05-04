//
//  PopUpViewWithTextField.swift
//  InTheBox
//
//  Created by G on 2023-04-14.
//

import UIKit

//TODO: Will be rewritten like PopUpWithIconSelectionAndTextField
class PopUpWithTextField: UIViewController {
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var popUpTitle: UILabel!
    @IBOutlet weak var popUpTextField: UITextField!
    @IBOutlet weak var popUpButton: UIButton!
    @IBOutlet weak var backgroundView: UIView!
    
    private var buttonAction: ((String) -> ())?
    private var popUpTitleString: String?
    private var buttonText: String?
    private var placeholderText: String?
    
    init(title: String, buttonText: String, placeholderText: String? = nil, buttonAction: ((String) -> ())? = nil) {
        super.init(nibName: "PopUpWithTextField", bundle: nil)
        self.modalTransitionStyle = .crossDissolve
        self.modalPresentationStyle = .overCurrentContext
        self.buttonAction = buttonAction
        self.popUpTitleString = title
        self.buttonText = buttonText
        self.placeholderText = placeholderText
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        self.contentView.layer.cornerRadius = 20
        self.contentView.layer.masksToBounds = true
        self.popUpTextField.layer.borderWidth = 1.0
        self.popUpTextField.layer.borderColor = UIColor.gray.cgColor
        self.popUpTextField.layer.cornerRadius = 10
        self.popUpTextField.text = placeholderText
        self.popUpButton.layer.cornerRadius = 10
        self.popUpTitle.text = self.popUpTitleString
        self.popUpButton.setAttributedTitle(        NSAttributedString(string: self.buttonText ?? ""), for: .normal)
        self.popUpButton.addTarget(self, action: #selector(popUpButtonTapped), for: .touchUpInside)

    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let firstTouch = touches.first {
            let hitView = self.view.hitTest(firstTouch.location(in: self.view), with: event)

            if hitView === backgroundView {
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    @objc func popUpButtonTapped() {
        guard let buttonAction = buttonAction,
              let text = popUpTextField.text
        else { return }
        
        buttonAction(text)
        self.dismiss(animated: true, completion: nil)
    }
}
