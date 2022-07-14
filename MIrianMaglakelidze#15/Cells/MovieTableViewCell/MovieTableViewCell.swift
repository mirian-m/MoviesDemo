
import UIKit

protocol MovieTableViewCellDelegate: AnyObject {
    func seenBtnTapped(cell: MovieTableViewCell)
}
class MovieTableViewCell: UITableViewCell {
    @IBOutlet weak var titleLb: UILabel!
    @IBOutlet weak var imbdLB: UILabel!
    @IBOutlet weak var seenBtn: UIButton!
    @IBOutlet weak var filmPosterImage: UIImageView! {
        didSet {
            filmPosterImage.layer.cornerRadius = 5
        }
    }

    weak var delegate: MovieTableViewCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
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
}
