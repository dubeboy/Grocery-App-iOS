//
//  ViewController.swift
//  GroceryApp
//
//  Created by Divine.Dube on 2020/05/21.
//  Copyright © 2020 Divine.Dube. All rights reserved.
//

import UIKit
import Merchant

class ViewController: UIViewController {
    
    var selected: Grocery?
    
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            collectionView.dataSource = self
            collectionView.delegate = self
            let nib = UINib(nibName: "GroceryListItemCell", bundle: nil)
            collectionView.register(nib, forCellWithReuseIdentifier: "GroceryListItemCell")
        }
    }
    var groceries: [Grocery] = [] {
        didSet {
            collectionView.reloadData()
        }
    }
    
    let client: HTTPClient = HTTPClient()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getGrocerries()
    }
    
     //MARK: - GET
    
    private func getGrocerries() {
        client.$getGroceries { [weak self] response in
            guard let self = self else { return }
            
            switch response {
            case .success(let response):
                self.groceries = response.body
            case .failure(let e):
                print(e.localizedDescription)
            }
        }
    }
    
     //MARK: - POST and DELETE
    
    @IBAction func actionBarButtonClickedEvent(_ sender: Any) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        alert.addToggleAction { [weak self] in
            guard let self = self, let selected = self.selected else { return }
            self.client.$toggleAvailability(query: ["id": "\(selected.id ?? 0)"], body: !selected.available, completion: self.toggleResponseHandler)
        }
        
        alert.addDeleteAction { [weak self] in
            guard let self = self else { return }
            self.client.$delete(["id": "\(self.selected?.id ?? 0)"],  completion: self.deleteResponseHandler)
        }
        
        alert.addCancelAction()
    
        self.present(alert, animated: true, completion: nil)
    }
    
    private func deleteResponseHandler(response: Result<ResponseObject<StatusReponse<Bool>>, Error>) {
        switch response {
            case .success(let success):
            print(success.body.message)
            groceries.removeAll { item in
                item.id == selected?.id
            }
            collectionView.reloadData()
            case .failure(let error):
            print(error.localizedDescription)
        }
    }
    
    private func toggleResponseHandler(response: Result<ResponseObject<StatusReponse<Bool>>, Error>) {
        switch response {
        case .success(let success):
            print(success.body.message)
            collectionView.selectedCell.updateAvailability(success.body.entity)
        case .failure(let error):
            print(error.localizedDescription)
        }
    }
}

// MARK: - View related code

extension ViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let viewController = segue.destination as! AddViewController
        viewController.successClousure = { [weak self] item in
            self?.groceries.insert(item, at: 0)
            self?.collectionView?.reloadData()
        }
    }
}

extension ViewController: UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView,
                                 cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.deque(GroceryListItemCell.self, at: indexPath) else {
            return UICollectionViewCell()
        }
        cell.item = groceries[indexPath.row]
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        groceries.count
    }
}

extension ViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        CGSize(width: collectionView.bounds.width, height: 80)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as? GroceryListItemCell

        cell?.isHighlighted = true
        self.selected = cell!.item
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as? GroceryListItemCell
        
        cell?.isHighlighted = false
        selected = nil
    }
}

extension UIAlertController {
    
    func addToggleAction(handler: @escaping () -> Void) {
        addAction(createAction("Toggle", style: .default ) {
           handler()
        })
    }
    
    func addDeleteAction(handler: @escaping () -> Void) {
        addAction(createAction("Delete", style: .destructive) {
            handler()
        })
    }
    
    func addCancelAction() {
        addAction(createAction("Cancel", style: .cancel) {})
    }
    
    private func createAction(_ title: String,
                              style: UIAlertAction.Style,
                              handler:  @escaping () -> Void) -> UIAlertAction {
        UIAlertAction(title: title, style: style, handler: { _ in
            handler()
        })
    }
}

extension UICollectionView {
    func deque<T: UICollectionViewCell>(_ `class`: T.Type, at indexPath: IndexPath) -> T? {
        dequeueReusableCell(withReuseIdentifier: String(describing: `class`), for: indexPath) as? T
    }
    
    var selectedCell: GroceryListItemCell {
        let indexPath = self.indexPathsForSelectedItems!.first!
        return self.cellForItem(at: indexPath) as! GroceryListItemCell
    }
}

