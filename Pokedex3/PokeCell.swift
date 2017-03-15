//
//  PokeCellCollectionViewCell.swift
//  Pokedex3
//
//  Created by USER on 2017/03/14.
//  Copyright © 2017年 Someonesgarden. All rights reserved.
//

import UIKit

class PokeCell: UICollectionViewCell {
    
    @IBOutlet weak var thumbImg: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var nameJpLbl: UILabel!
    @IBOutlet weak var pokeType: UILabel!
    
    var pokemon: Pokemon!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        layer.cornerRadius = 5.0
    }
    
    //MARK: configureCell
    func configureCell(_ pokemon:Pokemon){
        
        self.pokemon = pokemon
        
        nameLbl.text = self.pokemon.name.capitalized
        nameJpLbl.text = self.pokemon.name_jp
        pokeType.text = self.pokemon.typeJp
        thumbImg.image = UIImage(named: "\(self.pokemon.pokedexId)")
        
    }
    
}
