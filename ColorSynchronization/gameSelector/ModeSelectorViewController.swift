//
//  ModeSelectorViewController.swift
//  PurificationMonsters
//
//  Created by iOS123 on 2019/3/13.
//  Copyright © 2019年 iOS123. All rights reserved.
//

import UIKit

class ModeSelectorViewController: UIViewController {

    @IBOutlet weak var containerView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //初始不可见
        self.containerView.alpha = 0
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //动画淡入
        UIView.animate(withDuration: 0.5) {
            self.containerView.alpha = 1
        }
    }

    @IBAction func back(_ sender: UIButton) {
        Music.shared().musicPlayEffective()
       //退出动画
        UIView.animate(withDuration: 1, animations: {
            self.containerView.alpha = 0
            self.containerView.transform = CGAffineTransform.init(rotationAngle: 2.5)
        }) { (Bool) in
            
            self.dismiss(animated: false, completion: nil)
        }
    }
    
    /*页面跳转
     sender.tag == 0 -> normal
     sender.tag == 1 -> Random
     sender.tag == 2 -> Rank
     */
    @IBAction func selectMode(_ sender: UIButton) {
        //播放音效
        Music.shared().musicPlayEffective()
        //退出动画
        UIView.animate(withDuration: 1, animations: {
            self.containerView.alpha = 0
            self.containerView.transform = CGAffineTransform.init(scaleX: 2, y: 2)
        }) { (Bool) in
            self.containerView.transform = CGAffineTransform.init(scaleX: 1, y: 1)
            switch sender.tag {
            case 0:
                let gvc = GameViewController.init(nibName: nil, bundle: nil)
                gvc.setTag(tag: 0)
                self.present(gvc, animated: false, completion: {
                    self.reloadInputViews()
                })
                break
            case 1:
                let gvc = GameViewController.init(nibName: nil, bundle: nil)
                gvc.setTag(tag: 1)
                self.present(gvc, animated: false, completion: {
                self.reloadInputViews()
            })
                break
            case 2:
//                let vc = LevelSelectorViewController.init(nibName: nil, bundle: nil)
//                self.present(vc, animated: false, completion: {
//                    self.reloadInputViews()
//                })
                break
            default:
                break
            }
        }
        
    }

}
