//
//  Menu.m
//  LWAsyncDisplayViewDemo
//
//  Created by 刘微 on 16/4/24.
//  Copyright © 2016年 WayneInc. All rights reserved.
//

#import "Menu.h"

#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
#define SCREEN_BOUNDS [UIScreen mainScreen].bounds
#define RGB(A,B,C,D) [UIColor colorWithRed:A/255.0f green:B/255.0f blue:C/255.0f alpha:D]

@interface Menu ()

@property (nonatomic,assign) BOOL show;

@end

@implementation Menu

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.clipsToBounds = YES;
        self.show = NO;
        self.backgroundColor = [UIColor clearColor];
        [self addSubview:self.likeButton];
        [self addSubview:self.commentButton];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self setNeedsDisplay];
    self.likeButton.frame = CGRectMake(0, 0, 60, self.bounds.size.height);
    self.commentButton.frame = CGRectMake(60, 0, 60, self.bounds.size.height);
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    UIBezierPath* beizerPath = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:5.0f];
    [RGB(76, 81, 84, 0.95) setFill];
    [beizerPath fill];
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextMoveToPoint(context, rect.size.width/2, 5.0f);
    CGContextAddLineToPoint(context, rect.size.width/2, rect.size.height - 5.0f);
    CGContextSetLineWidth(context, 1.0f);
    CGContextSetStrokeColorWithColor(context, [UIColor grayColor].CGColor);
    CGContextStrokePath(context);
}

- (void)clickedMenu {
    if (self.show) {
        [self menuHide];
    }
    else {
        [self menuShow];
    }
    
}

- (void)menuShow {
    [UIView animateWithDuration:0.2f
                          delay:0.0f
         usingSpringWithDamping:0.7
          initialSpringVelocity:0.0f
                        options:0 animations:^{
                            self.frame = CGRectMake(self.frame.origin.x - 120.0f,
                                                    self.frame.origin.y,
                                                    120.0f,
                                                    34.0f);
                        } completion:^(BOOL finished) {
                            self.show = YES;
                        }];
    
}

- (void)menuHide {
    [UIView animateWithDuration:0.3f
                          delay:0.0f
         usingSpringWithDamping:0.7
          initialSpringVelocity:0.0f
                        options:0 animations:^{
                            self.frame = CGRectMake(self.frame.origin.x + 120.0f,
                                                    self.frame.origin.y,
                                                    0.0f,
                                                    34.0f);
                        } completion:^(BOOL finished) {
                            self.show = NO;
                        }];
}

- (UIButton *)likeButton {
    if (_likeButton) {
        return _likeButton;
    }
    _likeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_likeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_likeButton setTitle:@"赞" forState:UIControlStateNormal];
    [_likeButton.titleLabel setFont:[UIFont systemFontOfSize:12]];
    return _likeButton;
}

- (UIButton *)commentButton {
    if (_commentButton) {
        return _commentButton;
    }
    
    _commentButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_commentButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_commentButton setTitle:@"评论" forState:UIControlStateNormal];
    [_commentButton.titleLabel setFont:[UIFont systemFontOfSize:12]];
    return _commentButton;
}
@end
