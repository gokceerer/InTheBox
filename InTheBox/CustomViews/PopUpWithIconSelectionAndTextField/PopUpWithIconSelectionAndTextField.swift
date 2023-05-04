//
//  PopUpWithIconSelectionAndTextField.swift
//  InTheBox
//
//  Created by G on 2023-04-18.
//

import UIKit


class PopUpWithIconSelectionAndTextField: UIViewController {

    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var iconCollectionView: UICollectionView!
    @IBOutlet weak var popUpButton: UIButton!
    @IBOutlet weak var reminderTextField: UITextField!
    
    private var buttonAction: ((UIImage, String) -> ())?
    private var placeholderIcon: UIImage?
    private var placeholderText: String?
    private var selectedIcon: UIImage?
    private let iconList: [UIImage?] = [UIImage(systemName: "birthday.cake.fill"),
                                        UIImage(systemName: "clock.fill"),
                                        UIImage(systemName: "banknote.fill"),
                                        UIImage(systemName: "airplane"),
                                        UIImage(systemName: "pills.fill"),
                                        UIImage(systemName: "calendar"),
                                        UIImage(systemName: "drop.fill"),
                                        UIImage(systemName: "envelope.fill"),
                                        UIImage(systemName: "leaf.fill"),
                                        UIImage(systemName: "shower.handheld.fill"),
                                        UIImage(systemName: "heart.circle.fill"),
                                        UIImage(systemName: "person.2.fill"),
                                        UIImage(systemName: "stethoscope")]
    
    init(placeholderIcon: UIImage? = nil, placeholderText: String? = nil, buttonAction: ((UIImage, String) -> ())? = nil) {
        super.init(nibName: "PopUpWithIconSelectionAndTextField", bundle: nil)
        self.modalTransitionStyle = .crossDissolve
        self.modalPresentationStyle = .overCurrentContext
        self.buttonAction = buttonAction
        self.placeholderIcon = placeholderIcon
        self.placeholderText = placeholderText
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.popUpButton.addTarget(self, action: #selector(popUpButtonTapped), for: .touchUpInside)
        self.iconCollectionView.delegate = self
        self.iconCollectionView.dataSource = self
        self.iconCollectionView
            .register(UINib(nibName: "IconSelectionCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "IconSelectionCollectionViewCell")
        
        self.contentView.layer.cornerRadius = 20
        self.contentView.layer.masksToBounds = true
        self.reminderTextField.layer.borderWidth = 1.0
        self.reminderTextField.layer.borderColor = UIColor.gray.cgColor
        self.reminderTextField.layer.cornerRadius = 10
        self.popUpButton.layer.cornerRadius = 10
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
              let text = reminderTextField.text,
              let icon = self.selectedIcon
        else { return }
        
        buttonAction(icon, text)
        self.dismiss(animated: true, completion: nil)
    }
}

extension PopUpWithIconSelectionAndTextField: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        iconList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = iconCollectionView.dequeueReusableCell(withReuseIdentifier: "IconSelectionCollectionViewCell", for: indexPath) as? IconSelectionCollectionViewCell else {
            fatalError("Unable to dequeue a IconSelectionCollectionViewCell")
        }
        cell.updateCell(with: iconList[indexPath.row])
        if let placeholderIcon = placeholderIcon, let placeholderText = placeholderText {
            self.reminderTextField.text = placeholderText
            
            if placeholderIcon == iconList[indexPath.row] {
                self.selectedIcon = cell.setSelected(true)
            }
        } else {
            if self.selectedIcon == nil && indexPath.row == 0 {
                self.selectedIcon = cell.setSelected(true)
            }
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        for i in 0...iconList.count-1 {
            guard let cell = iconCollectionView.cellForItem(at: IndexPath(row: i, section: 0)) as? IconSelectionCollectionViewCell else { return }
            _ = cell.setSelected(false)
        }
        
        guard let cell = iconCollectionView.cellForItem(at: indexPath) as? IconSelectionCollectionViewCell else { return }
        self.selectedIcon = cell.setSelected(true)
    }
}
