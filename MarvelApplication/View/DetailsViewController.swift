//
//  DetailsViewController.swift
//  MarvelApplication
//
//  Created by Bruno Augusto Constantino on 1/18/20.
//  Copyright © 2020 Bruno Augusto Constantino. All rights reserved.
//

import UIKit

protocol DetailsViewDelegate {
    func addRemoveFavorite(data: CharacterModelFav)
}

class DetailsViewController: UIViewController {
    
    var characterDetailIndex: CharacterModelFav? = nil
    var delegate: DetailsViewDelegate?
    var completionHandler:(() -> CharacterModelFav)?

    @IBOutlet weak var charImage: UIImageView!
    
    @IBOutlet weak var charDescription: UILabel!
    
    @IBOutlet weak var favoriteButton: UIButton!

    @IBAction func addToFavorite(_ sender: Any) {
        guard let aux = characterDetailIndex else { return }
        var charFav = aux
            if charFav.favorite == true {
                charFav.favorite = false
                self.favoriteButton.setImage(UIImage(systemName: "star"), for: .normal)
            } else {
                charFav.favorite = true
                self.favoriteButton.setImage(UIImage(systemName: "star.fill"), for: .normal)
            }
            self.delegate?.addRemoveFavorite(data: charFav)
            characterDetailIndex = charFav
        
        
        print("favorite")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        characterDetailIndex = completionHandler?()
        
        if let image = characterDetailIndex?.character.thumbnail.path, let imageExtension = characterDetailIndex?.character.thumbnail.thumbnailExtension, let description = characterDetailIndex?.character.description, let name = characterDetailIndex?.character.name {
                let imageURL = image+"/landscape_incredible."+imageExtension
                let newString = imageURL.replacingOccurrences(of: "http", with: "https", options: .literal, range: nil)
                guard let url = URL(string: newString) else { return }
                self.charImage.load(url: url)
                self.charDescription.text = description
                self.charDescription.lineBreakMode = .byWordWrapping
                self.navigationItem.title = name
                if let favorite = characterDetailIndex?.favorite, favorite == true {
                    self.favoriteButton.setImage(UIImage(systemName: "star.fill"), for: .normal)
                }
                
//            if(favoriteCharactersArray. ) {
//                
//            }
                print("DVC = \(name)")
        }
    }


}

