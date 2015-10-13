//
//  RootViewController.m
//  打飞机练习2
//
//  Created by qianfeng on 15/8/29.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "RootViewController.h"
#import "AirPlaneModel.h"
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>


#define MOVE_SPEED 0.5
#define BULLET_FIRE 0.4
#define BULLET_SPEED 0.02
#define BULLET_HIGH 5
#define MONSTER_FIRE 1
#define MONSTER_SPEED 0.01
#define MONSTER_HIGH 1





@interface RootViewController ()

@end

@implementation RootViewController{
    
    CGSize _size;
    AirPlaneModel * _AirPlane;
    NSTimer * _TimerHigh;
    NSTimer * _TimerPlane;
    NSUInteger _numberBullet;
    NSUInteger _numberMonster;
    NSTimer * _timerBulletFire;
    NSTimer * _timerBulletMove;
    BOOL _isFire;
    NSTimer * _timerMonsterFire;
    NSTimer * _timerMonsterMove;
    NSTimer * _timerMonsterDie;
    NSUInteger _Score;
    NSUInteger _HP;
    AVAudioPlayer * _player;
    
    
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self createBackRound];
    [self createValue];
    [self createAirplane];
    [self createBullet];
    [self creatMonster];
    [self createLabel];
    [self createTimer];
    [self createButton];
//    [self createPlayer:@"game_music.mp3"];
    
    
    
    
    
    
   

}




#pragma mark -----------CreateMySelf
//创建背景
-(void)createBackRound{
    _size = [UIScreen mainScreen].bounds.size;
    UIButton * backround = [UIButton buttonWithType:UIButtonTypeCustom];
    backround.frame = CGRectMake(0, 0, _size.width, _size.height);
    [backround setBackgroundImage:[UIImage imageNamed:@"10233047,2560,1600.jpg"] forState:UIControlStateNormal];
    backround.userInteractionEnabled = NO;
    [self.view addSubview:backround];
    
}
//-----------创建数据----------
-(void)createValue{
    _numberBullet = 0;
    _numberMonster = 0;
    _isFire = NO;
    _Score = 0;
    _HP = 3;
    
    
    
}
//-----------创建三个button ----------------
-(void)createButton{
    
    
    NSArray * array = @[@"button_left.png",@"button.png",@"button_right.png"];
    for (int i = 0 ; i < 3 ; i ++) {
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake((_size.width - 120)/4*(i+1) +i*40, _size.height - 40, 40, 40);
        [button setBackgroundImage:[UIImage imageNamed:array[i]] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(onButtonClick:) forControlEvents:UIControlEventTouchDown];
        button.tag = i+1;
        [self.view addSubview:button];
    }
//创建死亡button
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(1001, 0, 0, 0);
    [button setBackgroundImage:[UIImage imageNamed:@"16874371_1356414123333.jpg"] forState:UIControlStateNormal];
    [button setTitle:@"你死了＊＋＊" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont boldSystemFontOfSize:30];
    button.titleLabel.textAlignment = NSTextAlignmentCenter;
    [button addTarget:self action:@selector(onButtonClick:) forControlEvents:UIControlEventTouchDown];
    button.tag = 4;
    button.layer.borderColor = [[UIColor whiteColor]CGColor];
    button.layer.borderWidth = 3;
    [self.view addSubview:button];
    

}

