
import UIKit
class MoviesViewController: UIViewController {
    
    // MARK:- IBoutlet
    @IBOutlet weak var generCollectionView: UICollectionView!
    @IBOutlet weak var moviesTableView: UITableView!
    @IBOutlet weak var favoriteBtn: UIButton! {
        didSet {
            favoriteBtn.backgroundColor = .none
            favoriteBtn.layer.cornerRadius = 10
        }
    }
    @IBOutlet weak var seenBtn: UIButton! {
        didSet {
            seenBtn.backgroundColor = .none
            seenBtn.layer.cornerRadius = 10
        }
    }
    
    // MARK: - Properties
    private var movies: [Movie] = [
        Movie(title: "Avatar", releaseDate: "18 Dec 2009", imdb: 7.9, mainActor: "Sam Worthington", seen: true, isFavourite: false, gener: .action),
        Movie(title: "I Am Legend", releaseDate: "14 Dec 2007", imdb: 7.2, mainActor: "Will Smith", seen: false, isFavourite: true, gener: .comedy),
        Movie(title: "300", releaseDate: "09 Mar 2007", imdb: 7.7, mainActor: "Gerard Butler", seen: true, isFavourite: true, gener: .action),
        Movie(title: "The Avengers", releaseDate: "04 May 2012", imdb: 8.1, mainActor: "Robert Downey Jr.", seen: false, isFavourite: false, gener: .drama),
        Movie(title: "Interstellar", releaseDate: "07 Nov 2014", imdb: 8.6, mainActor: "Ellen Burstyn", seen: true, isFavourite: false, gener: .comedy),
        Movie(title: "Game of Thrones", releaseDate: "17 Apr 2011", imdb: 9.5, mainActor: "Peter Dinklage", seen: true, isFavourite: true, gener: .action),
        Movie(title: "Breaking Bad", releaseDate: "20 Jan 2008", imdb: 9.5, mainActor: "Bryan Cranston", seen: true, isFavourite: true, gener: .drama),
        Movie(title: "Narcos", releaseDate: "28 Aug 2015", imdb: 8.9, mainActor: "Wagner Moura", seen: false, isFavourite: false, gener: .action),
        Movie(title: "Power", releaseDate: "01 Aug 2014", imdb: 8.0, mainActor: "Omari Hardwick", seen: false, isFavourite: false, gener: .comedy),
        Movie(title: "Gotham", releaseDate: "01 Aug 2014", imdb: 8.0, mainActor: "Ben McKenzie", seen: false, isFavourite: false, gener: .comedy)
    ]
    
    private var myMovies: [Int: [Movie]] = [:]
    private var genre = ["all", "comedy", "action", "drama"]
    private var selectedCells: [IndexPath] = []
    typealias DiffableDataSource = UICollectionViewDiffableDataSource<Section, String>
    private lazy var differDataSource: DiffableDataSource = createDifDataSource()
    
    // MARK:- Controller life cycle Function
    override func viewDidLoad() {
        super.viewDidLoad()
        configTableViewAndCollectionView()
        navigationItem.title = "MOVIES"
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        updateTableView()
    }
    
    // MARK:- Class Function
    func configTableViewAndCollectionView() {
        moviesTableView.dataSource = self
        moviesTableView.delegate = self
        moviesTableView.registerNib(class: MovieTableViewCell.self)
        
        generCollectionView.delegate = self
        generCollectionView.registerNib(class: GenreCollectionViewCell.self)
        updatedataSource()
    }
    
    // MARK:- CREATION OF DifDataSource
    func createDifDataSource() -> DiffableDataSource {
        differDataSource = UICollectionViewDiffableDataSource(collectionView: generCollectionView, cellProvider: { (collectionView, indexPath, _) -> UICollectionViewCell? in
            
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GenreCollectionViewCell", for: indexPath) as? GenreCollectionViewCell else { return UICollectionViewCell() }
            
            cell.generLb.text = self.genre[indexPath.row].upperCasedFirstLetter()
            return cell
        })
        return differDataSource
    }
    
    func updatedataSource() {
        var screenshot = NSDiffableDataSourceSnapshot<Section, String>()
        screenshot.appendSections([.main])
        screenshot.appendItems(genre, toSection: .main)
        differDataSource.apply(screenshot)
    }
}

