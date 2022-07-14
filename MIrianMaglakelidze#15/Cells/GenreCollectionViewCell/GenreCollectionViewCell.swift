import UIKit

class GenreCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var uiView: UIView! {
        didSet {
            uiView.layer.cornerRadius = 10
            uiView.layer.borderWidth = 1
        }
    }
    @IBOutlet weak var generLb: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
