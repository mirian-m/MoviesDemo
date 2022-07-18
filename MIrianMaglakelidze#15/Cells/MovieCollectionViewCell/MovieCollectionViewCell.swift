
import UIKit

class MovieCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var uiView: UIView! {
        didSet {
            uiView.layer.cornerRadius = 10
            uiView.layer.borderWidth = 1
            uiView.layer.borderColor = UIColor.clear.cgColor
        }
    }
    
    @IBOutlet weak var posterImage: UIImageView! {
        didSet {
            posterImage.layer.cornerRadius = 10
        }
    }
    @IBOutlet weak var titleLb: UILabel!
    @IBOutlet weak var genreLb: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    public func setupView(with movie: Movie) {
        self.posterImage.image = UIImage(named: "defaultImage")
        self.titleLb.text = movie.title
        self.genreLb.text = movie.gener.rawValue
    }
    
}
