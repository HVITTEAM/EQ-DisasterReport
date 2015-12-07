//
//  MenuContentView.m
//  EQ_DisasterReport
//
//  Created by shi on 15/12/7.
//  Copyright © 2015年 董徐维. All rights reserved.
//

#import "MenuContentView.h"
#import "MenuItem.h"

#define lineMargin 20
#define kArrowHeight 20

@interface MenuContentView ()
@property(strong,nonatomic)NSArray *titles;
@property(strong,nonatomic)NSArray *titleIcons;
@property(strong,nonatomic)NSMutableArray *menuItems;
@property(strong,nonatomic)NSMutableArray *lines;
@end

@implementation MenuContentView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

-(instancetype)initWithTitles:(NSArray *)titles titleIcons:(NSArray *)titleIcons
{
    self = [super init];
    if (self) {
        self.titles = titles;
        self.titleIcons = titleIcons;
        [self initSubViews];
    }
    return self;
}

-(NSMutableArray *)menuItems
{
    if (!_menuItems) {
        _menuItems = [[NSMutableArray alloc] init];
    }
    return _menuItems;
}

-(NSMutableArray *)lines
{
    if (!_lines) {
        _lines = [[NSMutableArray alloc] init];
    }
    return _lines;
}

-(void)initSubViews
{
    for (int i = 0; i < self.titles.count; i++) {
        MenuItem *item = [[MenuItem alloc] initWithTitle:self.titles[i] imageName:self.titleIcons[i]];
        item.userInteractionEnabled = YES;
        item.tag = 1000+i;
        [self addSubview:item];
        [self.menuItems addObject:item];
        
        UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapMenuItem:)];
        tapGes.numberOfTapsRequired = 1;
        tapGes.numberOfTouchesRequired = 1;
        [item addGestureRecognizer:tapGes];
    }
    
    for (int i = 0; i < self.titles.count-1; i++) {
        UIView *lineView = [[UIView alloc] init];
        lineView.backgroundColor = [UIColor whiteColor];
        [self addSubview:lineView];
        [self.lines addObject:lineView];
    }
}

-(void)layoutSubviews
{
    [super layoutSubviews];

    CGFloat menuItemHeight = floor((self.size.height - kArrowHeight)/self.titles.count);
    
    for (int i = 0; i < self.titles.count; i++) {
        MenuItem *item = self.menuItems[i];
        item.frame = CGRectMake(0, kArrowHeight + i * menuItemHeight, self.size.width, menuItemHeight);
    }
    
    for (int i = 0; i < self.titles.count - 1; i++ ) {
        UIView *lineView = self.lines[i];
        lineView.frame = CGRectMake(lineMargin,kArrowHeight + menuItemHeight + i *menuItemHeight,self.size.width - 2 * lineMargin, 0.5);
    }
}

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetLineWidth(context, 2.0);
    CGContextSetFillColorWithColor(context, [UIColor colorWithRed:0.3 green:0.3 blue:0.3 alpha:1.0f].CGColor);
    
    CGFloat radius = 6.0;
    CGFloat minX = 0;
    CGFloat maxX = CGRectGetMaxX(self.bounds);
    CGFloat minY = CGRectGetMinY(self.bounds) + kArrowHeight;
    CGFloat maxY = CGRectGetMaxY(self.bounds);
    
    CGContextMoveToPoint(context, maxX - 30, minY);
    CGContextAddLineToPoint(context, maxX - 20, 0);
    CGContextAddLineToPoint(context, maxX - 10, minY);
    
    CGContextAddArcToPoint(context, minX, minY, minX, maxY, radius);
    CGContextAddArcToPoint(context, minX, maxY, maxX, maxY, radius);
    CGContextAddArcToPoint(context, maxX, maxY, maxX, minY, radius);
    CGContextAddArcToPoint(context, maxX, minY, maxX - 10, minY, radius);
    
    CGContextClosePath(context);
    
    CGContextFillPath(context);

//    self.layer.shadowColor = [[UIColor blackColor] CGColor];
//    self.layer.shadowOpacity = 1.0;
//    self.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);
}


-(void)tapMenuItem:(UITapGestureRecognizer *)recognizer
{
    MenuItem *item = (MenuItem *)[recognizer view];
    NSInteger idx = item.tag - 1000;
    if ([self.delegate respondsToSelector:@selector(menuContentView:indexForItem:)]) {
        NSLog(@"sdfsdfsdfsdfsdfsdfsdfsadf");
        [self.delegate menuContentView:self indexForItem:idx];
    }
}

@end
