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
    typealias DiffableCollectionViewDataSource = UICollectionViewDiffableDataSource<Section, Movie>
    typealias DiffableTableViewDataSource = UITableViewDiffableDataSource<Section, Movie>
    private lazy var collectionViewDataSource = createCollectionViewDataSource()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        indicatorConstraints()
        detailsTableView.registerNib(class: DetailsCell.self)
        
        movieCollectionView.delegate = self
        movieCollectionView.registerNib(class: MovieCollectionViewCell.self)
        updateCollectionViewDataSource()
    }
    
    // ADD constaints To UIActivityIndicatorView
    func indicatorConstraints() {
        let indicatorConst = [
            indicatorForLoadDetail.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            indicatorForLoadDetail.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
        ]
        NSLayoutConstraint.activate(indicatorConst)
    }
    
    // MARK:- Create CollectionView DataSource
    func createCollectionViewDataSource() -> DiffableCollectionViewDataSource {
        let diffDataSource = DiffableCollectionViewDataSource(collectionView: movieCollectionView) { (collectionView, indexPath, Movie) -> UICollectionViewCell? in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieCollectionViewCell.identifier, for: indexPath) as? MovieCollectionViewCell else { return UICollectionViewCell() }
            
            cell.setupView(with: self.arrayOfFilteredMovies[indexPath.row])
            return cell
        }
        return diffDataSource
    }
    
    func updateCollectionViewDataSource() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Movie>()
        snapshot.appendSections([.main])
        snapshot.appendItems(arrayOfFilteredMovies, toSection: .main)
        collectionViewDataSource.apply(snapshot)
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
        CGSize(width: self.view.bounds.width, height: 160)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        // Check if it is captured on the same film as the opened on detailsTableView
        if self.movie != arrayOfFilteredMovies[indexPath.row] {
            self.movie = arrayOfFilteredMovies[indexPath.row]
            loadDetail()
        }
    }
    
    func loadDetail() {
        indicatorForLoadDetail.startAnimating()
        self.detailsTableView.alpha = 0
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
            self?.detailsTableView.alpha = 1
            self?.indicatorForLoadDetail.stopAnimating()
            self?.detailsTableView.reloadData()
        }
        
    }
}
