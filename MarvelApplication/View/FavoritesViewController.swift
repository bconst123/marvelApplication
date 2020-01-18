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
    var characterViewModel = CharactersViewModel()
    var listFavoriteChar = [Int: CharacterModel]()
    var viewModelHandler:(() -> [Int: CharacterModel])?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        favoriteCollectionView.register(UINib(nibName: "CardCollectionViewCell", bundle: .main), forCellWithReuseIdentifier: "cardCell")
        
        // Do any additional setup after loading the view.
        //favoriteCollectionView.register(CardCollectionViewCell.self, forSupplementaryViewOfKind: "", withReuseIdentifier: "cardCell")
        
        //favoriteCollectionView.register(UINib.init(), forSupplementaryViewOfKind: "", withReuseIdentifier: "cardCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
//        listFavoriteChar = UserDefaults.standard.object([Int: CharacterModel].self, with: "Favorites")
        //print(listFavoriteChar.count)
    }


}

extension FavoritesViewController {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 9
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cardCell", for: indexPath) as! CardCollectionViewCell
        //let character = self.characterViewModel.favoriteCharactersArray.index(forKey: indexPath.row)
        //cell.setup(viewModel: characterViewModel,image: character.thumbnail.path, imageExtension: character.thumbnail.thumbnailExtension, name: character.name, favorite: false, index: indexPath.row)
        cell.setup(viewModel: characterViewModel, image: "http://x.annihil.us/u/prod/marvel/i/mg/3/40/4bb4680432f73", imageExtension: "jpg", name: "teste", favorite: true, index: indexPath.row)
        return cell
    }
    
}
