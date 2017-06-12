//
//  DrawView.m
//  LineDashPhaseDemo
//
//  Created by kkk on 16/5/24.
//
//

#import "DrawView.h"

@interface DrawView ()
{
    CAShapeLayer *m_shapeLayer;
}

@end

@implementation DrawView


- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self createView];
    }
    return self;
}


- (void)createView {
    m_shapeLayer = [CAShapeLayer layer];
    //    [m_shapeLayer setBounds:self.view.bounds];
    //    [m_shapeLayer setPosition:self.view.center];
    [m_shapeLayer setFillColor:[[UIColor clearColor] CGColor]];
    // 设置虚线颜色为blackColor
    [m_shapeLayer setStrokeColor:[[UIColor greenColor] CGColor]];
    // 3.0f设置虚线的宽度
    [m_shapeLayer setLineWidth:1.0f];
    //不太懂
    [m_shapeLayer setLineJoin:kCALineJoinRound];
    
    // 3=线的宽度 1=每条线的间距
    [m_shapeLayer setLineDashPattern:[NSArray arrayWithObjects:[NSNumber numberWithInt:2],[NSNumber numberWithInt:2],nil]];
    // Setup the path
    CGMutablePathRef path = CGPathCreateMutable();
    //开始的点
    CGPathMoveToPoint(path,NULL ,0, self.frame.size.height);
    //画到第二个点的坐标
    CGPathAddLineToPoint(path, NULL, 0,0);
    //从第二个点画到第三个点的坐标
    CGPathAddLineToPoint(path, NULL, self.frame.size.width,0);
    //从第三个点画 到第四点的坐标
    CGPathAddLineToPoint(path, NULL, self.frame.size.width,self.frame.size.height);
    //从第四个点到 开始点的坐标
    CGPathAddLineToPoint(path, NULL, 0,self.frame.size.height);
    //    CGPathAddLineToPoint(path, NULL, ScreenWidth,ScreenHeight/3);
    //    CGPathAddLineToPoint(path, NULL, 0,ScreenHeight);
    
    [m_shapeLayer setPath:path];
    CGPathRelease(path);
    [self.layer addSublayer:m_shapeLayer];
}

- (void)setLineColorWith:(UIColor *)color {
    [m_shapeLayer setStrokeColor:color.CGColor];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
