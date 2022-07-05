//
//  ViewController.swift
//  RxTableView
//
//  Created by Paul Matar on 02/07/2022.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    let tableViewItemsSectioned = BehaviorRelay(value: [
        SectionModel(header: "Main Course", items: [
            Food(name: "Hamburger", image: "hamburger"),
            Food(name: "Pizza", image: "pizza"),
            Food(name: "Salmon", image: "salmon"),
            Food(name: "Spaghetti", image: "spaghetti"),
            Food(name: "Shawarma", image: "shawarma"),
            
            Food(name: "Sandwich", image: "sandwich"),
            Food(name: "Curry", image: "curry"),
            Food(name: "Cheese salad", image: "cheese-salad"),
            Food(name: "Veggy salad", image: "veggy-salad"),
            Food(name: "Ribs", image: "ribs"),
            Food(name: "Masala", image: "masala"),
        ]),
        SectionModel(header: "Desserts", items: [
            Food(name: "Pancakes", image: "pancakes"),
            Food(name: "Tiramisu", image: "tiramisu"),
            Food(name: "Cake", image: "cake"),
            Food(name: "Cheesecake", image: "cheesecake"),
        ])
    ])
    
    let dataSource = RxTableViewSectionedReloadDataSource<SectionModel>(configureCell: { dataS, tView, index, item in
        let cell = tView.dequeueReusableCell(withIdentifier: "cell", for: index) as! FoodTableViewCell
        cell.foodLabel.text = item.name
        cell.foodImageView.image = UIImage(named: item.image)
        
        return cell
    },
    titleForHeaderInSection: { dataS, index in
        dataS.sectionModels[index].header
    })
    
    private let bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Menu"
        bindTableView()
        selectTableView()
    }
    
    
    private func bindTableView() {
        searchBar.rx.text.orEmpty
            .throttle(.microseconds(300), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .map { query in
                self.tableViewItemsSectioned
                    .value
                    .map {
                        SectionModel(
                            header: $0.header,
                            items: $0.items
                                .filter { query.isEmpty || $0.name.lowercased().contains(query.lowercased()) }
                        )
                    }
            }
            .bind(to: tableView
                .rx
                .items(dataSource: dataSource))
            .disposed(by: bag)
    }
    
    private func selectTableView() {
        tableView.rx.modelSelected(Food.self)
            .subscribe(onNext: { food in
                let foodVC = self.storyboard?.instantiateViewController(withIdentifier: "detail") as! DetailedViewController
                foodVC.imageName.accept(food.image)
                self.navigationController?.pushViewController(foodVC, animated: true)
            })
            .disposed(by: bag)
        
        tableView.rx.itemSelected
            .subscribe(onNext: { indexPath in
                self.tableView.deselectRow(at: indexPath, animated: true)
            })
            .disposed(by: bag)
    }
}

