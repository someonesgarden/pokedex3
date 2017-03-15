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
    @IBOutlet weak var mainImg: UIImageView!
    @IBOutlet weak var descriptionLbl: UILabel!
    @IBOutlet weak var typeLbl: UILabel!
    @IBOutlet weak var defenceLbl: UILabel!
    @IBOutlet weak var heightLbl: UILabel!
    @IBOutlet weak var weightLbl: UILabel!
    @IBOutlet weak var pokedexLbl: UILabel!
    @IBOutlet weak var attackLbl: UILabel!
    @IBOutlet weak var currentEvoImg: UIImageView!
    @IBOutlet weak var nextEvoImg: UIImageView!
    @IBOutlet weak var evoLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameLbl.text = pokemon.name
        name_Jp_Lbl.text = pokemon.name_jp
        pokeType_Lbl.text = pokemon.typeJp
        
        let img = UIImage(named: "\(pokemon.pokedexId)")
        mainImg.image = img
        currentEvoImg.image = img
        pokedexLbl.text = "\(pokemon.pokedexId)"
        
        
        pokemon.downloadPokemonDetail {
            //Whateve we write willl only be called after the network call is complete!
            self.updateUI()
        }
    }
    
    func updateUI(){
        attackLbl.text = pokemon.attack
        defenceLbl.text = pokemon.defense
        heightLbl.text = pokemon.height
        weightLbl.text = pokemon.weight
        typeLbl.text = pokemon.type
        descriptionLbl.text = pokemon.description
        
        if pokemon.nextEvolutionId == ""{
            evoLbl.text = "No Evolutions"
            nextEvoImg.isHidden = true
        }else{
            nextEvoImg.isHidden = false
            print(pokemon.nextEvolutionId)
            nextEvoImg.image = UIImage(named: pokemon.nextEvolutionId)
            let str = "Next Evolutions: \(pokemon.nextEvolutionName) - LVL \(pokemon.nextEvolutionLevel)"
            evoLbl.text = str
        }
    }
    

    @IBAction func backBtnPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}
