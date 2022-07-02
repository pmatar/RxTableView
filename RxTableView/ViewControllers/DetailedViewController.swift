//
//  DetailedViewController.swift
//  RxTableView
//
//  Created by Paul Matar on 02/07/2022.
//

import UIKit
import RxSwift
import RxCocoa

class DetailedViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    
    let imageName = BehaviorRelay<String>(value: "")
    let bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageName.map { UIImage(named: $0) }
            .bind(to: imageView.rx.image)
            .disposed(by: bag)
    }
    


}
