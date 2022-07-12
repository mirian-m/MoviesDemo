
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
    @IBOutlet weak var favoriteBtn: UIButton!
    @IBOutlet weak var seenBtn: UIButton!
    
    weak var delegate: DetailsCellDelegate?
    
    static let identifier = "DetailsCell"
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
}
