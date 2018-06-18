import UIKit

class ObjectImageCollectionViewCell: UICollectionViewCell {
    
    
    @IBOutlet weak var imageView: UIImageView! {
        didSet {
            guard let image = image else { return }
            imageView.image = image
        }
    }
    
    private var image: UIImage!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        guard let image = image else { return }
        imageView.image = image
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        guard let image = image else { return }
        imageView?.image = image
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        guard let image = image else { return }
        imageView?.image = image
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        guard let image = image else { return }
        imageView?.image = image
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        guard let image = image else { return }
        imageView?.image = image
    }
    
    func setupWithImage(_ image: UIImage) {
        self.image = image
        imageView?.image = image
    }
    
}
