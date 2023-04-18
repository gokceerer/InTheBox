//
//  PopUpViewWithTextField.swift
//  InTheBox
//
//  Created by G on 2023-04-14.
//

import UIKit

//TODO: Will be rewritten like PopUpWithIconSelectionAndTextField
class PopUpWithTextField: UIView {
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var popUpTitle: UILabel!
    @IBOutlet weak var popUpTextField: UITextField!
    @IBOutlet weak var popUpButton: UIButton!
    @IBOutlet weak var popUpBackground: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
      }
      
      required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
      }

      private func setupView() {
          Bundle.main.loadNibNamed("PopUpWithTextField", owner: self, options: nil)
          contentView.frame = self.bounds
          contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
          addSubview(contentView)
          popUpBackground.layer.cornerRadius = 20
          popUpBackground.layer.masksToBounds = true
          popUpTextField.layer.borderWidth = 1.0
          popUpTextField.layer.borderColor = UIColor.gray.cgColor
          popUpTextField.layer.cornerRadius = 10
          self.popUpButton.layer.cornerRadius = 10

      }
}
