
import UIKit

protocol MovieTableViewCellDelegate: AnyObject {
    func seenBtnTapped(cell: MovieTableViewCell)
}
class MovieTableViewCell: UITableViewCell {
    @IBOutlet weak var imbdTitle: UILabel!
    @IBOutlet weak var view: UIView!
    @IBOutlet weak var titleLb: UILabel!
    @IBOutlet weak var imbdLB: UILabel! 
    @IBOutlet weak var seenBtn: UIButton!
    @IBOutlet weak var filmPosterImage: UIImageView! 
    
    weak var delegate: MovieTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    @IBAction func favoriteTapped(_ sender: Any) {
        delegate?.seenBtnTapped(cell: self)
    }
    
    public func setupMovieTableViewCell(_ movie: Movie) {
        let image = UIImage(systemName: movie.seen ? "eye.fill" : "eye.slash")?.withRenderingMode(.alwaysOriginal)
        self.seenBtn.setImage(image, for: .normal)
        self.titleLb.text = movie.title
        self.imbdLB.text = "\(movie.imdb)"
        self.filmPosterImage.image = UIImage(named: "defaultImage")
        
    }
    override func layoutSubviews() {
        self.filmPosterImage!.layer.sublayers?.forEach { $0.removeFromSuperlayer() }
        self.filmPosterImage.addBottomGradient()
        self.filmPosterImage.layer.cornerRadius = 10
        self.imbdTitle.layer.borderWidth = 1
        self.imbdTitle.layer.borderColor = UIColor.white.cgColor

    }
}
