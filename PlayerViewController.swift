//
//  PlayerViewController.swift
//  MusicProject
//
//  Created by Shreeya Sharda on 3/23/25.
//

import AVFoundation
import UIKit

class PlayerViewController: UIViewController {

    // NOTE - I am not sure why we have to re-declare the struct song (as it already belongs to ViewController)
//    struct Song {
//        let name: String
//        let albumName: String
//        let artistName: String
//        let imageName: String
//        let audioFileName: String
//    }
    
    public var position: Int = 0
    public var songs = [Song]() as? [Song] // THIS LINE GAVE ME A TON OF TROUBLE (BE CAREFUL NOT TO CHANGE IT)
    
    @IBOutlet var holder: UIView!
    
    
    var player: AVAudioPlayer?
    
    // Add in User Interface Elements
    private let albumImageView: UIImageView = {
        let imageView = UIImageView()
        UIView.ContentMode.scaleAspectFill
        return imageView
    }()
    
    // We will now create global variables for the labels when we click on a song
    
    private let songNameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.numberOfLines = 2 // Allows a sentence of multple lines to fall to the next line
        return label
    }()
    
    private let ArtistNameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.numberOfLines = 0 // Creates line wrap
        return label
    }()
    
    private let GenreNameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        label.numberOfLines = 0 // Creates line wrap
        return label
    }()
    
    // Button 1:
    let playPauseButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Lets set the background color of the holder object
        
        holder.backgroundColor = UIColor.black

    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if holder.subviews.count == 0 { // NOT SURE WHAT THIS LINE IS DOING!
            configure()
        }
    } // End of viewDidLayoutSubviews function
    
    // NOTE - This function will play the music of within the app
    func configure() {
        // Here - Set up player
        let song  = songs?[position]
        let urlString = Bundle.main.path(forResource: song?.audioFileName, ofType: "mp3")
        
        do {
            try AVAudioSession.sharedInstance().setMode(.default)
            try AVAudioSession.sharedInstance().setActive(true, options: .notifyOthersOnDeactivation)
            
            guard let urlString = urlString else {
                print (" UrlString may NOT EXIST!!!!")
                return
            }
            
            player = try AVAudioPlayer(contentsOf: URL(string: urlString)!)
            
            guard let player = player else {
                return
            }
            player.volume = 0.5 // This is starting point for the volume
            
            player.play()
        }
        
        catch {
            print("Error occured")
        }
        
        // Here - set up user interface
        
        // 1. Set up album cover
        // This is a square and will allow us to view the album Image when we click on a song
        albumImageView.frame = CGRect(x: 10, y: 10, width: holder.frame.size.width-20, height: holder.frame.size.width-20)
        
        albumImageView.image = UIImage(named: song!.imageName)
        
        // Lets change the shape of the album Image to a rounded rectangle 
        let path = UIBezierPath(roundedRect: albumImageView.bounds, cornerRadius: 20)
        let maskLayer = CAShapeLayer()
        maskLayer.path = path.cgPath
        albumImageView.layer.mask = maskLayer
        
        // Lets add the album Image to the hodler
        holder.addSubview(albumImageView)
        
        // 2. Set up Labels
        holder.addSubview(songNameLabel)
        holder.addSubview(ArtistNameLabel)
        //holder.addSubview(GenreNameLabel) // I am getting rid of the GenreName Label
        
        songNameLabel.frame = CGRect(x: 20, y: albumImageView.frame.size.height + 10, width: holder.frame.size.width-20, height: 70)
        
        ArtistNameLabel.frame = CGRect(x: 20, y: albumImageView.frame.size.height + 50, width: holder.frame.size.width-20, height: 70)
        
        //GenreNameLabel.frame = CGRect(x: 20, y: albumImageView.frame.size.height + 10, width: holder.frame.size.width-20, height: 70)
        
        songNameLabel.text = song?.name
        ArtistNameLabel.text = song?.artistName
        //GenreNameLabel.text = song?.Genre
        
        // Lets change font sizes on some of the labels
        songNameLabel.font = UIFont(name: "AvenirNextCondensed-DemiBoldItalic", size: 35)
        ArtistNameLabel.font = UIFont(name: "AvenirNextCondensed-Bold", size: 25)
        //GenreNameLabel.font = UIFont(name: "Baskerville-SemiBoldItalic", size: 30)
        
        songNameLabel.textColor = UIColor.white
        ArtistNameLabel.textColor = UIColor.white
        //GenreNameLabel.textColor = UIColor.systemTeal
        
        
        // Player 3. Set up player controls
        
        // Player controls
        
        let nextButton = UIButton()
        let backButton = UIButton()
        let fastForward = UIButton()
        
        // Frame
        let yPosition = ArtistNameLabel.frame.origin.y + 70 + 20
        let size: CGFloat = 70
        
        playPauseButton.frame = CGRect(x: (holder.frame.size.width - size) / 1.95, y: yPosition, width: size, height: size)
        
        nextButton.frame = CGRect(x: (holder.frame.size.width - size - 20), y: yPosition, width: size, height: size)
        
        backButton.frame = CGRect(x: 20, y: yPosition, width: size, height: size)
        
        fastForward.frame = CGRect(x: 40, y: yPosition + 70, width: size - 30, height: size - 30)
        // NOTE - the 'y' moves the icon UP ( - value) and DOWN (+ value)
        
        // Add actions
        playPauseButton.addTarget(self, action: #selector(didTapPlayPauseButton), for: .touchUpInside)
        nextButton.addTarget(self, action: #selector(didTapNextButton), for: .touchUpInside)
        backButton.addTarget(self, action: #selector(didTapBackButton), for: .touchUpInside)
        fastForward.addTarget(self, action: #selector(didTapFastForward), for: .touchUpInside)
        
        // Styling
        
        // Images
        playPauseButton.setBackgroundImage(UIImage(systemName: "pause.circle.fill"), for: .normal)
        backButton.setBackgroundImage(UIImage(systemName: "backward.fill"), for: .normal)
        nextButton.setBackgroundImage(UIImage(systemName: "forward.fill"), for: .normal)
        fastForward.setBackgroundImage(UIImage(systemName: "goforward.10"), for: .normal)
        // NOTE - You do not need a .fill component for the fast forward button
        
        
        playPauseButton.tintColor = .white
        backButton.tintColor = .white
        nextButton.tintColor = .white
        fastForward.tintColor = .white
        
        holder.addSubview(playPauseButton)
        holder.addSubview(backButton)
        holder.addSubview(nextButton)
        holder.addSubview(fastForward)
        
        // slider
        let slider = UISlider(frame:  CGRect(x: 20, y: Int(holder.frame.size.height)-60, width: Int(holder.frame.size.width)-40, height: 50))
        slider.value = 1
        slider.addTarget(self, action: #selector(didSlideSlider(_:) ), for: .valueChanged )
        holder.addSubview(slider)
        
    }
    
    // function on controlling fast forward button
    @objc func didTapFastForward()
    {
        
        // FILL THIS IN (COME BACK IF TIME)
    }
    
    // 3 functions on controlling the buttons of each song
    @objc func didTapBackButton()
    {
        // NOTE - This code will basically get the view of the previous track
        if position > 0 {
            position = position - 1 // Get the position of the previous track
            player?.stop()
            for subview in holder.subviews {
                subview.removeFromSuperview()
            }
            configure()
        }
        
    }
    
    @objc func didTapNextButton()
    {
        // NOTE - This code will get the view of the track after the current
        if position < (songs!.count - 1) {
            position = position + 1 // Get the position of the previous track
            player?.stop()
            for subview in holder.subviews {
                subview.removeFromSuperview()
            }
            
            
            // NOTE - This basically starts the list from the beginning
            // COME BACK HERE 
            if position == songs!.count - 1  {
                // Go back to the 1st song
                position = 0
                player?.stop()
//                for subview in holder.subviews {
//                    subview.removeFromSuperview()
//                }
                
            } // end 2nd if else
            
            configure()
        }
    }
    
    @objc func didTapPlayPauseButton()
    {
        if player?.isPlaying == true {
            
            player?.pause() // pause the song
            playPauseButton.setBackgroundImage(UIImage(systemName: "play.circle.fill"), for: .normal)
            // When we tap the pause button, we want the button to change to the "play" button
            
        }
        else {
            player?.play() // play the song
            playPauseButton.setBackgroundImage(UIImage(systemName: "pause.circle.fill"), for: .normal)
        }
    }
    
    
    @objc func didSlideSlider(_ slider: UISlider)
    {
        let value = slider.value
        // Here - adjust the volume
        player?.volume = value
    }

    
    // This function will stop the player song audio if there is a null song
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let player = player {
            //print("HEY")
            
            //player.stop() // DON't stop the music
        }
    }
}
