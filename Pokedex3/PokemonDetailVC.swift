//
//  PokemonDetailVC.swift
//  Pokedex3
//
//  Created by USER on 2017/03/14.
//  Copyright © 2017年 Someonesgarden. All rights reserved.
//

import UIKit

class PokemonDetailVC: UIViewController {

    var pokemon: Pokemon!
    
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var name_Jp_Lbl: UILabel!
    @IBOutlet weak var pokeType_Lbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameLbl.text = pokemon.name
        name_Jp_Lbl.text = pokemon.name_jp
        pokeType_Lbl.text = pokemon.pokeType
    }

}
