import UIKit

class NibView: UIView {
    class func instanceFromNib() -> UIView {
        return UINib(nibName: "nib file name", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! UIView
    }
}
