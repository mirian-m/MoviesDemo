
import UIKit

protocol MovieTableViewCellDelegate: AnyObject {
    func favoriteBtnTapped(cell: MovieTableViewCell)
}
class MovieTableViewCell: UITableViewCell {
    @IBOutlet weak var titleLb: UILabel!
    @IBOutlet weak var imbdLB: UILabel!
    @IBOutlet weak var seenBtn: UIButton!
    @IBOutlet weak var filmPosterImage: UIImageView!
    static let identifier = "MoveTableViewCell"
    weak var delegate: MovieTableViewCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func favoriteTapped(_ sender: Any) {
        delegate?.favoriteBtnTapped(cell: self)
    }
    
}
