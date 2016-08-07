//
//  FeedVC.swift
//  dev-social
//
//  Created by Xhien Yi Tan on 6/08/2016.
//  Copyright © 2016 Xavier TanXY. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper
import Firebase

class FeedVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var imageAdd: CircleView!
    
    var posts = [Post]()
    var imagePick: UIImagePickerController!
    static var imageCache: NSCache<NSString, UIImage> = NSCache()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        imagePick = UIImagePickerController()
        imagePick.allowsEditing = true
        imagePick.delegate = self
        
        DataService.ds.REF_POSTS.observe(.value, with: { (snapshot) in
            if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot] {
                for snap in snapshots {
                    print("SNAP: \(snap)")
                    if let postDict = snap.value as? Dictionary<String, AnyObject> {
                        let key = snap.key
                        let post = Post(postKey: key, postData: postDict)
                        self.posts.append(post)
                    }
                }
            }
            self.tableView.reloadData()
        })
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let post = posts[indexPath.row]
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell") as? PostCell {
            
            
          
            
            if let img = FeedVC.imageCache.object(forKey: post.imageUrl){
                cell.configureCell(post: post, img: img)
                return cell
            } else {
                cell.configureCell(post: post, img: nil)
                return cell
            }
            
        } else {
            return PostCell()
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            imageAdd.image = image
        } else {
            print("Xavier: no image selected")
        }
        imagePick.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addImageTapped(_ sender: AnyObject) {
        present(imagePick, animated: true, completion: nil)
    }

    @IBAction func signOutTapped(_ sender: AnyObject) {
        let keyChainResult = KeychainWrapper.removeObjectForKey(KEY_UID)
        print("Xavier: ID removed \(keyChainResult)")
        try! FIRAuth.auth()?.signOut()
        performSegue(withIdentifier: "goToSignIn", sender: nil)
    }
    

}
