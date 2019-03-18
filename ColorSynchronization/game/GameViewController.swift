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
     tag == 2 -> Easy
     */
    private var tag = 0;
    private var level = 1;
    private var blocksArray : Array<Array<BlockView>> = Array<Array<BlockView>>.init()
    private var blocksSynchronizated : Array<BlockView> = Array<BlockView>.init() //已被选中的方块
    private var length = 13;
    
    lazy var lockView : UIImageView = {
        let imageView = UIImageView.init(frame: CGRect.init(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 2, width: 300, height: 300))
        imageView.image = UIImage.init(named: "lock")
        imageView.transform = CGAffineTransform.init(scaleX: 2, y: 2)
        self.gameView.addSubview(imageView)
        return imageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        addBlocks()
        
        //开始计时
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { (Timer) in
            self.timeCount.text = String(Int(self.timeCount.text!)! + 1)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        UIView.animate(withDuration: 1) {
            self.lockView.frame = self.blocksSynchronizated[0].frame
        }
    }
    
    //页面方块初始化
    func addBlocks() {
        let scSquare :CGFloat = 400
        let characterSquare : CGFloat = 30
        let space : CGFloat = (scSquare - characterSquare * 13) / 14
        
        for i in 0...length - 1 {
            self.blocksArray.append([])
            for j in 0...length - 1{
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
            self.tag1()
            break
        case 2:
            self.tag2()
            break
        default:
            break
        }
        self.synchronizeBlocksAround(block: self.blocksSynchronizated[0])
    }
    
    @IBAction func changeColor(_ sender: UIButton) {
        Music.shared().musicPlayMergeEffective()
        
        //改变颜色并进行同化
        for item in self.blocksSynchronizated{
            item.setType(type: sender.tag)
            self.synchronizeBlocksAround(block: item)
        }
        
        for item in self.selectView.subviews{
            (item as! UIButton).isEnabled = false
        }
        //延时一秒后允许点击
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + TimeInterval(1)) {
            for item in self.selectView.subviews{
                (item as! UIButton).isEnabled = true
            }
            //判断是否结束游戏
            self.judgeEnd()
        }
        self.clickCount.text = String(Int(self.clickCount.text!)! + 1)
    }
    
    //处理tag2
    func tag2(){
        let center = self.blocksArray.count/2
        self.blocksArray[center][center].setFlag(flag: 1)
        self.blocksSynchronizated.append(self.blocksArray[center][center])
    }
    
    //处理tag1
    func tag1(){
        let x = Int(arc4random() % UInt32(self.blocksArray.count))
        let y = Int(arc4random() % UInt32(self.blocksArray.count))
        self.blocksArray[x][y].setFlag(flag: 1)
        self.blocksSynchronizated.append(self.blocksArray[x][y])
    }
    
    //处理tag0
    func tag0(){
        self.blocksArray[0][0].setFlag(flag: 1)
        self.blocksSynchronizated.append(self.blocksArray[0][0])
    }
    
    //同化周围的方块
    func synchronizeBlocksAround(block:BlockView) {
        let position = block.getPosition()
        let x = position["x"]!
        let y = position["y"]!
        var flag = false //是否有可以同化的方块
        //左边方块
        if x > 0 && self.blocksArray[x - 1][y].getType() == block.getType() && self.blocksArray[x - 1][y].getFlag() == 0{
            self.blocksArray[x - 1][y].setFlag(flag: 1)
            self.blocksSynchronizated.append(self.blocksArray[x - 1][y])
            self.synchronizeBlocksAround(block: self.blocksArray[x - 1][y])
            flag = true
        }
        //右边方块
        if x < length - 1 && self.blocksArray[x + 1][y].getType() == block.getType() && self.blocksArray[x + 1][y].getFlag() == 0{
            self.blocksArray[x + 1][y].setFlag(flag: 1)
            self.blocksSynchronizated.append(self.blocksArray[x + 1][y])
            self.synchronizeBlocksAround(block: self.blocksArray[x + 1][y])
            flag = true
        }
        //上边方块
        if y > 0 && self.blocksArray[x][y - 1].getType() == block.getType() && self.blocksArray[x][y - 1].getFlag() == 0{
            self.blocksArray[x][y - 1].setFlag(flag: 1)
            self.blocksSynchronizated.append(self.blocksArray[x][y - 1])
            self.synchronizeBlocksAround(block: self.blocksArray[x][y - 1])
            flag = true
        }
        //下边方块
        if y < length - 1 && self.blocksArray[x][y + 1].getType() == block.getType() && self.blocksArray[x][y + 1].getFlag() == 0{
            self.blocksArray[x][y + 1].setFlag(flag: 1)
            self.blocksSynchronizated.append(self.blocksArray[x][y + 1])
            self.synchronizeBlocksAround(block: self.blocksArray[x][y + 1])
            flag = true
        }
        if !flag {
            return
        }
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
        if self.blocksSynchronizated.count == length * length {
            self.gameOver()
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
