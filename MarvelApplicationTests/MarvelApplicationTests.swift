//
//  MarvelApplicationTests.swift
//  MarvelApplicationTests
//
//  Created by Bruno Augusto Constantino on 1/18/20.
//  Copyright © 2020 Bruno Augusto Constantino. All rights reserved.
//

import XCTest
@testable import MarvelApplication

class MarvelApplicationTests: XCTestCase {
    
    let character1 = CharacterModel(id: 1, name: "Teste1", description: "teste1111111", thumbnail: Thumbnail(path: "image", thumbnailExtension: "jpg"), resourceURI: "lala.com", comics: Comics(available: 1, collectionURI: "teste1.com", items:[], returned: 1), series: Comics(available: 1, collectionURI: "teste1.com", items:[], returned: 1), stories: Stories(available: 1, collectionURI: "teste1.com", items:[], returned:1), events: Comics(available: 1, collectionURI: "teste1.com", items:[], returned: 1), urls: [])
    
    let character2 = CharacterModel(id: 2, name: "Teste2", description: "teste222222", thumbnail: Thumbnail(path: "image", thumbnailExtension: "jpg"), resourceURI: "lala.com", comics: Comics(available: 2, collectionURI: "teste2.com", items:[], returned: 2), series: Comics(available: 2, collectionURI: "teste2.com", items:[], returned: 2), stories: Stories(available: 2, collectionURI: "teste2.com", items:[], returned:2), events: Comics(available: 2, collectionURI: "teste2.com", items:[], returned: 2), urls: [])
    
    
    func testAPICall() {
        let viewModel = CharactersViewModel()
        viewModel.fetchMarvelAPI(offset: 0) {
            XCTAssert(viewModel.charactersArray.count > 0)
        }
    }
    
    func testDecoding_whenMissingType_itThrows() {
        XCTAssertThrowsError(try JSONDecoder().decode(MarvelModel.self, from: fixtureMissingType)) { error in
            if case .keyNotFound(let key, _)? = error as? DecodingError {
                XCTAssertEqual("code", key.stringValue)
            } else {
                XCTFail("Expected '.keyNotFound' but got \(error)")
            }
        }
    }
    
    func testEmptyListOfCharacters() {
        let viewModel = CharactersViewModel()
        XCTAssert(viewModel.charactersArray.count == 0)
        XCTAssertTrue(viewModel.favoriteCharactersArray.count == 0)
        XCTAssertEqual(viewModel.widgetInfo.count, 0)
    }
    
    func testListOfcharacters() {
        let viewModel = CharactersViewModel()
        viewModel.charactersArray.append(CharacterModelFav(character: character1, favorite: true))
        
        XCTAssert(viewModel.charactersArray.count == 1)
        for each in viewModel.charactersArray {
            XCTAssertTrue(each.character.name == "Teste1")
            XCTAssertTrue(each.favorite == true)
        }
    }
    
    func testAddingElementToFavoriteList() {
        let viewModel = CharactersViewModel()
        viewModel.charactersArray.append(CharacterModelFav(character: character1, favorite: true))
        viewModel.favoriteCharactersArray = []
        
        viewModel.addRemoveFromFavoritesList(charCandidate: CharacterModelFav(character: character1, favorite: true))
        XCTAssert(viewModel.favoriteCharactersArray.count == 1)
    }
    
    func testRemovingElementToFavoriteList() {
        let viewModel = CharactersViewModel()
        viewModel.charactersArray.append(CharacterModelFav(character: character1, favorite: true))
        viewModel.favoriteCharactersArray.append(character1)
        XCTAssert(viewModel.favoriteCharactersArray.count == 1)
        
        viewModel.addRemoveFromFavoritesList(charCandidate: CharacterModelFav(character: character1, favorite: false))
        XCTAssert(viewModel.favoriteCharactersArray.count == 0)
    }
    
    func testAddAndRemoveFavoriteByIndexFunction() {
        let viewModel = CharactersViewModel()
        viewModel.charactersArray.append(CharacterModelFav(character: character1, favorite: true))
        viewModel.charactersArray.append(CharacterModelFav(character: character2, favorite: false))
        XCTAssert(viewModel.charactersArray[1].favorite == false)
        viewModel.didTapFavoriteButton(index: 1)
        XCTAssert(viewModel.charactersArray[1].favorite == true)
    }
    
    func testSavingInformationToUserDefaults() {
        let viewController = CharactersViewController()
        var array: [CharacterModel] = []
        
        array.append(character1)
        array.append(character2)
        
        viewController.saveInUserDefaults(charFav: array)
        
        var arrayResult = viewController.retrieveFromUserDefaults()
        XCTAssert(arrayResult.count == 2)
        for (index, each) in arrayResult.enumerated() {
            if(index == 0) {
                XCTAssert(each.name == "Teste1")
            } else {
                XCTAssert(each.name == "Teste2")
            }
        }
        
        //remove from UserDefaults
        arrayResult.removeAll()
        UserDefaults.standard.setStructArray( arrayResult, forKey: "id")
    }

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

}

private let fixtureMissingType = Data("""
{
  "attributes" : {
    "height" : 200,
    "width" : 400
  }
}
""".utf8)
