//
//  ViewController.swift
//  Home-Test
//
//  Created by SDC-USER on 25/11/25.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var homecollectionView: UICollectionView!
    
    var brainBoosters: [BrainBoostersCardModel] = [
        BrainBoostersCardModel(gameName: "Crossword", gameImage: "Group 353"),
        BrainBoostersCardModel(gameName: "Sudoku", gameImage: "Group 354"),
        BrainBoostersCardModel(gameName: "Match the Pairs", gameImage: "Group 355")
    ]
    
    var completedTask: [RoutineCardModel] = [
        RoutineCardModel(title: "Brush teeth", subtitle: "", timeText: "7:45 AM"),
        RoutineCardModel(title: "Have Breakfast", subtitle: "", timeText: "8:00 AM")
    ]
    var pendingTask: [RoutineCardModel] = [
        RoutineCardModel(title: "Take meds", subtitle: "Vitamin B12 - 1 capsule", timeText: "8:45 AM")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        registerCell()
        homecollectionView.dataSource = self
        
        let layout = generateLayout()
        homecollectionView.setCollectionViewLayout(layout, animated: true)
    }
    
    func generateLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout(sectionProvider: {section, env in
            
            let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(40))
            let headerItem = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: "header", alignment: .top)
            
            if section == 0 {
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(0.9))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(160))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
                group.interItemSpacing = .fixed(10)
                
                let section = NSCollectionLayoutSection(group: group)
                section.interGroupSpacing = 10
                section.contentInsets = NSDirectionalEdgeInsets(top: -10, leading: 20, bottom: -10, trailing: 20)
//                section.boundarySupplementaryItems = [headerItem]
                return section
            }
            else if section == 1 {
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(180))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
                group.interItemSpacing = .fixed(10)
                
                let section = NSCollectionLayoutSection(group: group)
                section.interGroupSpacing = 10
                section.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 20, bottom: 20, trailing: 20)

                section.boundarySupplementaryItems = [headerItem]
                return section
            }
            
            else if section == 2 {
                let itemSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .fractionalHeight(1.0)   // use a reasonable positive estimate
                )
                let item = NSCollectionLayoutItem(layoutSize: itemSize)

                let groupSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .fractionalHeight(0.40)
                )
                let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
//                group.interItemSpacing = .fixed(10)

                let section = NSCollectionLayoutSection(group: group)
//                section.interGroupSpacing = 10
                section.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 20, bottom: 20, trailing: 20)
                section.boundarySupplementaryItems = [headerItem]
                return section
            }
            
            else {
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.6), heightDimension: .fractionalHeight(0.35))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
                group.interItemSpacing = .fixed(10)
                
                let section = NSCollectionLayoutSection(group: group)
                section.interGroupSpacing = 23
                section.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 23, bottom: 0, trailing: 20)
                
                let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(50))
                let headerItem = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: "header", alignment: .top)
                
                section.orthogonalScrollingBehavior = .groupPaging
                section.boundarySupplementaryItems = [headerItem]
                return section
            }
        }
        )
        return layout
    }
    
    func registerCell() {
        homecollectionView.register(UINib(nibName: "MemoryRecapCardCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "memoryRecapCardCollectionViewCell")
        
        homecollectionView.register(UINib(nibName: "MemoryLaneCardCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "memoryLaneCardCollectionViewCell")
        
        homecollectionView.register(UINib(nibName: "HeaderView", bundle: nil), forSupplementaryViewOfKind: "header", withReuseIdentifier: "header_cell")
        
        homecollectionView.register(UINib(nibName: "BrainBoostersCardCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "brainBoostersCardCollectionViewCell")
        
        homecollectionView.register(UINib(nibName: "RoutineCardCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "routineCardCollectionViewCell")
    }


}

extension HomeViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 4
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        else if section == 1 {
            return 1
        }
        else if section == 2{
            return 1
        }
        else {
            return brainBoosters.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "memoryRecapCardCollectionViewCell", for: indexPath) as! MemoryRecapCardCollectionViewCell
            cell.configureMemoryRecapCardCell()
            return cell
        }
        else if indexPath.section == 1 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "memoryLaneCardCollectionViewCell", for: indexPath) as! MemoryLaneCardCollectionViewCell
//            let memoryLane = memoryLane[indexPath.row]
            cell.configureMemoryLaneCell()
            return cell
        }
        
        else if indexPath.section == 2 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "routineCardCollectionViewCell", for: indexPath) as! RoutineCardCollectionViewCell
            cell.configureRoutineCell(completed: completedTask, pending: pendingTask)
            return cell
        }
        
        else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "brainBoostersCardCollectionViewCell", for: indexPath) as! BrainBoostersCardCollectionViewCell
            let brainBoosters = brainBoosters[indexPath.row]
            cell.configureBrainBoostersCell(brainBooster: brainBoosters)
            return cell
        }
    }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        // Create the header view
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: "header", withReuseIdentifier: "header_cell", for: indexPath) as! HeaderView
//        headerView.backgroundColor = .blue
        if indexPath.section == 0 {
            headerView.configureHeaderCell(text: "Memory Recap")
        }
        else if indexPath.section == 1 {
            headerView.configureHeaderCell(text: "Memory Lane")
        }
        
        else if indexPath.section == 2 {
            headerView.configureHeaderCell(text: "My Routine")
        }
        else {
            headerView.configureHeaderCell(text: "Brain Boosters")
        }
        return headerView
    }
    
}


