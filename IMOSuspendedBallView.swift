//
//  IMOSuspendedBallView.swift
//  wuwei
//
//  Created by wuwei on 16/6/2.
//  Copyright © 2016年 IMO. All rights reserved.
//

import UIKit

private let ScreenHeight = UIScreen.mainScreen().bounds.size.height
private let ScreenWidth = UIScreen.mainScreen().bounds.size.width
private let cornerRadio:CGFloat = 30.0
private let placeWidth = 5.0
private let centerX:CGFloat = 30.0  //x半径
private let centerY:CGFloat = 30.0  //y半径

class IMOSuspendedBallView: UIView,UIGestureRecognizerDelegate{
    
    enum SuspendedBallLocation:Int {
        case SuspendedBallLocation_LeftTop = 0
        case SuspendedBallLocation_Top
        case SuspendedBallLocation_RightTop
        case SuspendedBallLocation_Right
        case SuspendedBallLocation_RightBottom
        case SuspendedBallLocation_Bottom
        case SuspendedBallLocation_LeftBottom
        case SuspendedBallLocation_Left
    }
    
    private var ballBtn:UIButton?
    private var timeLable:UILabel?
    private var currentCenter:CGPoint?
    private var panEndCenter:CGPoint = CGPointMake(0, 0)
    private var currentLocation:SuspendedBallLocation?
    private var mTimer:NSTimer?
    
//MARK:- init method
    override init(frame: CGRect) {
        super.init(frame: CGRectMake(0, 0, CGFloat(2 * centerX), CGFloat(2 * centerY)))
        self.addSubview(self.getBallBtn())
        self.getBallBtn().addSubview(self.getTimeLable())
        self.backgroundColor = UIColor.clearColor()
        self.currentCenter = CGPoint.init(x: 30, y: 200) //初始位置
        self.calculateShowCenter(self.currentCenter!)
        self.configLocation(self.currentCenter!)
        //跟随手指拖动
        let moveGes:UIPanGestureRecognizer = UIPanGestureRecognizer.init(target: self, action: #selector(self.dragBallView))
        self.addGestureRecognizer(moveGes)
        //定时器更新时间
        mTimer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: #selector(self.updateTalkTime), userInfo: nil, repeats: true)
        mTimer?.fire()
        //添加到window上
        self.ww_getKeyWindow().addSubview(self)
        //显示在视图的最上层
        self.ww_getKeyWindow().bringSubviewToFront(self)

    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
   deinit{
        NSLog("IMOSuspendedBallView deinit")
    }
    
 //MARK:- other method
    func updateTalkTime() {
        let time = NSDate()
        let dateFormate = NSDateFormatter()
        dateFormate.dateFormat = "HH:mm:ss"
        let nowTime = dateFormate.stringFromDate(time)
        self.getTimeLable().text = "\(nowTime)"
    }
    
    //跟随手指拖动
    func dragBallView(panGes:UIPanGestureRecognizer) {
        let translation:CGPoint = panGes.translationInView(self.ww_getKeyWindow())
        let center:CGPoint = self.center
        self.center = CGPointMake(center.x+translation.x, center.y+translation.y)
        panGes .setTranslation(CGPointMake(0, 0), inView: self.ww_getKeyWindow())
        if panGes.state == UIGestureRecognizerState.Ended{
            self.panEndCenter = self.center
            self.caculateBallCenter()
        }
    }
    
    //计算中心位置
    func caculateBallCenter() {
        if (self.panEndCenter.x>centerX && self.panEndCenter.x < ScreenWidth-centerX && self.panEndCenter.y>centerY && self.panEndCenter.y<ScreenHeight-centerY) {
            if (self.panEndCenter.y<3*centerY) {
                self.calculateBallNewCenter(CGPointMake(self.panEndCenter.x, centerY))
            }
            else if (self.panEndCenter.y>ScreenHeight-3*centerY)
            {
                self.calculateBallNewCenter(CGPointMake(self.panEndCenter.x, ScreenHeight-centerY))
            }
            else
            {
                if (self.panEndCenter.x<=ScreenWidth/2) {
                    self.calculateBallNewCenter(CGPointMake(centerX, self.panEndCenter.y))
                }
                else{
                    self.calculateBallNewCenter(CGPointMake(ScreenWidth-centerX, self.panEndCenter.y))
                }
            }
        }
        else
        {
            if (self.panEndCenter.x<=centerX && self.panEndCenter.y<=centerY)
            {
                self.calculateBallNewCenter(CGPointMake(centerX, centerY))
            }
            else if (self.panEndCenter.x>=ScreenWidth-centerX && self.panEndCenter.y<=centerY)
            {
                self.calculateBallNewCenter(CGPointMake(ScreenWidth-centerX, centerY))
            }
            else if (self.panEndCenter.x>=ScreenWidth-centerX && self.panEndCenter.y>=ScreenHeight-centerY)
            {
                self.calculateBallNewCenter(CGPointMake(ScreenWidth-centerX, ScreenHeight-centerY))
            }
            else if(self.panEndCenter.x<=centerX && self.panEndCenter.y>=ScreenHeight-centerY)
            {
                self.calculateBallNewCenter(CGPointMake(centerX, ScreenHeight-centerY))
            }
            else if (self.panEndCenter.x>centerX && self.panEndCenter.x<ScreenWidth-centerX && self.panEndCenter.y<centerY)
            {
                self.calculateBallNewCenter(CGPointMake(self.panEndCenter.x, centerY))
            }
            else if (self.panEndCenter.x>centerX && self.panEndCenter.x<ScreenWidth-centerX && self.panEndCenter.y>ScreenHeight-centerY)
            {
                self.calculateBallNewCenter(CGPointMake(self.panEndCenter.x, ScreenHeight-centerY))
            }
            else if (self.panEndCenter.y>centerY && self.panEndCenter.y<ScreenHeight-centerY && self.panEndCenter.x<centerX)
            {
                self.calculateBallNewCenter(CGPointMake(centerX,self.panEndCenter.y))
            }
            else if (self.panEndCenter.y>centerY && self.panEndCenter.y<ScreenHeight-centerY && self.panEndCenter.x>ScreenWidth-centerX)
            {
                self.calculateBallNewCenter(CGPointMake(ScreenWidth-centerX,self.panEndCenter.y))
            }
        }

    }
    
    //
    func calculateBallNewCenter(point:CGPoint) {
        self.currentCenter = point
        self.configLocation(point)
        unowned let weakSelf = self
        UIView.animateWithDuration(0.3) { 
            weakSelf.center = CGPointMake(point.x, point.y)
        }
    }

    func calculateShowCenter(point:CGPoint) {
        unowned let weakSelf = self
        UIView.animateWithDuration(0.3) {
            weakSelf.center = CGPointMake(point.x, point.y)
        }
    }
    
    //当前方位
    func configLocation(point:CGPoint) {
        if (point.x <= centerX*3 && point.y <= centerY*3) {
            self.currentLocation = .SuspendedBallLocation_LeftTop;
        }
        else if (point.x>centerX*3 && point.x<ScreenWidth-centerX*3 && point.y == centerY)
        {
            self.currentLocation = .SuspendedBallLocation_Top;
        }
        else if (point.x >= ScreenWidth-centerX*3 && point.y <= 3*centerY)
        {
            self.currentLocation = .SuspendedBallLocation_RightTop;
        }
        else if (point.x == ScreenWidth-centerX && point.y>3*centerY && point.y<ScreenHeight-centerY*3)
        {
            self.currentLocation = .SuspendedBallLocation_Right;
        }
        else if (point.x >= ScreenWidth-3*centerX && point.y >= ScreenHeight-3*centerY)
        {
            self.currentLocation = .SuspendedBallLocation_RightBottom;
        }
        else if (point.y == ScreenHeight-centerY && point.x > 3*centerX && point.x<ScreenWidth-3*centerX)
        {
            self.currentLocation = .SuspendedBallLocation_Bottom;
        }
        else if (point.x <= 3*centerX && point.y >= ScreenHeight-3*centerY)
        {
            self.currentLocation = .SuspendedBallLocation_LeftBottom;
        }
        else if (point.x == centerX && point.y > 3*centerY && point.y<ScreenHeight-3*centerY)
        {
            self.currentLocation = .SuspendedBallLocation_Left;
        }
    }
    
    //单列获取悬浮起按钮
    func getBallBtn() -> UIButton {
        if ballBtn == nil {
            ballBtn = UIButton.init(type: .Custom)
            ballBtn?.setBackgroundImage(UIImage.init(named: "phone_talking"), forState: .Normal)
            ballBtn?.frame = CGRectMake(0, 0, CGFloat(2 * centerX), CGFloat(2 * centerY))
            ballBtn?.layer.masksToBounds = true
            ballBtn?.layer.cornerRadius = cornerRadio
            ballBtn?.addTarget(self, action: #selector(clickBallViewAction), forControlEvents: .TouchUpInside)
        }
        return ballBtn!
    }
    
    //时间lable
    func getTimeLable() -> UILabel {
        if timeLable == nil{
            timeLable = UILabel.init(frame: CGRectMake(0, centerY, 2 * centerX, centerY - 2))
            timeLable?.textColor = UIColor.whiteColor()
            timeLable?.textAlignment = .Center
            timeLable?.font = UIFont.init(name: "Helvetica", size: 12)
        }
        return timeLable!
    }
    
//MARK:- action
    func clickBallViewAction() {
        mTimer?.invalidate()
        mTimer = nil
        self.removeFromSuperview()
    }
    
//MARK:- private utility
    func ww_getKeyWindow() -> UIWindow {
        if UIApplication.sharedApplication().keyWindow == nil {
            return ((UIApplication.sharedApplication().delegate?.window)!)!
        }else{
            return UIApplication.sharedApplication().keyWindow!
        }
    }
    
}
