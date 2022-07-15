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
    typealias DiffableDataSource = UICollectionViewDiffableDataSource<Section, Movie>
    private lazy var difDataSource = createDifDataSource()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        indicatorConstraints()
        detailsTableView.registerNib(class: DetailsCell.self)
        
        movieCollectionView.delegate = self
        movieCollectionView.registerNib(class: MovieCollectionViewCell.self)
        updateDataSource()
    }
    
    // ADD constaints To UIActivityIndicatorView
    func indicatorConstraints() {
        let indicatorConst = [
            indicatorForLoadDetail.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            indicatorForLoadDetail.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
        ]
        NSLayoutConstraint.activate(indicatorConst)
    }
    
    // MARK:- Create Collection view Cell using UICollectionViewDiffableDataSource class
    func createDifDataSource() -> DiffableDataSource {
        let diffDataSource = DiffableDataSource(collectionView: movieCollectionView) { (collectionView, indexPath, _) -> UICollectionViewCell? in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieCollectionViewCell", for: indexPath)
                    as? MovieCollectionViewCell else { return UICollectionViewCell() }
            cell.setupView(with: self.arrayOfFilteredMovies[indexPath.row])
            return cell
        }
        return diffDataSource
    }
    
    func updateDataSource() {
        var screenShot = NSDiffableDataSourceSnapshot<Section, Movie>()
        screenShot.appendSections([.main])
        screenShot.appendItems(arrayOfFilteredMovies, toSection: .main)
        difDataSource.apply(screenShot)
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

extension DetailsViewController:  UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
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
