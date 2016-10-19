//
//  ViewController.swift
//  DialogViewer
//
//  Created by Kim Topley on 9/21/15.
//  Copyright © 2015 Apress Inc. All rights reserved.
//

import UIKit

class ViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    private var sections = [
        ["header": "First Witch",
         "content" : "Hey, when will the three of us meet up later?"],
        ["header" : "Second Witch",
         "content" : "When everything's straightened out."],
        ["header" : "Third Witch",
         "content" : "That'll be just before sunset."],
        ["header" : "First Witch",
         "content" : "Where?"],
        ["header" : "Second Witch",
         "content" : "The dirt patch."],
        ["header" : "Third Witch",
         "content" : "I guess we'll see Mac there."]
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        collectionView!.registerClass(ContentCell.self,
                            forCellWithReuseIdentifier: "CONTENT")
        var contentInset = collectionView!.contentInset
        contentInset.top = 20
        collectionView!.contentInset = contentInset

        let layout = collectionView!.collectionViewLayout
        let flow = layout as! UICollectionViewFlowLayout
        flow.sectionInset = UIEdgeInsetsMake(10, 20, 30, 20)
        
        collectionView!.registerClass(HeaderCell.self,
                            forSupplementaryViewOfKind: UICollectionElementKindSectionHeader,
                            withReuseIdentifier: "HEADER")
        flow.headerReferenceSize = CGSizeMake(100, 25)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func wordsInSection(section: Int) -> [String] {
        let content = sections[section]["content"]
        let spaces = NSCharacterSet.whitespaceAndNewlineCharacterSet()
        let words = content?.componentsSeparatedByCharactersInSet(spaces)
        return words!
    }
    
    override func numberOfSectionsInCollectionView(
                    collectionView: UICollectionView) -> Int {
        return sections.count
    }
    
    override func collectionView(collectionView: UICollectionView,
                    numberOfItemsInSection section: Int) -> Int {
        let words = wordsInSection(section)
        return words.count
    }
    
    override func collectionView(collectionView: UICollectionView,
                cellForItemAtIndexPath indexPath: NSIndexPath)
                -> UICollectionViewCell {
        let words = wordsInSection(indexPath.section)
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(
                        "CONTENT", forIndexPath: indexPath) as! ContentCell
        cell.maxWidth = collectionView.bounds.size.width
        cell.text = words[indexPath.row]
        return cell
    }
    
    func collectionView(collectionView: UICollectionView,
                layout collectionViewLayout: UICollectionViewLayout,
                sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let words = wordsInSection(indexPath.section)
        let size = ContentCell.sizeForContentString(words[indexPath.row],
                                forMaxWidth: collectionView.bounds.size.width)
        return size
    }
    
    override func collectionView(collectionView: UICollectionView,
                    viewForSupplementaryElementOfKind kind: String,
                    atIndexPath indexPath: NSIndexPath)
                        -> UICollectionReusableView {
        if (kind == UICollectionElementKindSectionHeader) {
            let cell =
                collectionView.dequeueReusableSupplementaryViewOfKind(
                            kind, withReuseIdentifier: "HEADER",
                            forIndexPath: indexPath) as! HeaderCell
            cell.maxWidth = collectionView.bounds.size.width
            cell.text = sections[indexPath.section]["header"]
            return cell
        }
        abort()
    }
}

