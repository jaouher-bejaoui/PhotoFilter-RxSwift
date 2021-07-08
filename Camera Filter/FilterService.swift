//
//  FilterService.swift
//  Camera Filter
//
//  Created by Jaouher Bejaoui  on 2/7/2021.
//

import Foundation
import UIKit
import  CoreImage
import RxSwift


class FiltersService{
    private var context : CIContext
    
    init(){
        self.context = CIContext()
    }
    
    func applFilter(to inputImage: UIImage) -> Observable<UIImage>{
        return Observable<UIImage>.create{observer in
            self.applyFilter(to: inputImage) { filteredImage in
                observer.onNext(filteredImage)
            }
            return Disposables.create()
            
        }
    }
    
    private func applyFilter(to inputImage:UIImage, completion : @escaping ((UIImage) -> ()) ){
        let filter = CIFilter(name: "CICMYKHalftone")!
        filter.setValue(0.5, forKey: kCIInputWidthKey)
        
        if let sourceImage = CIImage(image: inputImage){
            filter.setValue(sourceImage, forKey: kCIInputImageKey)
            
            if let cgimg = self.context.createCGImage(filter.outputImage!, from: filter.outputImage!.extent){
                let processedImage = UIImage(cgImage: cgimg, scale: inputImage.scale, orientation: inputImage.imageOrientation)
                completion(processedImage)
            }
        }
    }
    
    
}
