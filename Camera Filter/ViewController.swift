//
//  ViewController.swift
//  Camera Filter
//
//  Created by Jaouher Bejaoui  on 29/6/2021.
//

import UIKit
import RxSwift

class ViewController: UIViewController {
    
    let disposeBag = DisposeBag()
    
    @IBOutlet weak var photoImageView : UIImageView!
    @IBOutlet weak var filterButton : UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let navController = segue.destination as? UINavigationController,
              
              let photosCVC = navController.viewControllers.first as? PhotosCollectionViewController
        else{
            fatalError("segue destination is not found")
        }
        
        photosCVC.selectedPhoto.subscribe(onNext: { [weak self] photo in
            
            DispatchQueue.main.async {
                self?.updateUI(with: photo)
            }
            
        }).disposed(by: disposeBag)
    }
    
  
    
    @IBAction func applyFilterButtonPressed(){
        guard let sourceImage = self.photoImageView.image else{
            return
        }
        
        FiltersService().applFilter(to: sourceImage)
            .subscribe(onNext: {
                filteredImage in
                DispatchQueue.main.async {
                    self.photoImageView.image = filteredImage
                }
            }).disposed(by: disposeBag)
    }
    
    private func updateUI(with : UIImage){
        self.photoImageView.image = with
        self.filterButton.isHidden = false
    }
    
    
}

