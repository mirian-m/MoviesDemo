
import UIKit
protocol DetailsCellDelegate: AnyObject {
    func changeFavorite()
}

class DetailsCell: UITableViewCell, UITextViewDelegate {

    @IBOutlet weak var descripstionTextView: UITextView!
    @IBOutlet weak var titleLb: UILabel!
    @IBOutlet weak var dateLb: UILabel!
    @IBOutlet weak var actorLb: UILabel!
    @IBOutlet weak var imbdLb: UILabel!
    @IBOutlet weak var genreLb: UILabel!
    @IBOutlet weak var favoriteBtn: UIButton!
    @IBOutlet weak var seenBtn: UIButton!
    
    weak var delegate: DetailsCellDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
        descripstionTextView.delegate = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func favoriteBtnTapped(_ sender: Any) {
        delegate?.changeFavorite()
    }
    
    public func setupView(with movie: Movie) {
        self.titleLb.text = movie.title
        self.actorLb.text = movie.mainActor
        self.dateLb.text = movie.releaseDate
        self.imbdLb.text = "\(movie.imdb)"
        self.descripstionTextView.text = movie.description
        self.genreLb.text = movie.gener.rawValue
        let seenImage = UIImage(systemName: movie.seen ? "eye.fill" : "eye.slash")?.withRenderingMode(.alwaysOriginal)
        let favoriteImage = UIImage(systemName: movie.isFavourite ? "star.fill" : "star")?.withRenderingMode(.alwaysOriginal)
        self.seenBtn.setImage(seenImage, for: .normal)
        self.favoriteBtn.setImage(favoriteImage, for: .normal)
    }

}
