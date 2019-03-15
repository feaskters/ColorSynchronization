//
//  GameViewController.swift
//  PurificationMonsters
//
//  Created by iOS123 on 2019/3/13.
//  Copyright © 2019年 iOS123. All rights reserved.
//

import UIKit

class GameViewController: UIViewController,GameOverProtocol {

    @IBOutlet weak var clickCount: UILabel!
    @IBOutlet weak var timeCount: UILabel!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var gameView: UIView!
    @IBOutlet weak var selectView: UIView!
    /*
     tag == 0 -> normal
     tag == 1 -> random
     tag == 2 -> level
     */
    private var tag = 0;
    private var level = 1;
    private var blocksArray : Array<Array<BlockView>> = Array<Array<BlockView>>.init()
    private var blocksSynchronizated : Array<BlockView> = Array<BlockView>.init() //已被选中的方块
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        addBlocks()
        
        //开始计时
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { (Timer) in
            self.timeCount.text = String(Int(self.timeCount.text!)! + 1)
        }
    }
    
    //页面方块初始化
    func addBlocks() {
        let scSquare :CGFloat = 400
        let characterSquare : CGFloat = 30
        let space : CGFloat = (scSquare - characterSquare * 13) / 14
        
        for i in 0...12 {
            self.blocksArray.append([])
            for j in 0...12{
                let x = space + CGFloat(j) * (characterSquare + space)
                let y = space + CGFloat(i) * (characterSquare + space)
                let cv = BlockView.init(frame: CGRect.init(x: x, y: y, width: characterSquare, height: characterSquare))
                //获取type
                let type = Int(arc4random() % 6)
                self.gameView.addSubview(cv)
                cv.setType(type: type)
                cv.setPosition(x: i, y: j)
                self.blocksArray[i].append(cv)
            }
        }
        
        switch self.tag {
        case 0:
            self.tag0()
            break
        case 1:
            break
        default:
            break
        }
    }
    
    @IBAction func changeColor(_ sender: UIButton) {
        Music.shared().musicPlayMergeEffective()
        
        //改变颜色
        for item in self.blocksSynchronizated{
            item.setType(type: sender.tag)
        }
        
        for item in self.selectView.subviews{
            (item as! UIButton).isEnabled = false
        }
        //延时一秒后允许点击
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + TimeInterval(1)) {
            for item in self.selectView.subviews{
                (item as! UIButton).isEnabled = true
            }
        }
        self.clickCount.text = String(Int(self.clickCount.text!)! + 1)
    }
    
    //处理tag0
    func tag0(){
        self.blocksArray[0][0].setFlag(flag: 1)
        self.blocksSynchronizated.append(self.blocksArray[0][0])
    }
    
    //处理tag1
    func tag1() -> Int{
        return Int(arc4random() % 2)
    }
    
    @IBAction func back(_ sender: UIButton) {
        Music.shared().musicPlayEffective()
        //退出动画
        UIView.animate(withDuration: 1, animations: {
            self.containerView.alpha = 0
            let trans = CGAffineTransform.init(scaleX: 0.0001, y: 0.0001)
            let trans2 = CGAffineTransform.init(rotationAngle: -2.5)
            let t = trans.concatenating(trans2)
            self.containerView.transform = t
        }) { (Bool) in
            self.dismiss(animated: false, completion: nil)
        }
    }
    
    func setTag(tag:Int) {
        self.tag = tag
    }
    func setLevel(level:Int ) {
        self.level = level
    }
    
    //判断结束
    func judgeEnd() {
        var flag = true //是否有无怪标致
        for items in self.blocksArray{
            for item in items{
                if item.getType() == 0{
                    flag = false
                }
            }
        }
        if flag {
            self.gameOver()
            if self.tag == 2{
                
            }
        }
    }
    
    //弹出结算页面
    func gameOver() {
        let gov = GameOverView.init(frame: CGRect.init(x: 0, y: -300, width: self.containerView.frame.width, height: 300))
        let result = ["click" : self.clickCount.text!,
                      "time" : self.timeCount.text!]
        gov.setResult(result: result)
        gov.delegate = self
        self.view.addSubview(gov)
        UIView.animate(withDuration: 0.2) {
            gov.frame = CGRect.init(x: 0, y: UIScreen.main.bounds.height / 2 - 150, width: self.containerView.frame.width, height: 300)
        }
    }
    
    //代理方法，游戏结束点击事件
    func gameOverViewTouchsBegan(sender:GameOverView) {
        self.back(UIButton.init())
        UIView.animate(withDuration: 0.2) {
            sender.frame = CGRect.init(x: 0, y: -300, width: self.containerView.frame.width, height: 300)
        }
    }
}
