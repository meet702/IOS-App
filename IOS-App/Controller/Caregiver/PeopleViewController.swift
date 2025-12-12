//
//  PhotosViewController.swift
//  Match the Pairs Test
//
//  Created by SDC-USER on 08/12/25.
//

import UIKit

class PeopleViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate  {

    
    @IBOutlet weak var PeoplecollectionView: UICollectionView!
    
    
    var people: [PeopleModel] = [
        PeopleModel(personName: "Priyamani", personImage: "person_1"),
        PeopleModel(personName: "Priyadarshan", personImage: "person_2"),
        PeopleModel(personName: "Priya", personImage: "person_3"),
        PeopleModel(personName: "Priyam", personImage: "person_4"),
        PeopleModel(personName: "Priyanka", personImage: "person_5"),
        PeopleModel(personName: "Add Name", personImage: "person_6")
    ]
    
    var person: PeopleModel?
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        registerCell()
        PeoplecollectionView.dataSource = self
        
        let layout = generateLayout()
        PeoplecollectionView.setCollectionViewLayout(layout, animated: true)
    }
    
    func generateLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, environment -> NSCollectionLayoutSection? in
            // single section grid (3 columns)
            let item = NSCollectionLayoutItem(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0/3.0),
                    heightDimension: .absolute(200)
                )
            )
            item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)

            let groupHeight: CGFloat = 190 // tweak (image + label)
            let group = NSCollectionLayoutGroup.horizontal(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .absolute(groupHeight)
                ),
                subitem: item,
                count: 3
            )

            let section = NSCollectionLayoutSection(group: group)
            section.contentInsets = NSDirectionalEdgeInsets(top: 12, leading: 20, bottom: 20, trailing: 20)
            section.interGroupSpacing = 8
            return section
        }

        return layout
    }

    
    func registerCell() {
        PeoplecollectionView.register(UINib(nibName: "PeopleCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "peopleCollectionViewCell")

    }
    
    
    @IBAction func addPhotosButton(_ sender: UIBarButtonItem) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        
//        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//            guard let selectedImage = info[.originalImage] as? UIImage else {
//                return
//            }
//
//        }
        
        let alertController = UIAlertController(title: "Choose Image Source", message: nil, preferredStyle: .actionSheet)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let cameraAction = UIAlertAction(title: "Camera", style: .default) { _ in
                imagePicker.sourceType = .camera
                self.present(imagePicker, animated: true, completion: nil)
            }
            alertController.addAction(cameraAction)
        }
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let photoLibrary = UIAlertAction(title: "Photo Library", style: .default) { _ in
                imagePicker.sourceType = .photoLibrary
                self.present(imagePicker, animated: true, completion: nil)
            }
            alertController.addAction(photoLibrary)
        }
        
        
        alertController.popoverPresentationController?.barButtonItem = sender
        
        present(alertController, animated: true, completion: nil)
        
    }
    
}

extension PeopleViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return people.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "peopleCollectionViewCell", for: indexPath) as! PeopleCollectionViewCell
            let people = people[indexPath.row]
            cell.configurePeopleCell(person: people)
            return cell
        }
        return UICollectionViewCell()
    }
    
}
