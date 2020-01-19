//
//  CardCellView.swift
//  MarvelApplication
//
//  Created by Bruno Augusto Constantino on 1/18/20.
//  Copyright © 2020 Bruno Augusto Constantino. All rights reserved.
//

import UIKit

class CardCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageCharacter: UIImageView!
    @IBOutlet weak var nameCharacter: UILabel!
    @IBOutlet weak var favoriteCharacter: UIButton!
    
    private var cardViewModel: CharactersViewModel?
    private var characterVC = CharactersViewController()
    private var cellIndex: Int = 0
    public var isFavoriteCell: Bool = false

    
    @IBAction func addToFavorite(_ sender: Any) {
        cardViewModel?.didTapFavoriteButton(index: cellIndex)
        if(self.isFavoriteCell == true) {
            self.isFavoriteCell = false
        } else {
            self.isFavoriteCell = true
        }
        fillupFavoriteStar()
        // need to have index here
    }
    
    func setup(viewModel:CharactersViewModel ,image: String,imageExtension: String, name: String, favorite: Bool, index: Int){
        let imageURL = image+"/portrait_fantastic."+imageExtension
        let newString = imageURL.replacingOccurrences(of: "http", with: "https", options: .literal, range: nil)
        guard let url = URL(string: newString) else { return }
        self.imageCharacter.load(url: url)
        self.nameCharacter.text = name
        if(favorite == true) {
            self.favoriteCharacter.setImage(UIImage(systemName: "star.fill"), for: .normal)
        } else {
            self.favoriteCharacter.setImage(UIImage(systemName: "star"), for: .normal)
        }
        self.cellIndex = index
        self.cardViewModel = viewModel
        self.isFavoriteCell = favorite
    }
    
    func fillupFavoriteStar() {
        if(isFavoriteCell) {
            self.favoriteCharacter.setImage(UIImage(systemName: "star.fill"), for: .normal)
        } else {
            self.favoriteCharacter.setImage(UIImage(systemName: "star"), for: .normal)
        }
        characterVC.saveInUserDefaults(charFav: cardViewModel?.favoriteCharactersArray ?? [])
    }
    
    func disableButton(){
        self.favoriteCharacter.isEnabled = false
    }
}

extension UIImageView {
    func load(url: URL) {
        DispatchQueue.main.async() { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}
