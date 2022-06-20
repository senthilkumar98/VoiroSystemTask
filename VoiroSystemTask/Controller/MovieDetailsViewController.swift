//
//  MovieDetailsViewController.swift
//  VoiroSystemTask
//
//  Created by Senthil Kumar T on 20/06/22.
//

import UIKit

class MovieDetailsViewController: UIViewController {

    @IBOutlet weak var titleDetailLbl: UILabel!
    @IBOutlet weak var ratingDetailLbl: UILabel!
    @IBOutlet weak var genresLbl: UILabel!
    @IBOutlet weak var movieDetailImage: UIImageView!
    @IBOutlet weak var releaseDateLbl: UILabel!
    
    var tittle: String = ""
    var releaseDate: String = ""
    var rating: String = ""
    var genres: String = ""
    var imageLink: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialLoad()
    }
    
    private func initialLoad() {
        self.titleDetailLbl .text = self.tittle
        self.ratingDetailLbl .text = self.rating
        self.releaseDateLbl .text = self.releaseDate
        self.navigationController?.isNavigationBarHidden = false
        self.title = "Movie Detail"
        self.movieDetailImage.setImage(with: imageLink, placeHolder: UIImage(named: "movie_placeholer"))

        self.genresLbl.text = self.genres
        
    }

}
