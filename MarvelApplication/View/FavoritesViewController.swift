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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        favoriteCollectionView.register(UINib(nibName: "CardCollectionViewCell", bundle: .main), forCellWithReuseIdentifier: "cardCell")
//        listFavoriteChar = retrieveFromUserDefaults()
//
//        if(listFavoriteChar.isEmpty) {
//            print("empty")
//        }
//        favoriteCollectionView.reloadData()
        
        // Do any additional setup after loading the view.
        //favoriteCollectionView.register(CardCollectionViewCell.self, forSupplementaryViewOfKind: "", withReuseIdentifier: "cardCell")
        
        //favoriteCollectionView.register(UINib.init(), forSupplementaryViewOfKind: "", withReuseIdentifier: "cardCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        listFavoriteChar.removeAll()
        listFavoriteChar = retrieveFromUserDefaults()
        if(listFavoriteChar.isEmpty) {
            print("empty")
        }
        favoriteCollectionView.reloadData()
    }
    
    
    func retrieveFromUserDefaults() -> [CharacterModel] {
        print(" RETRIEVING ...")
        let charFav: [CharacterModel] = UserDefaults.standard.structArrayData(CharacterModel.self, forKey: "id")
        return charFav
    }


}

extension FavoritesViewController {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return listFavoriteChar.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cardCell", for: indexPath) as! CardCollectionViewCell
        //let character = self.characterViewModel.favoriteCharactersArray.index(forKey: indexPath.row)
        //cell.setup(viewModel: characterViewModel,image: character.thumbnail.path, imageExtension: character.thumbnail.thumbnailExtension, name: character.name, favorite: false, index: indexPath.row)
        cell.setup(viewModel: characterViewModel, image: listFavoriteChar[indexPath.row].thumbnail.path , imageExtension: listFavoriteChar[indexPath.row].thumbnail.thumbnailExtension, name: listFavoriteChar[indexPath.row].name, favorite: true, index: indexPath.row)
        cell.disableButton()
        return cell
    }
    
}
