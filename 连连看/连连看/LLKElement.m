//
//  LLKImageView.m
//  连连看
//
//  Created by ucsmy on 16/7/19.
//  Copyright © 2016年 ucsmy. All rights reserved.
//

#import "LLKElement.h"

@interface LLKElement()

@end

@implementation LLKElement

-(instancetype)initWithFrame:(CGRect)frame clickedBlock:(ClickedBlock)clickedBlock
{
    self = [super initWithFrame:frame];
    if (self) {
        self.clickedBlock = clickedBlock;
        self.layer.cornerRadius = 5;
        self.layer.borderWidth = 1;
        self.layer.borderColor = [UIColor blackColor].CGColor;
        [self addTarget:self action:@selector(clickHandler:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}
/** 点击处理*/
-(void)clickHandler:(UIButton *)btn
{
    if (self.clickedBlock) {
        self.clickedBlock(btn);
    }
}
-(void)setType:(NSInteger)type
{
    _type = type;
    /** 给元素底色 或者 图片 根据type来*/
    switch (type) {
        case 0:
            self.backgroundColor = [UIColor whiteColor];
            break;
        case 1:
            self.backgroundColor = [UIColor redColor];
            break;
        case 2:
            self.backgroundColor = [UIColor orangeColor];
            break;
        case 3:
            self.backgroundColor = [UIColor greenColor];
            break;
        case 4:
            self.backgroundColor = [UIColor grayColor];
            break;
        case 5:
            self.backgroundColor = [UIColor blackColor];
            break;
        case 6:
            self.backgroundColor = [UIColor cyanColor];
            break;
    }
}
@end
