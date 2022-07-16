
import UIKit

class CustomView: UIView {
    static let identifier = "CustomView"
    
    @IBOutlet weak var backGroundView: UIView! {
        didSet {
            backGroundView.layer.cornerRadius = 10
        }
    }
    @IBOutlet weak var titleLb: UILabel!
}
