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

class CharactersViewController: UIViewController {
    
    
    @IBOutlet weak var charactersCollectionView: UICollectionView!
    
    let monitor = NWPathMonitor()
    var isConnected = true
    private let refreshControl = UIRefreshControl()
    let detailsSegueIdentifier = "presentCharacterDetails"
    let totalCharacters = 1493 //TODO
    var searchController = UISearchController(searchResultsController: nil)
    var filteredChar: [CharacterModelFav] = []
    
    var isSearchBarEmpty: Bool {
      return searchController.searchBar.text?.isEmpty ?? true
    }
    var isFiltering: Bool {
      return searchController.isActive && !isSearchBarEmpty
    }
    
    let characterViewModel = CharactersViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        charactersCollectionView.register(UINib(nibName: "CardCollectionViewCell", bundle: .main), forCellWithReuseIdentifier: "cardCell")
        
        if #available(iOS 10.0, *) {
            charactersCollectionView.refreshControl = refreshControl
        } else {
            charactersCollectionView.addSubview(refreshControl)
        }
        
        // retrieving favorites from UserDefaults
        characterViewModel.favoriteCharactersArray = retrieveFromUserDefaults()
        
        // parameters for Search Bar
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Character"
        navigationItem.searchController = searchController
        definesPresentationContext = true
        
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
    
    func saveInUserDefaults(charFav: [CharacterModel]) {
        print(" SAVING INTO MEMORY ...")
        let sortedArray = charFav.sorted(by: {(char1, char2) in return char1.name<char2.name})
        UserDefaults.standard.setStructArray(sortedArray, forKey: "id")
    }
    
    func retrieveFromUserDefaults() -> [CharacterModel] {
        print(" RETRIEVING ...")
        let charFav: [CharacterModel] = UserDefaults.standard.structArrayData(CharacterModel.self, forKey: "id")
        return charFav
    }
    
    func filterContentForSearchText(_ searchText: String) {
        filteredChar = self.characterViewModel.charactersArray.filter { (charcter: CharacterModelFav) -> Bool in
            return charcter.character.name.lowercased().contains(searchText.lowercased())
        }

        DispatchQueue.main.async {
            self.charactersCollectionView.reloadData()
        }
        
    }
    
}

extension CharactersViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if isFiltering {
            return filteredChar.count
        }
        return characterViewModel.charactersArray.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cardCell", for: indexPath) as! CardCollectionViewCell
        var character: CharacterModelFav
        if isFiltering {
            character = filteredChar[indexPath.row]
        } else {
          character = self.characterViewModel.charactersArray[indexPath.row]
        }
        
        cell.setup(viewModel: characterViewModel,image: character.character.thumbnail.path, imageExtension: character.character.thumbnail.thumbnailExtension, name: character.character.name, favorite: character.favorite, index: indexPath.row)
        
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
        let charSelected: CharacterModelFav
        if isFiltering {
          charSelected = filteredChar[indexPath.row]
        } else {
          charSelected = self.characterViewModel.charactersArray[indexPath.row]
        }
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "DetailsViewController") as! DetailsViewController
        
        vc.completionHandler = {return charSelected}
        
        self.navigationController?.pushViewController(vc, animated:true)
    }
}


extension CharactersViewController: UISearchResultsUpdating {
  func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        filterContentForSearchText(searchBar.text!)
  }
}


extension UserDefaults {
    open func setStruct<T: Codable>(_ value: T?, forKey defaultName: String){
        let data = try? JSONEncoder().encode(value)
        set(data, forKey: defaultName)
    }
    
    open func structData<T>(_ type: T.Type, forKey defaultName: String) -> T? where T : Decodable {
        guard let encodedData = data(forKey: defaultName) else {
            return nil
        }
        
        return try! JSONDecoder().decode(type, from: encodedData)
    }
    
    open func setStructArray<T: Codable>(_ value: [T], forKey defaultName: String){
        let data = value.map { try? JSONEncoder().encode($0) }
        
        set(data, forKey: defaultName)
    }
    
    open func structArrayData<T>(_ type: T.Type, forKey defaultName: String) -> [T] where T : Decodable {
        guard let encodedData = array(forKey: defaultName) as? [Data] else {
            return []
        }
        
        return encodedData.map { try! JSONDecoder().decode(type, from: $0) }
    }
}
