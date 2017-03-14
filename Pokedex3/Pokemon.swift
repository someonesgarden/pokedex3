//
//  Pokemon.swift
//  Pokedex3
//
//  Created by USER on 2017/03/14.
//  Copyright © 2017年 Someonesgarden. All rights reserved.
//

import Foundation

//Each Pokemon class
class Pokemon {
    
    fileprivate var _name:String!
    fileprivate var _name_jp:String!
    fileprivate var _pokedexId:Int!
    fileprivate var _pokeType:String!
    
    var name: String{
        return _name
    }
    
    var name_jp: String{
        return _name_jp
    }
    
    var pokedexId: Int{
        return _pokedexId
    }
    
    var pokeType: String{
        return _pokeType
    }
    
    init(name:String,name_jp:String, pokedexId:Int, pokeType:String) {
        self._name = name
        self._pokedexId = pokedexId
        self._name_jp = name_jp
        self._pokeType = pokeType
    }
    
}
