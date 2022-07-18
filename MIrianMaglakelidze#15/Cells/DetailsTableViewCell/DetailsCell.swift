
import UIKit
protocol DetailsCellDelegate: AnyObject {
    func changeFavorite()
}

class DetailsCell: UITableViewCell, UITextViewDelegate {
    
    @IBOutlet weak var filmPoster: UIImageView! {
        didSet {
            filmPoster.layer.cornerRadius = 10
        }
    }
    @IBOutlet weak var descripstionTextView: UITextView!
    @IBOutlet weak var titleLb: UILabel!
    @IBOutlet weak var dateLb: UILabel!
    @IBOutlet weak var actorLb: UILabel!
    @IBOutlet weak var imbdLb: UILabel!
    @IBOutlet weak var genreLb: UILabel!
    @IBOutlet weak var favoriteBtn: UIButton!
    @IBOutlet weak var seenBtn: UIButton!
    @IBOutlet weak var showHideContent: UIButton!
    @IBOutlet weak var textViewHeightConstraint: NSLayoutConstraint!
    
    weak var delegate: DetailsCellDelegate?
     private var descriptionStr: String = ""
    override func awakeFromNib() {
        super.awakeFromNib()
        descripstionTextView.delegate = self
    }
    
    @IBAction func favoriteBtnTapped(_ sender: Any) {
        delegate?.changeFavorite()
    }
    @IBAction func showOrHideTextViewContent(_ sender: UIButton) {
        if sender.tag == 0 {
            textViewHeightConstraint.constant = getTextViewHeightAccordingTo(content: self.descriptionStr)
            sender.setTitle("Show less", for: .normal)
            sender.tag = 1
        } else {
            textViewHeightConstraint.constant = 60
            sender.setTitle("Show more", for: .normal)
            sender.tag = 0
        }
    }
    
    func getTextViewHeightAccordingTo(content strText: String) -> CGFloat {
        let textView : UITextView! = UITextView(
            frame: CGRect(x: self.descripstionTextView.frame.origin.x,
                          y: 0, width: self.descripstionTextView.frame.size.width,
                          height: 0))
        textView.text = strText
        textView.font = UIFont(name: "Fira Sans", size:  12.0)
        textView.sizeToFit()
        
        var txt_frame : CGRect! = CGRect()
        txt_frame = textView.frame
        
        var size : CGSize! = CGSize()
        size = txt_frame.size

        size.height = 10 + txt_frame.size.height
        
        return size.height
    }
    
    public func setupView(with movie: Movie) {
        self.showHideContent.setTitle("Show more", for: .normal)
        self.showHideContent.tag = 0
        self.textViewHeightConstraint.constant = 60
        self.descriptionStr = movie.description
        self.titleLb.text = movie.title
        self.actorLb.text = movie.mainActor
        self.dateLb.text = movie.releaseDate
        self.imbdLb.text = "\(movie.imdb)"
        self.descripstionTextView.text = movie.description
        //        self.genreLb.text = movie.gener.rawValue
        let seenImage = UIImage(systemName: movie.seen ? "eye.fill" : "eye.slash")?.withRenderingMode(.alwaysOriginal).withTintColor(.white)
        let favoriteImage = UIImage(systemName: movie.isFavourite ? "heart.fill" : "heart")?.withRenderingMode(.alwaysOriginal).withTintColor(movie.isFavourite ? .systemYellow : .white)
        self.seenBtn.setImage(seenImage, for: .normal)
        self.favoriteBtn.setImage(favoriteImage, for: .normal)
    }
    
}
