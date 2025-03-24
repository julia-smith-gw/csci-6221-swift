//
//  ViewController.swift
//  MusicProject
//
//  Created by Shreeya Sharda on 3/21/25.
//

import UIKit
import SwiftUI





// NOTE - Here, we are defining the fields of a Song object (You will get rid of this if we use the API)
struct Song  {
    let name: String
    let Genre: String
    let artistName: String
    let imageName: String
    let audioFileName: String
}

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
   
    
    
    // Lets set the background color of the app:
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
//        let gradient = CAGradientLayer()
//        gradient.colors = [UIColor.blue.withAlphaComponent(0.5).cgColor, UIColor.purple.withAlphaComponent(0.2).cgColor]
//        gradient.locations = [0.0, 1.0]
//        gradient.startPoint = CGPoint(x: 0.0, y: 0.0)
//        gradient.endPoint = CGPoint(x: 0.0, y: 1.0)
//        gradient.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
//        
//        self.view.layer.insertSublayer(gradient, at: 0) // This will not cover the information on top of the background (the background should lay behind the content of the page)
    }
    
    @IBOutlet var table: UITableView!
    
    //@IBOutlet var iconImageView: UIImageView!
    
//    @IBOutlet var iconImageView: UIImageView!
//    
//    @IBOutlet var label1: UILabel!
//    @IBOutlet var label2: UILabel!
//    
    
    
    var songs = [Song]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // This will call the configure songs object
        configureSongs()
        table.delegate = self
        table.dataSource = self
        table.isScrollEnabled = true
        table.estimatedRowHeight = CGFloat(songs.count)
        table.rowHeight = UITableView.automaticDimension
    }
    
    
    
    
    
    
    
    // NOTE - This function will append objects of type Song (which we defined below)
    // NOTE - This is what the APPLE MUSIC API would be replacing!!! 
    func configureSongs()
    {
        var iterator = 5
        // NOTE - This is where we add/create the Songs we want to use
        
        
        // Song #4
        
        songs.append(Song(name: "Tequilla",
                          Genre: "Country",
                          artistName: "Dan + Shay",
                          imageName: "cover\(iterator)",
                          audioFileName: "Song\(iterator)"))
        
        iterator += 1
        
        // Song #5
        
        songs.append(Song(name: "Stargazing",
                          Genre: "Pop",
                          artistName: "Myles Smith",
                          imageName: "cover\(iterator)",
                          audioFileName: "Song\(iterator)"))
        
        iterator += 1
        
        // Song #6
        songs.append(Song(name: "Remind Me To Forget",
                          Genre: "Dance",
                          artistName: "Miguel, Kygo",
                          imageName: "cover\(iterator)",
                          audioFileName: "Song\(iterator)"))
        
        iterator += 1
        
        // Song #7
        songs.append(Song(name: "Lil Boo Thang",
                          Genre: "Pop",
                          artistName: "Paul Russell",
                          imageName: "cover\(iterator)",
                          audioFileName: "Song\(iterator)"))
        
        iterator += 1
        
        // Song #8
        songs.append(Song(name: "Happy!",
                          Genre: "Pop",
                          artistName: "Pharell Williams",
                          imageName: "cover\(iterator)",
                          audioFileName: "Song\(iterator)"))
        
        iterator += 1
        
        // Song #9
        songs.append(Song(name: "Go Your Own Way",
                          Genre: "Rock",
                          artistName: "FleetWood Mac",
                          imageName: "cover\(iterator)",
                          audioFileName: "Song\(iterator)"))
        
        iterator += 1
        
        // Song #10
        songs.append(Song(name: "Cruel Summer",
                          Genre: "Pop",
                          artistName: "Taylor Swift",
                          imageName: "cover\(iterator)",
                          audioFileName: "Song\(iterator)"))
        
        iterator += 1
        
        //Song #11
        songs.append(Song(name: "All I Ask",
                          Genre: "Pop",
                          artistName: "Adele",
                          imageName: "cover\(iterator)",
                          audioFileName: "Song\(iterator)"))
        
        iterator += 1
        
        // Song #12
        songs.append(Song(name: "We can't be friends",
                          Genre: "Pop",
                          artistName: "Ariana Grande",
                          imageName: "cover\(iterator)",
                          audioFileName: "Song\(iterator)"))
        
        iterator += 1
        
        // Song#13
        songs.append(Song(name: "Meant To Be",
                          Genre: "Country",
                          artistName: "Bebe Rexha",
                          imageName: "cover\(iterator)",
                          audioFileName: "Song\(iterator)"))
        
        iterator += 1
        
        //Song #14
        songs.append(Song(name: "Chop Suey!",
                          Genre: "Metal",
                          artistName: "System of a Down",
                          imageName: "cover\(iterator)",
                          audioFileName: "Song\(iterator)"))
        
        
        // ---THIS SONG DOES NOT NEED AN ITERATOR (BOTTOM OF LIST)
        
        songs.append(Song(name: "...Another Chance",
                          Genre: "Jazz",
                          artistName: "Philly Jones",
                          imageName: "cover1",
                          audioFileName: "Song1"))
        
        // THESE ARE JUST "BEATS" - KEEP AT THE BOTTOM OF THE LIST
        
        // Song #2:
        
        songs.append(Song(name: "Yellow",
                          Genre: "Alternative Rock",
                          artistName: "Coldplay",
                          imageName: "cover2",
                          audioFileName: "Song2"))
        
        // Song #3
        
        songs.append(Song(name: "Relax",
                          Genre: "Beats",
                          artistName: "Shreeya Sharda",
                          imageName: "cover3",
                          audioFileName: "relax"))
        
        
    }
    
    
    // NOTE - In this section, I will create 3 functions related to the Table
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return songs.count // OR you can do songs.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        // NOTE - We are using a Custom Table View cell class
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CustomTableViewCell
        
        let song = songs[indexPath.row]
        
        // This makes the table transparent
        tableView.backgroundColor = UIColor.clear
        
        // Cell Properties:
        
        // ANOTHER WAY TO DO THIS IS TO ORGANIZE BY ALBUM NAME
            // So, you would set the textLabel to the song.albumName and detailTextLabel to song.name
        
        // Property#1 - Song Name
        //cell.textLabel?.text = song.name
        cell.label1.text = song.name
        
        // Property#2 - GENRE Name
        //cell.detailTextLabel?.text = song.albumName
        cell.textLabel?.textColor = UIColor.systemBlue // Ensure visibility
        cell.textLabel?.text = song.Genre
        cell.textLabel?.font  = UIFont(name: "AmericanTypewriter", size: 20)
        
        // Property#3 - Accessory Type (I do not know what this is)
        cell.accessoryType = .disclosureIndicator
        
        // Property#4 - Image View
        // NOTE - This is for the original class
        //cell.imageView?.image = UIImage(named:song.imageName)
        
        // NOTE - This is for the new class (we did this so we have consistent formatting)
        cell.iconImageView.image = UIImage(named:song.imageName)
        
        
       
        
        
        
        // Property #6 - Text Label for the Album name (Slighly smaller and less bolded label)
        // Here - set the font for the detail text label
        // NOTE - We do not need this anymore b/c I created a new Label in Main which sets the font
        //cell.detailTextLabel?.font = UIFont(name: "AmericanTypewriter"
        //                                    , size: 17)
        
        
        
        cell.detailTextLabel?.textColor = UIColor.white
        
        // This makes the cells transparent
        cell.backgroundColor = UIColor.clear
        
        return cell
    }
    
    
  
    
    
    // NOTE - This function will control the height of each cell within the table
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110 // This controls the width of each row within the table
    }
    
    // NOTE - This function builds the Table that arranges all of the Music
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let position = indexPath.row
        
        guard let vc = storyboard?.instantiateViewController(identifier: "player") as? PlayerViewController else {
            return
        }
        vc.songs = songs
        vc.position = position
        
        // NOTE - To scroll on a view, just hold down on the mousepad AND then you can scroll
        present(vc, animated:true)
    }
    

    // NOTE - This is the defintion for the struct object
    // Here, we are defining the object called "Song" and we are defining the properties contained within each object

    
}

