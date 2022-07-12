import UIKit

class DetailsViewController: UIViewController {
    
    @IBOutlet weak var detailsTableView: UITableView!
    
    public var movie: Movie?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        detailsTableView.register(UINib(nibName: "DetailsCell", bundle: nil), forCellReuseIdentifier: DetailsCell.identifier)
        navigationController?.navigationBar.isHidden = false
        navigationItem.title = "MOVIE DETAILS"
    }
    
}
extension DetailsViewController: UITableViewDataSource, UITableViewDelegate, DetailsCellDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { 1 }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: DetailsCell.identifier, for: indexPath) as? DetailsCell else { return UITableViewCell() }
        cell.titleLb.text = movie?.title
        cell.actorLb.text = movie?.mainActor
        cell.dateLb.text = movie?.releaseDate
        cell.imbdLb.text = "\(movie?.imdb ?? 0)"
        cell.descripstionTextView.text = movie!.description
        let seenImage = UIImage(systemName: movie?.seen ?? false ? "eye.fill" : "eye.slash")?.withRenderingMode(.alwaysOriginal)
        let favoriteImage = UIImage(systemName: movie?.isFavourite ?? false ? "star.fill" : "star")?.withRenderingMode(.alwaysOriginal)
        cell.seenBtn.setImage(seenImage, for: .normal)
        cell.favoriteBtn.setImage(favoriteImage, for: .normal)
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat { self.view.bounds.height }

    func changeFavorite() {
        self.movie?.isFavourite.toggle()
        self.detailsTableView.reloadData()
    }
    

}
