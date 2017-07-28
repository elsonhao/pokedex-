//
//  pokemonDetailVC.swift
//  pokedex
//
//  Created by 黃毓皓 on 20/07/2017.
//  Copyright © 2017 ice elson. All rights reserved.
//

import UIKit

class pokemonDetailVC: UIViewController {

    var pokemon:Pokemon!
    
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var mainImg: UIImageView!
    @IBOutlet weak var descritionLbl: UILabel!
    @IBOutlet weak var typeLbl: UILabel!
    @IBOutlet weak var defenseLbl: UILabel!
    @IBOutlet weak var heightLbl: UILabel!
    @IBOutlet weak var pokedexLbl: UILabel!
    @IBOutlet weak var weightLbl: UILabel!
    @IBOutlet weak var attackLbl: UILabel!
    @IBOutlet weak var nowImage: UIImageView!
    @IBOutlet weak var nextImg: UIImageView!
    @IBOutlet weak var evoLbl: UILabel!
    
    
    
    @IBAction func backBtnPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
     nameLbl.text = pokemon.name.capitalized
    pokedexLbl.text = "\(pokemon.pokedexId)"
    mainImg.image = UIImage(named: "\(pokemon.pokedexId)")
    nowImage.image = UIImage(named: "\(pokemon.pokedexId)")
    pokemon.downloadPokemonDetail { 
        // whatever we write here will be only be called after the network call is complete
        print("did arrive here?")
        
        self.updateUI()
        }
    }
    
    func updateUI(){
        weightLbl.text = pokemon.weight
        heightLbl.text = pokemon.height
        defenseLbl.text = pokemon.defense
        attackLbl.text = pokemon.attack
        typeLbl.text = pokemon.type
        
        descritionLbl.text = pokemon.descrition
        
        if pokemon.nextEvolutionId == ""{
           nextImg.isHidden = true
           evoLbl.text = "No Evolutions "
            
        }else{
            nextImg.isHidden = false
            let str = "Next Evolution : \(pokemon.nextEvolutionName)-LVL \(pokemon.nextEvolutionLevel)"
            evoLbl.text = str
            nextImg.image = UIImage(named: pokemon.nextEvolutionId)
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
