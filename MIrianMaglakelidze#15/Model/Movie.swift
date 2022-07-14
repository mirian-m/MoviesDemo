
import Foundation

class Movie {
    let title: String
    let releaseDate: String
    let imdb: Double
    let mainActor: String
    var seen: Bool
    var isFavourite: Bool
    let gener: Gener
    let description = "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum"
    
    init(title: String, releaseDate: String, imdb: Double, mainActor: String, seen: Bool, isFavourite: Bool, gener: Gener) {
        self.title = title
        self.releaseDate = releaseDate
        self.imdb = imdb
        self.isFavourite = isFavourite
        self.mainActor = mainActor
        self.seen = seen
        self.gener = gener
    }
}

enum Gener: String {
    case comedy
    case action
    case drama
}
