import UIKit

class DetailsViewController: UIViewController {
    
    // MARK:- IBOutlets
    @IBOutlet weak var detailsTableView: UITableView!
    @IBOutlet weak var movieCollectionView: UICollectionView!
    @IBOutlet weak var indicatorForLoadDetail: UIActivityIndicatorView! {
        didSet {
            indicatorForLoadDetail.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    // MARK:- Class Properties
    public var movie: Movie!
    public var arrayOfFilteredMovies: [Movie] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        indicatorConstraints()
        detailsTableView.registerNib(class: DetailsCell.self)
        movieCollectionView.dataSource = self
        movieCollectionView.delegate = self
        movieCollectionView.registerNib(class: MovieCollectionViewCell.self)
    }

    // ADD constaints To UIActivityIndicatorView

    func indicatorConstraints() {
        let indicatorConst = [
            indicatorForLoadDetail.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            indicatorForLoadDetail.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
        ]
        NSLayoutConstraint.activate(indicatorConst)
        
    }
}

// MARK:- EXTENTION
extension DetailsViewController: UITableViewDataSource, UITableViewDelegate, DetailsCellDelegate {

    // MARK:- TableView function
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { 1 }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: DetailsCell.identifier, for: indexPath) as? DetailsCell else { return UITableViewCell() }
        cell.setupView(with: movie)
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat { self.view.bounds.height }
    
    // MARK:- Protocol function
    func changeFavorite() {
        self.movie?.isFavourite.toggle()
        self.detailsTableView.reloadData()
    }
}

extension DetailsViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        arrayOfFilteredMovies.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let collectionCell = movieCollectionView.dequeueReusableCell(withReuseIdentifier: "MovieCollectionViewCell", for: indexPath) as? MovieCollectionViewCell else { return UICollectionViewCell() }
        collectionCell.setupView(with: arrayOfFilteredMovies[indexPath.row])
        return collectionCell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: self.view.bounds.width, height: 300)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.movie = arrayOfFilteredMovies[indexPath.row]
        loadDetail()
    }
    
    func loadDetail() {
        indicatorForLoadDetail.startAnimating()
        self.detailsTableView.alpha = 0
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.detailsTableView.alpha = 1
            self.indicatorForLoadDetail.stopAnimating()
            self.detailsTableView.reloadData()
        }

    }
}
