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
    
    @IBOutlet weak var comicsCollectionView: UICollectionView!
    
    @IBOutlet weak var seriesCollectionView: UICollectionView!
    
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
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        characterDetailIndex = completionHandler?()
        
        comicsCollectionView.register(UINib(nibName: "ComicsSeriesViewCell", bundle: .main), forCellWithReuseIdentifier: "comicsSeriesCell")
        seriesCollectionView.register(UINib(nibName: "ComicsSeriesViewCell", bundle: .main), forCellWithReuseIdentifier: "comicsSeriesCell")
        
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
        }
    }
}

extension DetailsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == comicsCollectionView {
            return characterDetailIndex?.character.comics.returned ?? 0
        } else if collectionView == seriesCollectionView {
            return characterDetailIndex?.character.series.returned ?? 0
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == comicsCollectionView, let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "comicsSeriesCell", for: indexPath) as? ComicsSeriesViewCell {
            cell.artName.text = characterDetailIndex?.character.comics.items[indexPath.row].name
            return cell
        } else if collectionView == seriesCollectionView, let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "comicsSeriesCell", for: indexPath) as? ComicsSeriesViewCell {
            cell.artName.text = characterDetailIndex?.character.series.items[indexPath.row].name
            return cell
        }
        return UICollectionViewCell()
    }
}