//-----------创建生命值分数榜--------
-(void)createLabel{
    NSArray * array = @[@"分数:000000",@"生命:3"];
    for (int i = 0 ; i < 2; i ++) {
        UILabel * label = [[UILabel alloc]init];
        label.frame = CGRectMake((_size.width - 80)*i, 0, 80, 50);
        label.text =array[i];
        label.textColor = [UIColor redColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.adjustsFontSizeToFitWidth = YES;
        label.font = [UIFont boldSystemFontOfSize:20];
        label.layer.borderColor = [[UIColor yellowColor]CGColor];
        label.layer.borderWidth = 3;
        label.tag = i + 5;
        [self.view addSubview:label];
        
 
    }

}

//-----------创建飞机---------------
-(void)createAirplane{
   _AirPlane = [[AirPlaneModel alloc]init];
    [_AirPlane setBackgroundImage:[UIImage imageNamed:@"tank_nomal_up.png"] forState:UIControlStateNormal];
    _AirPlane.userInteractionEnabled = NO;
    [self.view addSubview:_AirPlane];
}
//-----------创建计时器------------
-(void)createTimer{
    
//    飞机移动定时器
    _TimerPlane  = [NSTimer scheduledTimerWithTimeInterval:MOVE_SPEED target:self selector:@selector(everyTimeMove) userInfo:nil repeats:YES];
    [_TimerPlane setFireDate:[NSDate distantFuture]];

//    按钮判断是否高亮状态的定时器
    _TimerHigh = [NSTimer scheduledTimerWithTimeInterval:0.001 target:self selector:@selector(everyTimeHigh) userInfo:nil repeats:YES];
    
//    子弹发射定时器
    
    _timerBulletFire = [NSTimer scheduledTimerWithTimeInterval:BULLET_FIRE target:self selector:@selector(everyTimerBulletFire) userInfo:nil repeats:YES];
    [_timerBulletFire setFireDate:[NSDate distantFuture]];
    
//    子弹移动定时器
    _timerBulletMove = [NSTimer scheduledTimerWithTimeInterval:BULLET_SPEED target:self selector:@selector(everyTimerBulletMove) userInfo:nil repeats:YES];
    
//    小怪兽发射定时器
    _timerMonsterFire = [NSTimer scheduledTimerWithTimeInterval:MONSTER_FIRE target:self selector:@selector(everyTimerMonsterFire) userInfo:nil repeats:YES];
    
//    小怪兽移动定时器
    _timerMonsterMove = [NSTimer scheduledTimerWithTimeInterval:MONSTER_SPEED target:self selector:@selector(everyTimeMonsterMove) userInfo:nil repeats:YES];
    
//    小怪兽死亡定时器
    _timerMonsterDie = [NSTimer scheduledTimerWithTimeInterval:0.001 target:self selector:@selector(everyTimeMonsterDie) userInfo:nil repeats:YES];
    
    
}
//创建50颗子弹
-(void)createBullet{
    for (int i = 0 ; i < 50; i++) {
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(-100, 0, 5, 5);
        [button setBackgroundImage:[UIImage imageNamed:@"3.png"] forState:UIControlStateNormal];
        button.userInteractionEnabled = NO;
        [button setBackgroundColor:[UIColor yellowColor]];
        button.tag = 10 + i;
        [self.view addSubview:button];
    }
}

//创建50个小怪兽
-(void)creatMonster{
    for (int i = 0; i < 50 ; i ++) {
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(1000, 0, 0, 0);
        [button setImage:[UIImage imageNamed:@"tank_nomal_down.png"] forState:UIControlStateNormal];
        [button setBackgroundColor:[UIColor colorWithRed:arc4random()%100 * 0.01 green:arc4random()%100 * 0.01 blue:arc4random()%100 * 0.01 alpha:1]];
        button.userInteractionEnabled =NO;
        button.tag = 60 +i;
        [self.view addSubview:button];
    }
}

//创建小短音频
-(void)createSounds:(NSString *)soundsName{
    NSArray * array = [soundsName componentsSeparatedByString:@"."];
    NSString * path = [[NSBundle mainBundle]pathForResource:array[0] ofType:array[1]];
    NSURL * url = [NSURL fileURLWithPath:path];
    
    
    SystemSoundID  soundsId;
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)url, &soundsId);
    AudioServicesPlaySystemSound(soundsId);
}

//创建长视频
-(void)createPlayer:(NSString *)name{
    NSArray * array = [name componentsSeparatedByString:@"."];
    NSString * path = [[NSBundle mainBundle]pathForResource:array[0] ofType:array[1]];
    NSURL * url = [NSURL fileURLWithPath:path];
    
    _player = [[AVAudioPlayer alloc]initWithContentsOfURL:url error:nil];
    _player.numberOfLoops = -1;
    [_player prepareToPlay];
    [_player play];
    
}

