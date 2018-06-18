import UIKit

class MetroInfoView: NibView {
    
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var label: UILabel!
    
    
    func setupView(with color: UIColor, text: String) {
        iconImageView?.image = iconImageView?.image?.maskWithColor(color: color)
        label.text = text
    }
}
