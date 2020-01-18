//
//  CharactersViewController.swift
//  MarvelApplication
//
//  Created by Bruno Augusto Constantino on 1/18/20.
//  Copyright © 2020 Bruno Augusto Constantino. All rights reserved.
//

import UIKit
import Network

protocol CharactersDelegate {
    func finishPassing(characterModel: CharacterModel)
}

class CharactersViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    
    @IBOutlet weak var charactersCollectionView: UICollectionView!
    
    let monitor = NWPathMonitor()
    var isConnected = true
    private let refreshControl = UIRefreshControl()
    let detailsSegueIdentifier = "presentCharacterDetails"
    let totalCharacters = 60 //TODO
    
    
    let characterViewModel = CharactersViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        charactersCollectionView.register(UINib(nibName: "CardCollectionViewCell", bundle: .main), forCellWithReuseIdentifier: "cardCell")
        
        if #available(iOS 10.0, *) {
            charactersCollectionView.refreshControl = refreshControl
        } else {
            charactersCollectionView.addSubview(refreshControl)
        }
        
        monitor.pathUpdateHandler = { path in
            if path.status == .satisfied {
                print("We're connected!")
                self.isConnected = true
            } else {
                print("No connection.")
                self.isConnected = false
            }
        }
        let queue = DispatchQueue.global(qos: .background)
        monitor.start(queue: queue)
        
        refreshControl.addTarget(self, action: #selector(refreshData(_:)), for: .valueChanged)
        callApi(startAt: 0)
        
        //let favc = self.storyboard?.instantiateViewController(withIdentifier: "FavoritesViewController") as! FavoritesViewController
        //favc.viewModelHandler = {return self.characterViewModel.favoriteCharactersArray}
    }
    
    override func viewWillDisappear(_ animated: Bool) {
//        UserDefaults.standard.set(self.characterViewModel.favoriteCharactersArray, forKey: "Favorites")
    }
    
    @objc private func refreshData(_ sender: Any) {
        callApi(startAt: 0)
        print("refreshing data...");
        refreshControl.endRefreshing()
    }
    
    func callApi(startAt: Int) {
        if(isConnected) {
            characterViewModel.fetchMarvelAPI(offset: startAt) {
                if(self.characterViewModel.charactersArray.count == 0) {
                    //show empty list TODO
                    print("empty")
                    //charactersCollectionView.
                } else {
                    DispatchQueue.main.async {
                        self.charactersCollectionView.reloadData()
                    }
                }
            }
        }
    }
    
}

extension CharactersViewController {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return characterViewModel.charactersArray.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cardCell", for: indexPath) as! CardCollectionViewCell
        let character = self.characterViewModel.charactersArray[indexPath.row].character
        cell.setup(viewModel: characterViewModel,image: character.thumbnail.path, imageExtension: character.thumbnail.thumbnailExtension, name: character.name, favorite: self.characterViewModel.charactersArray[indexPath.row].favorite, index: indexPath.row)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if(indexPath.row == self.characterViewModel.charactersArray.count - 1) {
            //last cell
            if(self.characterViewModel.charactersArray.count < totalCharacters) {
                //call API with offset = charactersArray.count
                print("loading new data...")
                callApi(startAt: self.characterViewModel.charactersArray.count)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "DetailsViewController") as! DetailsViewController
        
        vc.completionHandler = {return self.characterViewModel.charactersArray[indexPath.row]}
        
        self.navigationController?.pushViewController(vc, animated:true)
    }
    

}
