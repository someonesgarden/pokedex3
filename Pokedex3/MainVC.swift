//
//  ViewController.swift
//  Pokedex3
//
//  Created by USER on 2017/03/14.
//  Copyright © 2017年 Someonesgarden. All rights reserved.
//

import UIKit
import AVFoundation

class MainVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UISearchBarDelegate {
    
    //MARK: - Initialize
    @IBOutlet weak var collection: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var selectSegment: customSegmentedControl!
    
    var pokemons = [Pokemon]()
    var filteredPokemons = [Pokemon]()
    var musicPlayer: AVAudioPlayer!
    
    var inSearchMode     = false
    var sortOrderASC     = false
    var sortType         = "name"
    
    //MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()

        collection.dataSource = self
        collection.delegate = self
        searchBar.delegate = self
        
        parsePokemonCSV()
        initAudio()
    }
    
    //MARK: - initAudio
    func initAudio(){
        let path = Bundle.main.path(forResource: "music", ofType: "mp3")!
        
        do{
            musicPlayer = try AVAudioPlayer(contentsOf: URL(string: path)!)
            musicPlayer.prepareToPlay()
            musicPlayer.numberOfLoops = -1
            musicPlayer.play()
        }catch let err as NSError {
            print(err.debugDescription)
        }
    }
    
    //MARK: - CSV
    func parsePokemonCSV(){
        
        let path = Bundle.main.path(forResource: "pokemon_jap", ofType: "csv")!
        
        do{
            let csv = try CSV(contentsOfURL: path)
            let rows = csv.rows
            //print(rows)
            
            for row in rows {
                let pokeId = Int(row["id"]!)!
                let name = row["identifier"]!
                let name_jp = row["identifier_jp"]!
                let pokeType = row["type_jp"]!
                
                let poke = Pokemon(name: name,name_jp: name_jp, pokedexId: pokeId, pokeType:pokeType)
                pokemons.append(poke)
            }
            
        }catch let err as NSError{
            print(err.debugDescription)
        }
    }

    //MARK: - CollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: 100, height: 30)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: 100, height: 30)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PokeCell", for: indexPath) as? PokeCell{
            
                let poke: Pokemon!
            
                if inSearchMode{
                    poke = filteredPokemons[indexPath.row]
                    cell.configureCell(poke)
                }else{
                    poke = pokemons[indexPath.row]
                    cell.configureCell(poke)
                }
                return cell
        }
        else{
            return UICollectionViewCell()
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //segue:PokemonDetailVC
        var poke:Pokemon!
        
        if inSearchMode{
            poke = filteredPokemons[indexPath.row]
        }else{
            poke = pokemons[indexPath.row]
        }
        
        performSegue(withIdentifier: "PokemonDetailVC", sender: poke)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if inSearchMode{
            return filteredPokemons.count
        }
        
        return pokemons.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 105, height: 120)
    }
    
    //MARK: - Music Button
    @IBAction func musicBtnPressed(_ sender: UIButton) {
        
        if musicPlayer.isPlaying {
            musicPlayer.pause()
            sender.alpha = 0.2
        }else{
            musicPlayer.play()
            sender.alpha = 1.0
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
    }
    
    // MARK: - Search Bar Delegate
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text == nil || searchBar.text == ""{
            inSearchMode = false
            view.endEditing(true)
            
        }else{
            inSearchMode = true
        }
        
        sortDataWithFilter()
        collection.reloadData()
        
    }
    @IBAction func sortOrderClicked(_ sender: UIButton) {
        
        if sortOrderASC{
            sender.setTitle("▲", for: UIControlState())
        }else{
            sender.setTitle("▼", for: UIControlState())
        }
        sortOrderASC = !sortOrderASC
        
        sortDataWithFilter()
        collection.reloadData()
    }
    
    //MARK: - Segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PokemonDetailVC" {
            if let detailVC = segue.destination as? PokemonDetailVC{
                if let poke = sender as? Pokemon{
                    detailVC.pokemon = poke
                }
            }
        }
    }
    

    // MARK: - SegmentControl
    @IBAction func typeSelected(_ sender: UISegmentedControl) {
        
        if selectSegment.selectedSegmentIndex == 0{
            sortType = "type"
            
        }else if selectSegment.selectedSegmentIndex == 1{
            sortType = "name"
            
        }else{
            sortType = "name_jp"
        }
        
        sortDataWithFilter()
        collection.reloadData()
    }
    
    func sortDataWithFilter(){
        //Search
        if inSearchMode{
            let lower:String!
            
            if sortType ==  "type"{
                lower = searchBar.text!
                filteredPokemons = pokemons.filter({$0.pokeType.range(of: lower) != nil })
            }else if sortType ==  "name"{
                lower = searchBar.text!.lowercased()
                filteredPokemons = pokemons.filter({$0.name.range(of: lower) != nil })
            }
            else{
                lower = searchBar.text!
                filteredPokemons = pokemons.filter({$0.name_jp.range(of: lower) != nil })
            }
        }

        //Sort
        if sortType ==  "type"{
            
            if sortOrderASC{
                filteredPokemons = filteredPokemons.sorted{$0.pokeType < $1.pokeType}
                pokemons         = pokemons.sorted{$0.pokeType < $1.pokeType}
            }else{
                filteredPokemons = filteredPokemons.sorted{$0.pokeType > $1.pokeType}
                pokemons         = pokemons.sorted{$0.pokeType > $1.pokeType}
            }
        }else if sortType ==  "name"{
            if sortOrderASC{
                filteredPokemons = filteredPokemons.sorted{$0.name < $1.name}
                pokemons         = pokemons.sorted{$0.name < $1.name}
            }else{
                filteredPokemons = filteredPokemons.sorted{$0.name > $1.name}
                pokemons         = pokemons.sorted{$0.name > $1.name}
            }
        }else{
            if sortOrderASC{
                filteredPokemons = filteredPokemons.sorted{$0.name_jp < $1.name_jp}
                pokemons         = pokemons.sorted{$0.name_jp < $1.name_jp}
            }else{
                filteredPokemons = filteredPokemons.sorted{$0.name_jp > $1.name_jp}
                pokemons         = pokemons.sorted{$0.name_jp > $1.name_jp}
            }
        }
    }
}

