//
//  ViewController.swift
//  ColorSynchronization
//
//  Created by iOS123 on 2019/3/15.
//  Copyright © 2019年 iOS123. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    
    @IBOutlet weak var music_btn: UIButton!
    @IBOutlet weak var titleLabel: UIView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var tip_btn: UIButton!
    @IBOutlet weak var blockView: UIView!
    
    //懒加载提示view
    lazy var tipView : UIView = {
        
        //初始化view
        let view = UIView.init()
        view.frame = CGRect.init(x: 30, y: self.containerView.frame.origin.y - 500, width: UIScreen.main.bounds.width - 60, height: 0)
        //测试
        view.clipsToBounds = true
        
        //添加控件
        //添加背景图片
        let backImage = UIImageView.init(image: UIImage.init(named: "tipbackground"))
        backImage.frame = CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width - 60, height: 250)
        view.addSubview(backImage)
        
        //添加提示语
        let tip = UILabel.init(frame: CGRect.init(x: 40, y: 20, width: UIScreen.main.bounds.width - 100, height: 200))
        tip.numberOfLines = 0
        tip.font = UIFont.init(name: "Marker Felt", size: 18)
        if SystemLanguageClass.getCurrentLanguage() == "cn"{
            tip.text = "玩法介绍: \n\t 点击一个颜色方块来改变选中方块的颜色。当所有方块都被同化成一种颜色时，获得胜利！"
        }else{
            tip.text = "How to play: \n\t Click a color block to change the color of selected blocks.When all blocks are synchronized to same color, you win!"
        }
        tip.textColor = #colorLiteral(red: 0.4470588235, green: 0.2705882353, blue: 0.09019607843, alpha: 1)
        view.addSubview(tip)
        
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //判断当前是否静音
        if Music.shared().getMuteVolume() == 0 {
            music_btn.setBackgroundImage(UIImage.init(named: "mute"), for: UIControl.State.normal)
        }else{
            music_btn.setBackgroundImage(UIImage.init(named: "unmute"), for: UIControl.State.normal)
        }
        //添加提示view
        self.view .addSubview(self.tipView)
        

        Timer.scheduledTimer(withTimeInterval: 2, repeats: true) { (Timer) in
            //标题晃动效果
            EffectiveClass.shade(view: self.titleLabel)
            //方块旋转效果
            for item in self.blockView.subviews{
                EffectiveClass.rotateLeft(view: item)
            }
        }
   
    }
    
    @IBAction func start(_ sender: UIButton) {
        Music.shared().musicPlayEffective()
        
        self.tip_btn.tag = 1
        self.tip(self.tip_btn)
        //页面退出动画
        UIView.animate(withDuration: 1, animations: {
            self.titleLabel.frame = CGRect.init(x: self.titleLabel.frame.origin.x, y: -500, width: 0, height: 0)
            self.containerView.frame = CGRect.init(x: self.containerView.frame.origin.x, y: UIScreen.main.bounds.height + 100, width: 0, height: 0)
        }) { (Bool) in
            let msvc = ModeSelectorViewController.init(nibName: nil, bundle: nil)
            self.present(msvc, animated: false, completion: nil)
        }
    }
    
    //提示按钮
    @IBAction func tip(_ sender: UIButton) {
        Music.shared().musicPlayEffective()
        if sender.tag == 0 {
            sender.tag = 1
            //显示提示View
            UIView.animate(withDuration: 0.8) {
                self.tipView.frame = CGRect.init(x: 30, y: self.containerView.frame.origin.y - 200, width: UIScreen.main.bounds.width - 60, height: 250)
            }
        }else{
            sender.tag = 0
            //关闭提示view
            UIView.animate(withDuration: 0.8, animations: {
                self.tipView.frame = CGRect.init(x: 30, y: self.containerView.frame.origin.y - 200, width: UIScreen.main.bounds.width - 60, height: 0)
            })
        }
    }
    
    //音乐开关
    @IBAction func muteOrNot(_ sender: UIButton) {
        //播放音效
        let music = Music.shared()
        music.musicPlayEffective()
        //更改静音状态
        music.musicChangeMute()
        //判断当前是否静音
        if music.getMuteVolume() <= 0 {
            sender.setImage(UIImage.init(named: "mute"), for: UIControl.State.normal)
        }else{
            sender.setImage(UIImage.init(named: "unmute"), for: UIControl.State.normal)
        }
    }


}

