//
//  ViewController.m
//  连连看
//
//  Created by ucsmy on 16/7/19.
//  Copyright © 2016年 ucsmy. All rights reserved.
//

#import "ViewController.h"
#import "LLKGameCenter.h"

#define MainWidth [UIScreen mainScreen].bounds.size.width
#define Mainheight [UIScreen mainScreen].bounds.size.height

#define TotalLevel 3

@interface ViewController()
/** 开始按钮*/
@property (nonatomic, strong) UIButton *startButton;
/** 游戏标题*/
@property (nonatomic, strong) UILabel *gameTitleLabel;
/** 当前关卡*/
@property (nonatomic, assign) NSInteger curLevel;
/** 游戏中心*/
@property (nonatomic, strong) LLKGameCenter *gameCenter;
@end

@implementation ViewController

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.curLevel = 1;
    /** 初始化游戏面板*/
    [self initGamePanel];
}
/** 初始化游戏面板*/
-(void)initGamePanel
{
    self.startButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.startButton.frame = CGRectMake(15, Mainheight / 2 - 20, MainWidth - 30, 40);
    [self.startButton setTitle:@"Start" forState:UIControlStateNormal];
    self.startButton.titleLabel.font = [UIFont systemFontOfSize:17];
    self.startButton.layer.cornerRadius = 5;
    self.startButton.backgroundColor = [UIColor orangeColor];
    [self.startButton addTarget:self action:@selector(startGameHandler) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.startButton];
    
    _gameTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, self.startButton.frame.origin.y - 61, MainWidth - 60, 21)];
    _gameTitleLabel.textColor = [UIColor orangeColor];
    _gameTitleLabel.font = [UIFont systemFontOfSize:15];
    _gameTitleLabel.text = @"-------GAME-------";
    _gameTitleLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_gameTitleLabel];
}
/** 初始化游戏数据*/
-(void)initGameData
{
    NSInteger row = 6 + (self.curLevel - 1) * 5;
    NSInteger col = 7 + (self.curLevel - 1) * 3;
    NSInteger timeValue = 40 + (self.curLevel - 1) * 8;
    if (self.gameCenter) {
        [self.gameCenter removeFromSuperview];
        self.gameCenter = nil;
    }
    __weak typeof(self)weakSelf = self;
    self.gameCenter = [[LLKGameCenter alloc] initWithFrame:self.view.bounds row:row col:col];
    self.gameCenter.timeValue = timeValue;
    self.gameCenter.gameOverBlock = ^(BOOL isSuccess)
    {
        [weakSelf handlerGameResultWithSuccess:isSuccess];
    };
    [self.view addSubview:self.gameCenter];
    
}
-(void)startGameHandler
{
    self.gameTitleLabel.hidden = YES;
    self.startButton.hidden = YES;
    
    [self initGameData];
    [self.gameCenter start];
}
-(void)handlerGameResultWithSuccess:(BOOL)isSuccess
{
    if (isSuccess) {
        if (TotalLevel == self.curLevel) {
            if (self.gameCenter) {
                [self.gameCenter removeFromSuperview];
                self.gameCenter = nil;
            }
            self.gameTitleLabel.hidden = NO;
            self.gameTitleLabel.text = @"-------你通关了-------";
            return;
        }
        self.curLevel ++;
        [self startGameHandler];
    }
    else
    {
        if (self.gameCenter) {
            [self.gameCenter removeFromSuperview];
            self.gameCenter = nil;
        }
        self.gameTitleLabel.hidden = NO;
        self.gameTitleLabel.text = @"-------你输了-------";
    }
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
