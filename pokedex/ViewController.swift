//
//  ViewController.swift
//  pokedex
//
//  Created by 黃毓皓 on 20/07/2017.
//  Copyright © 2017 ice elson. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UISearchBarDelegate {

    @IBOutlet weak var collection:UICollectionView!
    
    var pokemon = [Pokemon]()
    var pokemonFiltered = [Pokemon]()
    var isInSearchMode = false
    var musicPlayer:AVAudioPlayer!
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       collection.delegate = self
        collection.dataSource = self
      searchBar.delegate = self
        parsePokemonCSV()
        initAudio()
        searchBar.returnKeyType = UIReturnKeyType.done
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text == "" || searchBar.text == nil {
            isInSearchMode  = false
            collection.reloadData()
            view.endEditing(true)
        }else{
          isInSearchMode = true
            var lower = searchBar.text?.lowercased()
            pokemonFiltered =   pokemon.filter{
                ($0.name.range(of: lower!) != nil)
            }
            collection.reloadData()
        }
    }
    
    func initAudio(){
        let path = Bundle.main.path(forResource: "music", ofType: "mp3")!
        do{
            musicPlayer = try AVAudioPlayer(contentsOf: URL(string: path)!)
            musicPlayer.prepareToPlay()
            musicPlayer.numberOfLoops = -1
            musicPlayer.play()
        }
        catch let err as NSError{
            
           print(err.debugDescription)
        }
        
    }
    @IBAction func musicButtonPressed(_ sender: UIButton) {
        
        if musicPlayer.isPlaying{
            
           musicPlayer.pause()
            sender.alpha = 0.2
        }else{
           musicPlayer.play()
            sender.alpha = 1
        }
        
    }
    
    func parsePokemonCSV(){
        let path = Bundle.main.path(forResource: "pokemon", ofType: "csv")!
        
        do {
            let csv = try CSV(contentsOfURL: path)
            let rows = csv.rows
            print(rows)
            
            for row in rows{
                let pokeId = Int(row["id"]!)!
                let name = row["identifier"]!
                
               let poke = Pokemon(name: name, pokedexId: pokeId)
                pokemon.append(poke)
            }
        }catch let err as NSError{
            print(err.debugDescription)
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PokeCell", for: indexPath) as? pokeCell {
            var poke:Pokemon!
            
           if isInSearchMode{
            
                 poke = pokemonFiltered[indexPath.row]
            cell.configureCell(poke)
            
            }else{
                poke = pokemon[indexPath.row]
            cell.configureCell(poke)
            }
            
            
            
            return cell
        }
        else{
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        var poke:Pokemon!
        if isInSearchMode{
           poke = pokemonFiltered[indexPath.row]
        }else{
           poke = pokemon[indexPath.row]
        }
        
        performSegue(withIdentifier: "pokemonDetailVc", sender: poke)
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if isInSearchMode{
            return pokemonFiltered.count
        }else{
            return pokemon.count
        }
        
    
        
        
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 105, height: 105)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if  segue.identifier == "pokemonDetailVc"{
            if let    detailVc = segue.destination as? pokemonDetailVC{
                if let poke = sender as? Pokemon{
                    detailVc.pokemon = poke
                }
                                
            }
        }
    }
    




}

