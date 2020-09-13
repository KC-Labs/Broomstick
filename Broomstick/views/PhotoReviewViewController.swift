//
//  PhotoReviewViewController.swift
//  Broomstick
//
//  Created by Patrick Cui on 9/12/20.
//  Copyright © 2020 KC App Dev. All rights reserved.
//

import UIKit
import Koloda

class PhotoReviewViewController: UIViewController {
    
    init(analyer: PhotoAnalyzer) {
        self.analyzer = analyer
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //number of photo I'm on now
    var currentIndex = 0
    //filter tracking
    var filter = 0
    //analyzer object
    var analyzer: PhotoAnalyzer
    //total num of photos
    var numPhotosToReview = 0
    
    //filters
    let blurryView = UIView()
    let ssView = UIView()
    let dupView = UIView()
    
    //swiper view
    let swiperView = KolodaView(frame: CGRect(x: 0, y: 0, width: 300 * screenRatio, height: 300 * screenRatio))
    
    
    func setUp() {
        //background color
        self.view.backgroundColor = mediumColor
        //parent
        let parent = self.view!
        //back button
        let backButtonImage = UIImage(named: "back")
        let backButton = UIButton()
        backButton.frame = CGRect(x: 30 * screenRatio, y: 63 * screenRatio, width: 30 * screenRatio, height: 30 * screenRatio)
        backButton.setImage(backButtonImage, for: .normal)
        backButton.addTarget(self, action: #selector(goBack), for: .touchUpInside)
        parent.addSubview(backButton)
        //header
        let scanResultLabel = UILabel()
        scanResultLabel.frame = CGRect(x: 0, y: 0, width: 170 * screenRatio, height: 32 * screenRatio)
        scanResultLabel.textColor = whiteColor
        scanResultLabel.font = heading
        scanResultLabel.text = "Review"
        parent.addSubview(scanResultLabel)
        scanResultLabel.translatesAutoresizingMaskIntoConstraints = false
        scanResultLabel.widthAnchor.constraint(equalToConstant: 170 * screenRatio).isActive = true
        scanResultLabel.heightAnchor.constraint(equalToConstant: 32 * screenRatio).isActive = true
        scanResultLabel.leadingAnchor.constraint(equalTo: parent.leadingAnchor, constant: 31 * screenRatio).isActive = true
        scanResultLabel.topAnchor.constraint(equalTo: parent.topAnchor, constant: 102 * screenRatio).isActive = true
        //photo progress counter
        let currentPhotoLabel = UILabel()
        currentPhotoLabel.frame = CGRect(x: 260 * screenRatio, y: 100 * screenRatio, width: 64 * screenRatio, height: 36 * screenRatio)
        currentPhotoLabel.text = "\(currentIndex + 1)"
        currentPhotoLabel.font = UIFont(name: "ProximaNova-Regular", size: 42 * screenRatio)
        currentPhotoLabel.textAlignment = .right
        currentPhotoLabel.textColor = whiteColor
        parent.addSubview(currentPhotoLabel)
        let totalPhotosLabel = UILabel()
        totalPhotosLabel.frame = CGRect(x: 327 * screenRatio, y: 119 * screenRatio, width: 40 * screenRatio, height: 14 * screenRatio)
        totalPhotosLabel.font = UIFont(name: "ProximaNova-Regular", size: 14 * screenRatio)
        totalPhotosLabel.textColor = whiteColor
        numPhotosToReview = analyzer.scan_results().blurry + analyzer.scan_results().screenshots + analyzer.scan_results().duplicates
        totalPhotosLabel.text = "/ \(numPhotosToReview)"
        parent.addSubview(totalPhotosLabel)
        //select categories
        let selectCat = UILabel()
        selectCat.frame = CGRect(x: 0, y: 650 * screenRatio, width: self.view.frame.width, height: 20 * screenRatio)
        selectCat.textAlignment  = .center
        selectCat.font = boldLabel
        selectCat.textColor = whiteColor
        selectCat.text = "Filter by Category"
        parent.addSubview(selectCat)
        //category labels
        blurryView.frame = CGRect(x: 41 * screenRatio, y: 676 * screenRatio, width: 96 * screenRatio, height: 104 * screenRatio)
        //center is 48, 52
        blurryView.backgroundColor = mediumColor
        blurryView.alpha = 0.5
        let blurryImage = UIImageView()
        blurryImage.image = UIImage(named: "incoherant")
        blurryImage.frame = CGRect(x: 0, y: 0, width: 50 * screenRatio, height: 50 * screenRatio)
        blurryImage.center = CGPoint(x: 48 * screenRatio, y: 42 * screenRatio)
        blurryView.addSubview(blurryImage)
        let blurryLabel = UILabel()
        blurryLabel.frame = CGRect(x: 0, y: 75 * screenRatio, width: blurryView.frame.width, height: 14 * screenRatio)
        blurryLabel.font = smallLabel?.withSize(13 * screenRatio)
        blurryLabel.textAlignment = .center
        blurryLabel.textColor = .white
        blurryLabel.text = "Incoherant"
        blurryView.addSubview(blurryLabel)
        parent.addSubview(blurryView)
        ssView.frame = CGRect(x: 141 * screenRatio, y: 676 * screenRatio, width: 96 * screenRatio, height: 104 * screenRatio)
        ssView.backgroundColor = mediumColor
        ssView.alpha = 0.5
        let ssImage = UIImageView()
        ssImage.image = UIImage(named: "screenshot")
        ssImage.frame = CGRect(x: 0, y: 0, width: 50 * screenRatio, height: 50 * screenRatio)
        ssImage.center = CGPoint(x: 48 * screenRatio, y: 42 * screenRatio)
        ssView.addSubview(ssImage)
        let ssLabel = UILabel()
        ssLabel.frame = CGRect(x: 0, y: 75 * screenRatio, width: blurryView.frame.width, height: 14 * screenRatio)
        ssLabel.font = smallLabel?.withSize(13 * screenRatio)
        ssLabel.textAlignment = .center
        ssLabel.textColor = .white
        ssLabel.text = "Screenshots"
        ssView.addSubview(ssLabel)
        parent.addSubview(ssView)
        
        dupView.frame = CGRect(x: 241 * screenRatio, y: 676 * screenRatio, width: 96 * screenRatio, height: 104 * screenRatio)
        dupView.backgroundColor = mediumColor
        dupView.alpha = 0.5
        let dupImage = UIImageView()
        dupImage.image = UIImage(named: "duplicate")
        dupImage.frame = CGRect(x: 0, y: 0, width: 50 * screenRatio, height: 50 * screenRatio)
        dupImage.center = CGPoint(x: 48 * screenRatio, y: 42 * screenRatio)
        dupView.addSubview(dupImage)
        let dupLabel = UILabel()
        dupLabel.frame = CGRect(x: 0, y: 75 * screenRatio, width: blurryView.frame.width, height: 14 * screenRatio)
        dupLabel.font = smallLabel?.withSize(13 * screenRatio)
        dupLabel.textAlignment = .center
        dupLabel.textColor = .white
        dupLabel.text = "Duplicates"
        dupView.addSubview(dupLabel)
        parent.addSubview(dupView)
        //gseture recognizers
        let blurryRecognizer = UITapGestureRecognizer(target: self, action: #selector(blurryFilter))
        let ssRecognizer = UITapGestureRecognizer(target: self, action: #selector(ssFilter))
        let dupRecognizer = UITapGestureRecognizer(target: self, action: #selector(dupFilter))
        blurryView.addGestureRecognizer(blurryRecognizer)
        ssView.addGestureRecognizer(ssRecognizer)
        dupView.addGestureRecognizer(dupRecognizer)
        //swiper view
        swiperView.center = CGPoint(x: self.view.center.x, y: self.view.center.y - 30 * screenRatio)
        swiperView.backgroundColor = mediumColor
        swiperView.delegate = self
        swiperView.dataSource = self
        parent.addSubview(swiperView)
    }
    
    @objc func goBack() {
        
    }
    
    func setFilter(index: Int) {
        blurryView.alpha = 0.5
        ssView.alpha = 0.5
        dupView.alpha = 0.5
        if (index != filter) {
            switch index {
            case 1:
                blurryView.alpha = 1
                filter = 1
            case 2:
                ssView.alpha = 1
                filter = 2
            case 3:
                dupView.alpha = 1
                filter = 3
            default: break
            }
        } else {
            filter = 0
        }

    }
    
    @objc func blurryFilter() {
        //display only blurry photos
        setFilter(index: 1)
    }
    
    @objc func ssFilter() {
        setFilter(index: 2)
    }
    
    @objc func dupFilter() {
        setFilter(index: 3)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}

extension PhotoReviewViewController: KolodaViewDelegate, KolodaViewDataSource {
    func kolodaDidRunOutOfCards(_ koloda: KolodaView) {
        koloda.reloadData()
    }
    func koloda(_ koloda: KolodaView, didSelectCardAt index: Int) {
        //selected card
    }
    func kolodaNumberOfCards(_ koloda: KolodaView) -> Int {
        return numPhotosToReview
    }
    func kolodaSpeedThatCardShouldDrag(_ koloda: KolodaView) -> DragSpeed {
        return .fast
    }
    func koloda(_ koloda: KolodaView, viewForCardAt index: Int) -> UIView {
        let view = UIView()
        view.frame = CGRect(x: 0, y: 0, width: 300 * screenRatio, height: 300 * screenRatio)
        view.backgroundColor = darkColor
        view.layer.cornerRadius = 20 * screenRatio
        view.clipsToBounds = true
        return view
    }
    func koloda(_ koloda: KolodaView, viewForCardOverlayAt index: Int) -> OverlayView? {
        return nil
    }
}
