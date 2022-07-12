
import UIKit
class MoviesViewController: UIViewController {

    // MARK:- Iboutlet
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
        Movie(title: "Avatar", releaseDate: "18 Dec 2009", imdb: 7.9, mainActor: "Sam Worthington", seen: true, isFavourite: false),
        Movie(title: "I Am Legend", releaseDate: "14 Dec 2007", imdb: 7.2, mainActor: "Will Smith", seen: false, isFavourite: true),
        Movie(title: "300", releaseDate: "09 Mar 2007", imdb: 7.7, mainActor: "Gerard Butler", seen: true, isFavourite: true),
        Movie(title: "The Avengers", releaseDate: "04 May 2012", imdb: 8.1, mainActor: "Robert Downey Jr.", seen: false, isFavourite: false),
        Movie(title: "Interstellar", releaseDate: "07 Nov 2014", imdb: 8.6, mainActor: "Ellen Burstyn", seen: true, isFavourite: false),
        Movie(title: "Game of Thrones", releaseDate: "17 Apr 2011", imdb: 9.5, mainActor: "Peter Dinklage", seen: true, isFavourite: true),
        Movie(title: "Breaking Bad", releaseDate: "20 Jan 2008", imdb: 9.5, mainActor: "Bryan Cranston", seen: true, isFavourite: true),
        Movie(title: "Narcos", releaseDate: "28 Aug 2015", imdb: 8.9, mainActor: "Wagner Moura", seen: false, isFavourite: false),
        Movie(title: "Power", releaseDate: "01 Aug 2014", imdb: 8.0, mainActor: "Omari Hardwick", seen: false, isFavourite: false),
        Movie(title: "Gotham", releaseDate: "01 Aug 2014", imdb: 8.0, mainActor: "Ben McKenzie", seen: false, isFavourite: false)
    ]
    
    private var myMovies: [Int: [Movie]] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        moviesTableView.dataSource = self
        moviesTableView.delegate = self
        navigationController?.navigationBar.isHidden = false
        navigationItem.title = "MOVIES"
        moviesTableView.register(UINib(nibName: "MovieTableViewCell", bundle: nil), forCellReuseIdentifier: MovieTableViewCell.identifier)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        fillMyMovies()
    }
}

// MARK: - EXTENSION
extension MoviesViewController: UITableViewDataSource, UITableViewDelegate, MovieTableViewCellDelegate {

    // MARK: - Protocol function
    func favoriteBtnTapped(cell: MovieTableViewCell) {
        guard let indexPath = moviesTableView.indexPath(for: cell) else { return }
        guard let myMovie = myMovies[indexPath.section]?[indexPath.row] else { return }
        myMovie.seen.toggle()
        fillMyMovies()
        moviesTableView.reloadData()
    }
    
    // MARK: - TableView Methods
    func numberOfSections(in tableView: UITableView) -> Int {
        myMovies.keys.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        myMovies[section]?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let movie = myMovies[indexPath.section]?[indexPath.row] else { return UITableViewCell()}
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MovieTableViewCell.identifier, for: indexPath) as? MovieTableViewCell else { return UITableViewCell() }
        let image = UIImage(systemName: movie.seen ? "eye.fill" : "eye.slash")?.withRenderingMode(.alwaysOriginal)
        cell.seenBtn.setImage(image, for: .normal)
        cell.titleLb.text = movie.title
        cell.imbdLB.text = "\(movie.imdb)"
        cell.filmPosterImage.image = UIImage(named: "defaultImage")
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let headerView = Bundle.main.loadNibNamed("CustomView", owner: nil, options: nil)?.first as? CustomView else { return UIView() }
        if section == 0 {
            headerView.backgroundColor = .green
            headerView.titleLb.text = "Seen Films"
        } else {
            headerView.backgroundColor = .red
            headerView.titleLb.text = "Not Seen Films"
        }
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        70
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        40
    }
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
        fillMyMovies()
    }

    // MARK:- class methods
    private func moveToDetails(indexPath: IndexPath) {
        guard let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DetailsViewController") as? DetailsViewController else { return }
        guard let movie = myMovies[indexPath.section]?[indexPath.row] else { return }
        vc.movie = movie
        self.navigationController?.pushViewController(vc, animated: true)
    }

    // Fill Array Depending on the seenBtn and favoriteBtn buttons
    fileprivate func fillMyMovies() {
        if seenBtn.backgroundColor == .none, favoriteBtn.backgroundColor == .none {
            myMovies[0] = movies.filter({ $0.seen })
            myMovies[1] = movies.filter({ !$0.seen })
        } else if favoriteBtn.backgroundColor != .none, seenBtn.backgroundColor != .none {
            myMovies[0] = movies.filter({ $0.seen && $0.isFavourite })
            myMovies[1] = []
        } else if favoriteBtn.backgroundColor != .none, seenBtn.backgroundColor == .none {
            myMovies[0] = movies.filter({ $0.seen && $0.isFavourite })
            myMovies[1] = movies.filter({ !$0.seen && $0.isFavourite })
        } else if favoriteBtn.backgroundColor == .none, seenBtn.backgroundColor != .none {
            myMovies[0] = movies.filter({ $0.seen })
            myMovies[1] = []
        }
        moviesTableView.reloadData()
    }

}