// MARK: - EXTENSION
extension MoviesViewController: UITableViewDataSource, UITableViewDelegate, MovieTableViewCellDelegate {
    
    // MARK: - Protocol function
    func seenBtnTapped(cell: MovieTableViewCell) {
        guard let indexPath = moviesTableView.indexPath(for: cell) else { return }
        guard let myMovie = myMovies[indexPath.section]?[indexPath.row] else { return }
        myMovie.seen.toggle()
        updateTableView()
    }
    
    // MARK: - TableView Methods
    func numberOfSections(in tableView: UITableView) -> Int {
        myMovies.keys.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        myMovies[section]?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MovieTableViewCell.identifier, for: indexPath) as? MovieTableViewCell else { return UITableViewCell() }
        if let movie = myMovies[indexPath.section]?[indexPath.row] {
            cell.setupMovieTableViewCell(movie)
            cell.delegate = self
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let headerView = Bundle.main.loadNibNamed("CustomView", owner: nil, options: nil)?.first as? CustomView else { return UIView() }
        if section == 0 {
            headerView.backGroundView.backgroundColor = .green
            headerView.titleLb.text = "Seen Films"
        } else {
            headerView.backGroundView.backgroundColor = .red
            headerView.titleLb.text = "Not Seen Films"
        }
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat { 500 }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat { 60 }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        moviesTableView.deselectRow(at: indexPath, animated: true)
        moveToDetails(indexPath: indexPath)
    }
    
    // MARK:- Button function
    @IBAction func favoriteBtnTapped(_ sender: UIButton) {
        if sender.backgroundColor == .none {
            sender.backgroundColor = .systemBlue
        } else {
            sender.backgroundColor = .none
        }
        updateTableView()
    }
    
    // MARK:- class methods
    private func moveToDetails(indexPath: IndexPath) {
        guard let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DetailsViewController") as? DetailsViewController else { return }
        guard let movie = myMovies[indexPath.section]?[indexPath.row] else { return }
        vc.movie = movie
        vc.arrayOfFilteredMovies = movies.filter({ $0.gener.rawValue == movie.gener.rawValue })
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    // MARK:- Updeate view Functions
    func updateTableView() {
        var selectedGenre: [String] = []
        selectedCells.forEach { index in
            selectedGenre.append(genre[index.row])
        }
        (selectedGenre.isEmpty || selectedGenre.contains("all")) ? checkFilterButton(array: movies)
            : checkFilterButton(array: movies.filter({ selectedGenre.contains($0.gener.rawValue) }))
        moviesTableView.reloadData()
    }
    
    fileprivate func fillMyMovies(from movies: [Movie]) {
        myMovies[0] = movies.filter({ $0.seen })
        myMovies[1] = movies.filter({ !$0.seen })
        
    }
    
    func checkFilterButton(array: [Movie]) {
        if seenBtn.backgroundColor == .none, favoriteBtn.backgroundColor == .none {
            fillMyMovies(from: array)
        } else if favoriteBtn.backgroundColor != .none, seenBtn.backgroundColor != .none {
            fillMyMovies(from: array.filter({ $0.isFavourite && $0.seen }))
        } else if favoriteBtn.backgroundColor != .none, seenBtn.backgroundColor == .none {
            fillMyMovies(from: array.filter({ $0.isFavourite }))
        } else if favoriteBtn.backgroundColor == .none, seenBtn.backgroundColor != .none {
            fillMyMovies(from: array.filter({ $0.seen }))
        }
    }
}

// MARK:- EXTENSION MoviesViewController: UICollectionViewDataSource, UICollectionViewDelegate

extension MoviesViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    // MARK:- COLLECTION VIEW METHODS
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? GenreCollectionViewCell else { return }
        if isTappedMarkedCell(at: indexPath) {
            cell.uiView.backgroundColor = UIColor.init(red: 0.773, green: 0.796, blue: 0.798, alpha: 1)
            selectedCells.removeAll { $0 == indexPath }
        } else {
            cell.uiView.backgroundColor = .systemBlue
            selectedCells.append(indexPath)
        }
        updateTableView()
    }
    
    func isTappedMarkedCell(at indexPath: IndexPath) -> Bool {
        return selectedCells.contains(indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: self.view.bounds.width * 0.45, height: 50)
    }
}
