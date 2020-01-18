//
//  CharactersViewModel.swift
//  MarvelApplication
//
//  Created by Bruno Augusto Constantino on 1/18/20.
//  Copyright © 2020 Bruno Augusto Constantino. All rights reserved.
//

class CharactersViewModel {
    var charactersArray = [CharacterModelFav]()
    var favoriteCharactersArray = [CharacterModel]()
    var widgetInfo: [String:String] = [:]
    let urltocall = "https://gateway.marvel.com/v1/public/characters?apikey=a8a4ad0e84b9ad205e7e15bdcffc8452&ts=1&hash=30f18b83faa3f6ae053bae52d647a520&offset="
    let apiManager = ApiManager()
    
    func fetchMarvelAPI(offset: Int, completion: @escaping () -> ()) {
        apiManager.createArrayFromAPI(urltocall: urltocall, offset: offset) { (result, error) in
            if let error = error {
                print("ERROR: \(error)")
                completion()
                return
            }
            guard let responseData = result else {
                print("Data is nil")
                completion()
                return
            }
            for (indexAux, aux) in responseData.data.results.enumerated() {
                if(indexAux == 3) { break }
                self.widgetInfo[String(aux.id)] = aux.name
            }
            
            for each in responseData.data.results {
                var character: CharacterModelFav
                if(self.favoriteCharactersArray.contains{ return $0.id == each.id }) {
                    character = CharacterModelFav(character: each, favorite: true)
                    print("CAIU AQUI")
                } else {
                    character = CharacterModelFav(character: each, favorite: false)
                }
                self.charactersArray.append(character)
            }
                //self.charactersArray = []
            completion()
            
        }
    }
    
    func didTapFavoriteButton(index: Int, cellView: CardCollectionViewCell) {
        print("favorited \(index)")
        if(charactersArray[index].favorite){
            charactersArray[index].favorite = false
            for (indexFav, eachfav) in favoriteCharactersArray.enumerated() {
                if(charactersArray[index].character.id == eachfav.id) {
                    favoriteCharactersArray.remove(at: indexFav)
                }
            }
            cellView.isFavoriteCell = false
        } else {
            charactersArray[index].favorite = true
            if(!favoriteCharactersArray.contains{ return $0.id == charactersArray[index].character.id }) {
                favoriteCharactersArray.append(charactersArray[index].character)
            }
            cellView.isFavoriteCell = true
        }
        cellView.fillupFavoriteStar()
        print(favoriteCharactersArray.count)
    }

    func addRemoveFromFavoritesList(charCandidate: CharacterModelFav) {
        print("DetailViewController - CharCandidate - \(charCandidate.favorite)")
        if charCandidate.favorite == true {
            print("DetailViewController - ADDING NEW HERE - \(charCandidate.character.name)")
            if(!favoriteCharactersArray.contains{ return $0.id == charCandidate.character.id }) {
                favoriteCharactersArray.append(charCandidate.character)
            }
            for eachfav in favoriteCharactersArray {
                if eachfav.id == charCandidate.character.id {
                    for (indexChar,eachChar) in charactersArray.enumerated() {
                        if(eachChar.character.id == charCandidate.character.id) {
                            charactersArray[indexChar].favorite = true
                            break
                        }
                    }
                }
            }
            
        } else {
            for (indexFav, eachfav) in favoriteCharactersArray.enumerated() {
                if eachfav.id == charCandidate.character.id {
                    favoriteCharactersArray.remove(at: indexFav)
                    for (indexChar,eachChar) in charactersArray.enumerated() {
                        if(eachChar.character.id == charCandidate.character.id) {
                            charactersArray[indexChar].favorite = false
                            break
                        }
                    }
                    print("DetailViewController - REMOVING NEW HERE - \(charCandidate.character.name)")
                }
            }
        }
    }
    
}