#pragma mark -----------Timer_action
//飞机移动计时器响应
-(void)everyTimeMove{
    [_AirPlane moveLeftOrRight];
}
//HIght计时器响应
-(void)everyTimeHigh{
        UIButton * button1 = (UIButton *)[self.view viewWithTag:1];
    UIButton * button2 = (UIButton *)[self.view viewWithTag:3];
    if ((button1.isHighlighted && !button2.isHighlighted)||(!button1.isHighlighted && button2.isHighlighted)) {
        [_TimerPlane setFireDate:[NSDate distantPast]];
        if (_AirPlane.frame.origin.x <= 0) {
            [_TimerPlane setFireDate:[NSDate distantFuture]];
            CGRect rect = _AirPlane.frame;
            rect.origin.x += 1;
            _AirPlane.frame = rect;
        }
        if (_AirPlane.frame.origin.x >= _size.width -40) {
            [_TimerPlane setFireDate:[NSDate distantFuture]];
            CGRect rect = _AirPlane.frame;
            rect.origin.x -=1;
            _AirPlane.frame = rect;
        }
    }else{
        [_TimerPlane setFireDate:[NSDate distantFuture]];
    }
}

//子弹开火计时器
-(void)everyTimerBulletFire{
    _numberBullet ++;
    if (_numberBullet == 50) {
        _numberBullet = 0;
    }
    UIButton * button = (UIButton *)[self.view viewWithTag:10 + _numberBullet];
    button.frame = CGRectMake(_AirPlane.frame.origin.x + 20, _AirPlane.frame.origin.y, 5, 5);
//    [self createSounds:@"bullet.mp3"];
    
}

//子弹移动计时器
-(void)everyTimerBulletMove{
    for (int i = 0 ; i < 50; i ++) {
        UIButton * button = (UIButton *)[self.view viewWithTag:10 + i];
        CGRect rect = [button frame];
        rect.origin.y -= BULLET_HIGH;
        button.frame = rect;
        
    }
    
}

//小怪兽开火计时器
-(void)everyTimerMonsterFire{

    for (int i = 0 ; i < arc4random()%3+0; i++) {
        UIButton * button = (UIButton * )[self.view viewWithTag:60 + _numberMonster];
        int number = _size.width - 40 ;
        button.frame = CGRectMake(arc4random()%number + 0, -30, 40, 40);
        _numberMonster ++;
        if (50 == _numberMonster) {
            _numberMonster =0;
//            [self createSounds:@"enemy1_down.mp3"];
    }
}

    
}

//小怪兽移动计时器
-(void)everyTimeMonsterMove{
    
    for (int i = 0 ; i < 50 ; i ++) {
        UIButton * button = (UIButton *)[self.view viewWithTag:60 + i];
        CGRect rect = button.frame;
        rect.origin.y += MONSTER_HIGH;
        button.frame = rect;
//        [self createSounds:@"enemy2_out.mp3"];
    }
}

