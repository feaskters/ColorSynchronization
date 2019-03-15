import UIKit

class BlockView: UIView {
    
    //type == 0-5 -> differentColor
    private var type : Int = 0
    private var position : Dictionary<String,Int>?
    //flag == 0 -> not in array
    //flag == 1 -> in array
    private var flag : Int = 0
    
    private let background = UIImageView.init(image: UIImage.init(named: "1"))
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.background.frame = CGRect.init(x: 0, y: 0, width: 30, height: 30)
        self.addSubview(background)
    }

    //更新图片状态
    func updateImage() {
        EffectiveClass.rotateLeft(view: self)
        self.background.image = UIImage.init(named: String(self.type))
    }
    
    //设置类型
    func setType(type:Int){
        self.type = type
        updateImage()
    }
    
    //获取类型
    func getType() -> Int{
        return self.type
    }
    
    //设置位置
    func setPosition(x:Int,y:Int) {
        let dic : Dictionary<String,Int> = ["x" : x,
                                            "y" : y]
        self.position = dic
    }
    
    //获取位置
    func getPosition() -> Dictionary<String,Int> {
        return self.position!
    }
    
    //设置flag
    func setFlag(flag:Int) {
        self.flag = flag
    }
    
    //获取flag
    func getFlag() -> Int {
        return self.flag
    }
    
}
