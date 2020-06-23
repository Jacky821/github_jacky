//
//  LLKGameCenter.m
//  连连看
//
//  Created by ucsmy on 16/7/20.
//  Copyright © 2016年 ucsmy. All rights reserved.
//

#import "LLKGameCenter.h"
#import "LLKElement.h"
#import "LLKalgorithmClass.h"

#define MainWidth [UIScreen mainScreen].bounds.size.width
#define Mainheight [UIScreen mainScreen].bounds.size.height
/** 元素类型数量*/
#define ElementTypeNum 6
/** 边距*/
#define Padding 15

@interface LLKGameCenter()

/** 地图数据*/
@property (nonatomic, strong) NSMutableArray *mapList;
/** 元素存储字典*/
@property (nonatomic, strong) NSMutableDictionary *elementDic;
/** 元素宽高*/
@property (nonatomic, assign) NSInteger elementWH;
/** 上边距*/
@property (nonatomic, assign) NSInteger topPadding;
/** 当前点击的元素*/
@property (nonatomic, assign) LLKElement *curElement;
/** 之前点击过的元素*/
@property (nonatomic, assign) LLKElement *oldElement;
/** 地图行数*/
@property (nonatomic, assign) NSInteger mapRow;
/** 地图列数*/
@property (nonatomic, assign) NSInteger mapCol;
/** 时间进度条*/
@property (nonatomic, strong) UIView *timeProgress;
@end

@implementation LLKGameCenter

-(instancetype)initWithFrame:(CGRect)frame row:(NSInteger)row col:(NSInteger)col
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.mapCol = col;
        self.mapRow = row;
        //元素宽高
        self.elementWH = (MainWidth - Padding * 2) / self.mapCol;
        self.topPadding = (Mainheight - self.mapCol * self.elementWH) * 0.5;
        self.topPadding = self.topPadding > 0 ? self.topPadding : 15;
        //创建时间进度条
        self.timeProgress = [[UIView alloc] initWithFrame:CGRectMake(15, 50, MainWidth - 30, 20)];
        self.timeProgress.backgroundColor = [UIColor orangeColor];
        [self addSubview:self.timeProgress];
        
        //生成地图数据
        [self createMapData];
        //创建连连看元素
        [self createElement];
    }
    return self;
}
#pragma mark - private

/** 生成地图数据 */
- (void)createMapData{
    for (int i = 0; i < self.mapRow; i++) {
        NSMutableArray *subList = [NSMutableArray array];
        for (int j = 0; j < self.mapCol; j++) {
            //外围辅0
            if (i == 0 || j == 0 || i == self.mapRow - 1 || j == self.mapCol - 1) {
                [subList addObject:@0];
            }
            //内围随机
            else{
                NSInteger value = random() % (ElementTypeNum + 1);
                [subList addObject:[NSNumber numberWithInteger:value]];
            }
        }
        [self.mapList addObject:subList];
    }
    ///数据图
    /////0000000000000/////
    /////0273672362530/////
    /////0565455354350/////
    /////0354565346350/////
    /////0544343452520/////
    /////0000000000000/////
}

/** 创建连连看元素*/
- (void)createElement{
    for (int i = 0; i < self.mapList.count; i++) {//遍历数据图
        NSMutableArray *subList = self.mapList[i];
        for (int j = 0; j < subList.count; j++) {
            NSInteger type = [subList[j] integerValue];
            if (i == 0 || j == 0 || i == self.mapRow - 1 || j == self.mapCol - 1 || type == 0) {
                continue;//过滤掉0，0代表无图片
            }
            
            //生成元素
            float elementX = (j % self.mapCol) * self.elementWH + Padding;
            float elementY = (i % self.mapRow) * self.elementWH + self.topPadding;
            __weak typeof(self) weakSelf = self;
            LLKElement *element = [[LLKElement alloc] initWithFrame:CGRectMake(elementX, elementY, self.elementWH, self.elementWH) clickedBlock:^(UIButton *button) {
                /*
                LLKElement *clickElement = (LLKElement *)button;
                if (weakSelf.curElement) {
                    if (weakSelf.curElement.row == clickElement.row && weakSelf.curElement.col == clickElement.col && weakSelf.curElement.type == clickElement.type) {
                        //如果行列类型全相等 则表示用户点了两次该按钮
                        return;
                    }
                    weakSelf.oldElement = weakSelf.curElement;
                }
                weakSelf.curElement = clickElement;
                [weakSelf checkElementConnection];*/
            }];
            //赋值坐标给元素
            element.row = i;
            element.col = j;
            element.type = type;
            [self.elementDic setValue:[NSNumber numberWithInteger:type] forKey:[NSString stringWithFormat:@"%d%d", i,j]];
            [self addSubview:element];
        }
    }
}
//0：无元素占据，所以要过滤掉
//按数据图给的数据生成元素，并把坐标和类型赋值给元素
//以坐标为key，元素为value 存到元素字典
//元素的点击事件可以先不看，以免影响理解

