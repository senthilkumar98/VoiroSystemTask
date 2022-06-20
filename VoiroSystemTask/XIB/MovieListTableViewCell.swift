//
//  MovieListTableViewCell.swift
//  VoiroSystemTask
//
//  Created by Senthil Kumar T on 20/06/22.
//

import UIKit

class MovieListTableViewCell: UITableViewCell {

    
    @IBOutlet weak var ratingLbl: UILabel!
    @IBOutlet weak var movieNameLbl: UILabel!
    @IBOutlet weak var movieImageView: UIImageView!
    @IBOutlet weak var starImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}
