//
//  Pokemon.swift
//  Pokedex3
//
//  Created by USER on 2017/03/14.
//  Copyright © 2017年 Someonesgarden. All rights reserved.
//

import Foundation
import Alamofire

//Each Pokemon class
class Pokemon {
    
    private var _name:String!
    private var _name_jp:String!
    private var _pokedexId:Int!
    private var _type_jp:String!
    private var _type:String!
    private var _description:String!
    private var _defense:String!
    private var _height:String!
    private var _weight:String!
    private var _attack:String!
    private var _nextEvolutionTxt: String!
    private var _nextEvolutionName :String!
    private var _nextEvolutionId  :String!
    private var _nextEvolutionLevel:String!
    
    private var _pokemonURL: String!
    
    var nextEvolutionTxt: String{
        if _nextEvolutionTxt == nil{
            _nextEvolutionTxt = ""
        }
        return _nextEvolutionTxt
    }
    
    var nextEvolutionName:String{
        if _nextEvolutionName == nil{
            _nextEvolutionName = ""
        }
        return _nextEvolutionName
    }
    
    var nextEvolutionId:String{
        if _nextEvolutionId == nil{
            _nextEvolutionId = ""
        }
        return _nextEvolutionId
    }
    
    var nextEvolutionLevel:String{
        if _nextEvolutionLevel == nil{
            _nextEvolutionLevel = ""
        }
        return _nextEvolutionLevel
    }
    
    var description : String{
        if _description == nil{
             _description = ""
        }
        return _description
    }
    
    
    var typeJp: String{
        if _type_jp == nil{
                _type_jp = ""
        }
        return _type_jp
    }
    
    var type: String{
        if _type == nil{
            _type = ""
        }
        return _type
    }
    
    var defense: String{
        if _defense == nil{
            _defense = ""
        }
        return _defense
    }
    
    var height:String{
        if _height == nil{
            _height = ""
        }
        return _height
    }
    
    var weight:String{
        if _weight == nil{
            _weight = ""
        }
        return _weight
    }
    
    
    var attack: String{
        if _attack == nil{
            _attack = ""
        }
        return _attack
    }
    

    
    var name: String{
        return _name
    }
    
    var name_jp: String{
        return _name_jp
    }
    
    var pokedexId: Int{
        return _pokedexId
    }
    
 
    
    init(name:String,name_jp:String, pokedexId:Int, typeJp:String) {
        self._name = name
        self._pokedexId = pokedexId
        self._name_jp = name_jp
        self._type_jp = typeJp
        
        self._pokemonURL = "\(URL_BASE)\(URL_POKEMON)\(self.pokedexId)/"
    }
    
    func downloadPokemonDetail(completed:@escaping DownloadComplete){
        
        Alamofire.request(_pokemonURL).responseJSON { response in
            
            if let dict = response.result.value as? Dictionary<String, AnyObject>{
                
                if let weight = dict["weight"] as? String{
                    self._weight = weight
                }
                
                if let height = dict["height"] as? String{
                    self._height = height
                }
                
                if let attack = dict["attack"] as? Int{
                    self._attack = "\(attack)"
                }
                
                if let defense = dict["defense"] as? Int{
                    self._defense = "\(defense)"
                }
            
                if let types = dict["types"] as? [Dictionary<String,String>], types.count > 0{
                    
                    var types_ary:Array = [String]()
                    
                    for i in 0..<types.count{
                        if let name = types[i]["name"] {
                            types_ary.append(name.capitalized)
                        }
                    }
                    self._type = types_ary.joined(separator: "/")
                }else{
                    self._type = "."
                }
                
                
                if let descriptions = dict["descriptions"] as? [Dictionary<String,String>], descriptions.count > 0{
                    
                    if let url = descriptions[0]["resource_uri"]{
                        
                        print("url=\(URL_BASE)\(url)")
                        Alamofire.request("\(URL_BASE)\(url)").responseJSON(completionHandler: { response in
                            
                            if let descDict = response.result.value as? Dictionary<String, AnyObject>{
                                
                                if let description = descDict["description"] as? String{
                                    
                                    let newDescription = description.replacingOccurrences(of: "POKOMON", with: "POKEMON")
                                    
                                    print("desc=\(newDescription)")
                                    self._description = newDescription
                                }
                            }
                            completed()
                        })
                    }
                    
                }else{
                    self._description = ""
                }
                
                if let evolutions = dict["evolutions"] as? [Dictionary<String,AnyObject>], evolutions.count > 0{
                    if let nextEvo = evolutions[0]["to"] as? String{
                        
                        if nextEvo.range(of: "mega") == nil{
                            //self._nextEvolutionName = nextEvo["name"]
                            if let uri = evolutions[0]["resource_uri"] as? String{
                                let newStr = uri.replacingOccurrences(of: "/api/v1/pokemon/", with: "")
                                let nextEvoId = newStr.replacingOccurrences(of: "/", with: "")
                                self._nextEvolutionId = nextEvoId
                                
                                print("self._nextEvolutionId=\(self._nextEvolutionId)")
                                
                                if let lvlExist = evolutions[0]["level"]{
                                    if let lvl = lvlExist as? Int{
                                        self._nextEvolutionLevel = "\(lvl)"
                                    }
                                }else{
                                    self._nextEvolutionLevel = ""
                                }
                            }
                        }
                    }
                }
                
            }
            completed()
          
        }
       
        
    }
     //
}