/** 检测两个元素之间的联系*/
-(void)checkElementConnection
{
    if (!self.curElement || !self.oldElement) {
        return;
    }
    if (self.curElement.type != self.oldElement.type) {
        return;
    }
    BOOL flag = [LLKalgorithmClass connectionWithCGPoint:CGPointMake(self.curElement.row, self.curElement.col) pointB:CGPointMake(self.oldElement.row, self.oldElement.col) data:self.mapList];
    NSLog(@"x == %ld, y == %ld, x1 == %ld, y1 == %ld", self.curElement.row, self.curElement.col, self.oldElement.row, self.oldElement.col);
    NSLog(@"是否能连===%d", flag);
    if (flag) {
        /** 播放消失动画*/
        [self dismissAnimation];
        /** 数据操作*/
        [self removeElementConnection];
        /** 检测游戏是否结束*/
        BOOL isOver = [self checkGameIsOver];
        if (isOver) {
            self.gameOverBlock(YES);
        }
    }
}
-(void)dismissAnimation
{
    LLKElement *elementA = [[LLKElement alloc] initWithFrame:CGRectMake(self.curElement.frame.origin.x, self.curElement.frame.origin.y, self.curElement.frame.size.width, self.curElement.frame.size.height) clickedBlock:nil];
    elementA.type = self.curElement.type;
    LLKElement *elementB = [[LLKElement alloc] initWithFrame:CGRectMake(self.oldElement.frame.origin.x, self.oldElement.frame.origin.y, self.oldElement.frame.size.width, self.curElement.frame.size.height) clickedBlock:nil];
    elementA.type = self.oldElement.type;
    UILabel *label =  [[UILabel alloc] initWithFrame:CGRectMake(self.curElement.frame.origin.x, self.curElement.frame.origin.y, self.curElement.frame.size.width, self.curElement.frame.size.height)];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = @"+10";
    CGRect r = label.frame;
    r.origin.y = r.origin.y - 50;
    [self addSubview:label];
    [self addSubview:elementA];
    [self addSubview:elementB];
    [UIView animateWithDuration:0.7 animations:^{
        elementA.alpha = 0;
        elementB.alpha = 0;
        label.alpha = 0;
        label.frame = r;
    } completion:^(BOOL finished) {
        [elementA removeFromSuperview];
        [elementB removeFromSuperview];
        [label removeFromSuperview];
    }];
}
-(void)removeElementConnection
{
    NSMutableArray *list = self.mapList[self.curElement.row];
    list[self.curElement.col] = @0;
    
    list = self.mapList[self.oldElement.row];
    list[self.oldElement.col] = @0;
    if (self.curElement) {
        [self.curElement removeFromSuperview];
        self.curElement = nil;
    }
    if (self.oldElement) {
        [self.oldElement removeFromSuperview];
        self.oldElement = nil;
    }
}
-(void)setTimeValue:(NSInteger)timeValue
{
    if (timeValue <= 0) {
        return;
    }
    _timeValue = timeValue;
}
/** 开始游戏*/
-(void)start
{
    if (self.timeValue > 0) {
        CGRect r = self.timeProgress.frame;
        r.size.width = 0;
        __weak typeof(self)weakSelf = self;
        [UIView animateWithDuration:self.timeValue animations:^{
            weakSelf.timeProgress.frame = r;
        } completion:^(BOOL finished) {
            if (weakSelf.gameOverBlock) {
                weakSelf.gameOverBlock(NO);
            }
        }];
    }
}
/** 游戏是否结束*/
-(BOOL)checkGameIsOver
{
    for (NSInteger i = 0; i < self.mapList.count; i++) {
        NSArray *list = self.mapList[i];
        for (NSInteger j = 0; j < list.count; j++) {
            NSNumber *number = list[j];
            if ([number integerValue] != 0) {
                for (NSInteger q = 0; q < self.mapList.count; q++) {
                    NSArray *array = self.mapList[q];
                    for (NSInteger k = 0; k < array.count; k++) {
                        NSNumber *number1 = array[k];
                        NSInteger type1 = [[self.elementDic valueForKey:[NSString stringWithFormat:@"%ld%ld", i,j]] integerValue];
                        NSInteger type2 = [[self.elementDic valueForKey:[NSString stringWithFormat:@"%ld%ld", q, k]] integerValue];
                        if ([number1 integerValue] != 0 && !(i == q && j == k) && type1 == type2) {
                            BOOL flag = [LLKalgorithmClass connectionWithCGPoint:CGPointMake(i, j) pointB:CGPointMake(q, k) data:self.mapList];
                            if (flag) {
                                return NO;
                            }
                        }
                    }
                }
            }
        }
    }
    return YES;
}
#pragma mark - delegate
#pragma mark - getters and setters
-(NSMutableArray *)mapList
{
    if (_mapList == nil) {
        _mapList = [NSMutableArray array];
    }
    return _mapList;
}
-(NSMutableDictionary *)elementDic
{
    if (_elementDic == nil) {
        _elementDic = [NSMutableDictionary dictionary];
    }
    return _elementDic;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
