//
//  IconSelectionCollectionViewCell.swift
//  InTheBox
//
//  Created by G on 2023-04-18.
//

import UIKit

class IconSelectionCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var iconButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func updateCell(with icon: UIImage?) {
        guard let icon = icon else { return }
        iconButton.setImage(icon, for: .normal)
    }
    
    func setSelected(_ isSelected: Bool) -> UIImage? {
        if isSelected {
            iconButton.tintColor = UIColor(red:247/255,green:142/255,blue:85/255, alpha: 1)
        } else {
            iconButton.tintColor = UIColor.black
        }
        return iconButton.currentImage
    }
}
