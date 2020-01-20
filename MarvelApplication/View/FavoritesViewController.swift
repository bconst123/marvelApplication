//
//  FavoritesViewController.swift
//  MarvelApplication
//
//  Created by Bruno Augusto Constantino on 1/18/20.
//  Copyright © 2020 Bruno Augusto Constantino. All rights reserved.
//

import UIKit

class FavoritesViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    
    @IBOutlet weak var favoriteCollectionView: UICollectionView!
    let characterViewModel = CharactersViewModel()
    var listFavoriteChar: [CharacterModel] = []
    let viewEmpty = UINib(nibName: "EmptyListView", bundle: .main).instantiate(withOwner: nil, options: nil).first as! UIView
    
    override func viewDidLoad() {
        super.viewDidLoad()
        favoriteCollectionView.register(UINib(nibName: "CardCollectionViewCell", bundle: .main), forCellWithReuseIdentifier: "cardCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        listFavoriteChar.removeAll()
        listFavoriteChar = retrieveFromUserDefaults()
        
        if(listFavoriteChar.isEmpty) {
            view.frame = self.view.bounds
            self.favoriteCollectionView.addSubview(viewEmpty)
        } else {
            self.favoriteCollectionView.willRemoveSubview(viewEmpty)
        }
        favoriteCollectionView.reloadData()
    }
    
    
    func retrieveFromUserDefaults() -> [CharacterModel] {
        print(" RETRIEVING DATA FROM USERDEFAULTS...")
        let charFav: [CharacterModel] = UserDefaults.standard.structArrayData(CharacterModel.self, forKey: "id")
        return charFav
    }


}

extension FavoritesViewController {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return listFavoriteChar.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        self.viewEmpty.removeFromSuperview()
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cardCell", for: indexPath) as! CardCollectionViewCell
        cell.imageCharacter.image = UIImage()
        cell.setup(viewModel: characterViewModel, image: listFavoriteChar[indexPath.row].thumbnail.path , imageExtension: listFavoriteChar[indexPath.row].thumbnail.thumbnailExtension, name: listFavoriteChar[indexPath.row].name, favorite: true, index: indexPath.row)
        cell.disableButton()
        return cell
    }
    
}
