//
//  Pokemon.swift
//  pokedex
//
//  Created by 黃毓皓 on 20/07/2017.
//  Copyright © 2017 ice elson. All rights reserved.
//

import Foundation
import Alamofire

class Pokemon{
    private var _name:String!
    private var _pokedexId:Int!
    private var _descrition:String!
    private var _type:String!
    private var _defense:String!
    private var _height:String!
    private var  _weight:String!
    private var  _attack:String!
    private var _nextEvolutionTxt:String!
    private var _pokemonURL:String!
    private var _nextEvolutionName:String!
    private var _nextEvolutionLevel:String!
    private var _nextEvoultionId:String!
    
    var nextEvolutionId:String{
        if _nextEvoultionId  == nil{
            _nextEvoultionId = ""
        }
        return _nextEvoultionId
    }
    
    var nextEvolutionLevel:String{
        if _nextEvolutionLevel == nil{
            _nextEvolutionLevel = ""
            
        }
    return _nextEvolutionLevel
    }
    
    var nextEvolutionName:String{
        if _nextEvolutionName == nil{
           _nextEvolutionName = ""
        }
        return _nextEvolutionName
    }
    
    var descrition:String{
        if _descrition == nil{
            _descrition = ""
        }
        return _descrition
    }
    
    var type:String{
        if _type == nil{
            _type = ""
        }
        return _type
    }
    
    var defense:String{
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
    
    var attack:String{
        if _attack == nil{
            _attack = ""
        }
        return _attack
    }
    
    var evolution:String{
        if _nextEvolutionTxt == nil{
            _nextEvolutionTxt = ""
        }
        return _nextEvolutionTxt
    }
    
    var name:String{
        return _name
    }
    var pokedexId:Int{
        return _pokedexId
    }
    
    init(name:String,pokedexId:Int) {
        self._name = name
        self._pokedexId = pokedexId
        self._pokemonURL = "\(URL_Base)\(URL_POKEMON)\(self.pokedexId)/"
    }
    
    func downloadPokemonDetail(completed:  @escaping DownloadComplete){
        Alamofire.request(_pokemonURL).responseJSON { (response) in
            if let dic = response.result.value as? Dictionary<String,Any>{
                if let weight = dic["weight"] as? String{
                    self._weight = weight
                }
                
                if let height = dic["height"] as? String{
                    self._height = height
                }
                
                if let attack = dic["attack"] as? Int{
                    self._attack = "\(attack)"
                }
                
                if let defense = dic["defense"] as? Int{
                    self._defense = "\(defense)"
                }
                print(self._weight)
                print(self._height)
                print(self._attack)
                print(self._defense)
            
                if let types = dic["types"] as? [Dictionary<String,String>]  {
                    if types.count > 0{
                        if let name =  types[0]["name"]{
                          self._type = name.capitalized
                        }
                        if types.count > 1{
                            for x in 1..<types.count{
                                if let name =  types[x]["name"]{
                                    self._type! += "/\(name.capitalized)"
                                }
                            }
                        }
                        print(self.type)
                    }else{
                        self._type = ""
                    }
                }
                
                if let desArr = dic["descriptions"] as? [Dictionary<String,String>] , desArr.count > 0{
                   if let desUrl = desArr[0]["resource_uri"] {
                       let newUrl = "\(URL_Base)/\(desUrl)"
                    
                      Alamofire.request(newUrl).responseJSON(completionHandler: { (response) in
                        
                        if let desDict = response.result.value as? Dictionary<String,Any>{
                            if let description = desDict["description"] as? String {
                                let newDescription  = description.replacingOccurrences(of: "POKMON", with: "pokemon")
                                self._descrition = newDescription
                                print("description\(description)")
                            }
                        }
                        completed()
                      })
                    
                   }
                }else{
                    self._descrition  = ""
                }
                
                if let evolutions = dic["evolutions"] as? [Dictionary<String,Any>] , evolutions.count > 0{
                    
                    if let nextEvo = evolutions[0]["to"] as? String{
                        if nextEvo.range(of: "mega") == nil{
                            self._nextEvolutionName = nextEvo
                            
                            if let url = evolutions[0]["resource_uri"] as? String{
                                let newstr =  url.replacingOccurrences(of: "/api/v1/pokemon/", with: "")
                              let nextEvoId = newstr.replacingOccurrences(of: "/", with: "")
                                self._nextEvoultionId = nextEvoId
                                
                                 if let levelExist =  evolutions[0]["level"] {
                                    
                                    if  let level = levelExist as? Int{
                                       self._nextEvolutionLevel = "\(level)"
                                    }
                                    
                                 }else{
                                    self._nextEvolutionLevel = ""
                                }
                            }
                        }
                    }
                    print(self._nextEvolutionLevel)
                    print(self._nextEvolutionName)
                    print(self._nextEvoultionId)
                }
                
            }
            
            
            completed()
        }
        
        
    }
}