//小怪兽死亡计时器
-(void)everyTimeMonsterDie{
    for (int i = 0 ; i < 50; i++) {
        UIButton * buttonBullet = (UIButton *)[self.view viewWithTag:10 + i];
        if (buttonBullet.frame.origin.y <= 0) {
            buttonBullet.frame = CGRectMake(-100, 0, 5, 5);
        }
        for (int j = 0 ; j < 50 ; j ++) {
            UIButton * buttonMonster = (UIButton * )[self.view viewWithTag:60 + j];
            if (buttonMonster.frame.origin.y > _AirPlane.frame.origin.y -40 && buttonMonster.frame.origin.x <= _AirPlane.frame.origin.x + 40 && buttonMonster.frame.origin.x+40 >= _AirPlane.frame.origin.x ) {
                [self endGame];
            }
            
            if (buttonBullet.frame.origin.x <= buttonMonster.frame.origin.x+40 && buttonBullet.frame.origin.x+5 >= buttonMonster.frame.origin.x) {
                if (buttonBullet.frame.origin.y <= buttonMonster.frame.origin.y + 40) {
                    buttonMonster.frame = CGRectMake(1000, 0, 0, 0);
                    buttonBullet.frame = CGRectMake(-100, 0, 5, 5);
                    UILabel * Score = (UILabel * )[self.view viewWithTag:5];
                    _Score += 100;
                    Score.text = [NSString stringWithFormat:@"分数:%.6d",_Score];
//                    [self createSounds:@"enemy3_down.mp3"];
                }
            }
        
            if (buttonMonster.frame.origin.x < 500 && buttonMonster.frame.origin.y >= _AirPlane.frame.origin.y + 40) {
                buttonMonster.frame = CGRectMake(1000, 0, 0, 0);
                _HP --;
                UILabel * label = (UILabel * )[self.view viewWithTag:6];
                label.text = [NSString stringWithFormat:@"生命:%d",_HP];
                if (_HP == 0) {
                    [self endGame];
                    
                }
            }
        
        }
        
    }
}


#pragma mark -------------Button_action
-(void)onButtonClick:(UIButton * )sender{
    
    if (1 == sender.tag) {
        _AirPlane.direction = @"-1";
        
    }
    if (2 == sender.tag) {
        if (!_isFire) {
        [_timerBulletFire setFireDate:[NSDate distantPast]];
            _isFire = !_isFire;
        }else if (_isFire){
            [_timerBulletFire setFireDate:[NSDate distantFuture]];
            _isFire = !_isFire;
        }
        
    }
    
    
    if (3 == sender.tag) {
        _AirPlane.direction = @"1";
    }
    
    if (4 == sender.tag) {
        [self starGamen];
    }
    
}
-(void)dsada{

//sadasd
}
//游戏结束
-(void)endGame{
    [_timerBulletFire setFireDate:[NSDate distantFuture]];
    [_timerMonsterFire setFireDate:[NSDate distantFuture]];
    [_TimerPlane setFireDate:[NSDate distantFuture]];
    [_TimerHigh setFireDate:[NSDate distantFuture]];
    [_timerMonsterMove setFireDate:[NSDate distantFuture]];
    [_timerBulletMove setFireDate:[NSDate distantFuture]];
    UIButton * button = (UIButton *)[self.view viewWithTag:4];
    button.frame = CGRectMake((_size.width - 200)/2, (_size.height - 80)/2, 200, 80);
//    [self createSounds:@"game_over.mp3"];

}

//游戏重新开始
-(void)starGamen{
    [_timerBulletFire setFireDate:[NSDate distantPast]];
    [_timerMonsterFire setFireDate:[NSDate distantPast]];
    [_TimerPlane setFireDate:[NSDate distantPast]];
    [_TimerHigh setFireDate:[NSDate distantPast]];
    [_timerBulletMove setFireDate:[NSDate distantPast]];
    [_timerMonsterMove setFireDate:[NSDate distantPast]];
    UILabel * label1 = (UILabel *)[self.view viewWithTag:5];
    UILabel * label2 = (UILabel *)[self.view viewWithTag:6];
    label1.text = @"分数:000000";
    label2.text = @"生命:3";
    _Score = 0;
    _HP = 3;
    UIButton * button = (UIButton *)[self.view viewWithTag:4];
    button.frame = CGRectMake(1001, 0, 0, 0);
    for (int i = 0 ; i < 50; i ++) {
        UIButton * buttonMonster = (UIButton *)[self.view viewWithTag:i+60];
        UIButton * buttonBullet = (UIButton *)[self.view viewWithTag:10 + i];
        buttonMonster.frame = CGRectMake(1000, 0, 0, 0);
        buttonBullet.frame = CGRectMake(-100, 0, 5, 5);
    }
    
    
}






































































- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
