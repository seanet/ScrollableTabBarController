//
//  ZQHTabBarController.m
//  pageDemo
//
//  Created by lmwl123 on 12/10/14.
//  Copyright (c) 2014 zhaoqihao. All rights reserved.
//

#import "ZQHTabBarController.h"
#import <objc/runtime.h>

#define LAYER_TITLE_IDENTIFIER @"layerTitleIdentifier"
#define LAYER_TITLECOLOR_IDENTIFIER @"layerTitleColorIdentifier"
#define LAYER_IMAGE_IDENTIFIER @"layerImageIdentifier"

@interface ZQHTabBarItem()

@property (assign,nonatomic) CGFloat ratio;

@property (weak,nonatomic) id layerDelegate;

@property (strong,nonatomic) NSString *selectorName;
@property (weak,nonatomic) id clickDelegate;

@end

@interface ZQHTabBarController(){
    int willTransitionPage;
    int beginDragPage;
}

@property (weak,nonatomic)UIScrollView *scrollView;
@property (weak,nonatomic)UIView *tabBar;
@property (weak,nonatomic)UIWindow *window;

@end

@implementation ZQHTabBarController

@synthesize tabBarItems=_tabBarItems,controllers=_controllers;
@synthesize scrollView=_scrollView,tabBar=_tabBar,separateLine=_separateLine;
@synthesize navigationBarHidden=_navigationBarHidden;

#pragma mark - View lifecycle

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    self.view.backgroundColor=[UIColor whiteColor];
    self.navigationBarHidden=_navigationBarHidden;
    [self setEdgesForExtendedLayout:UIRectEdgeNone];
    
    if(!self.controllers) return;
    
    self.delegate = self;
    self.dataSource = self;
    
    _scrollView=[self.view.subviews objectAtIndex:0];
    [_scrollView setDelegate:self];
    
    [self prepareConstraints];
    [self prepareTabBarItems];
    
    UIViewController *vc=[_controllers objectAtIndex:0];
    self.view.backgroundColor=vc.view.backgroundColor;
    
    [self setViewControllers:[NSArray arrayWithObjects:[_controllers objectAtIndex:0], nil] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
}

-(void)prepareConstraints{
    _window=[[UIApplication sharedApplication]keyWindow];
    
    UIView *c=[_window.subviews objectAtIndex:0];
    
    [c setTranslatesAutoresizingMaskIntoConstraints:NO];
    [_window addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[c]-49-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(c)]];
    [_window addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[c]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(c)]];
    
    UIView *t=[[UIView alloc]init];
    [_window addSubview:t];
    _tabBar=t;
    
    [_tabBar setTranslatesAutoresizingMaskIntoConstraints:NO];
    [_window addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_tabBar(==49)]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_tabBar)]];
    [_window addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_tabBar]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_tabBar)]];
    
    [_tabBar setUserInteractionEnabled:YES];
    [_tabBar setBackgroundColor:ZQHTBC_TABBAR_BACKGROUNDCOLOR];
    
    UIView *s=[[UIView alloc]init];
    [_tabBar addSubview:s];
    _separateLine=s;
    
    [_separateLine setTranslatesAutoresizingMaskIntoConstraints:NO];
    [_tabBar addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_separateLine(==0.3)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_separateLine)]];
    [_tabBar addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_separateLine]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_separateLine,_tabBar)]];
    
    [_separateLine setBackgroundColor:[UIColor lightGrayColor]];
}

-(void)prepareTabBarItems{
    if(_tabBarItems.count==0) return;
    
    NSMutableArray *mItems=[NSMutableArray arrayWithArray:_tabBarItems];
    for(id obj in mItems)
        if(![obj isKindOfClass:[ZQHTabBarItem class]]) [mItems removeObject:obj];
    if(_tabBarItems.count!=mItems.count){
        if(mItems.count==0) return;
        _tabBarItems=[NSArray arrayWithArray:mItems];
    }
    
    int c=(int)_tabBarItems.count;
    CGFloat coordinateX=0;
    
    for(int i=0;i<c;i++){
        ZQHTabBarItem *item=[_tabBarItems objectAtIndex:i];
        if(i==0) item.ratio=1;
        [item setFrame:CGRectMake(coordinateX, 0, [UIScreen mainScreen].bounds.size.width/c, 49)];
        [item setLayerDelegate:self];
        [item setClickDelegate:self];
        [item setSelectorName:@"itemClick:"];
        [item setTag:i];
        [_tabBar addSubview:item];
        
        coordinateX+=[UIScreen mainScreen].bounds.size.width/c;
    }
}

-(void)itemClick:(NSNumber *)number{
    int index=[number intValue];
    ZQHTabBarItem *chosen=[_tabBarItems objectAtIndex:index];
    for(ZQHTabBarItem *item in _tabBarItems){
        if(item==chosen) item.ratio=1;
        else item.ratio=0;
    }
    
    if(index>=_controllers.count) return;
    UIViewController *vc=[_controllers objectAtIndex:index];
    [self setViewControllers:[NSArray arrayWithObjects:vc, nil] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    self.view.backgroundColor=vc.view.backgroundColor;
    
    beginDragPage=index;
    willTransitionPage=index;
}

-(void)setNavigationBarHidden:(BOOL)navigationBarHidden{
    _navigationBarHidden=navigationBarHidden;
    [self.navigationController setNavigationBarHidden:navigationBarHidden];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController
       viewControllerAfterViewController:(UIViewController *)viewController{
    NSInteger count=[_controllers count];
    NSInteger index=[_controllers indexOfObject:viewController];
    if(index>=count-1)
        return nil;
    return [_controllers objectAtIndex:index+1];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController
      viewControllerBeforeViewController:(UIViewController *)viewController{
    NSInteger index=[_controllers indexOfObject:viewController];
    if(index<=0)
        return nil;
    return [_controllers objectAtIndex:index-1];
}

- (UIPageViewControllerSpineLocation)pageViewController:(UIPageViewController *)pageViewController spineLocationForInterfaceOrientation:(UIInterfaceOrientation)orientation{
    return UIPageViewControllerSpineLocationMin;
}

-(void)pageViewController:(UIPageViewController *)pageViewController willTransitionToViewControllers:(NSArray *)pendingViewControllers{
    UIViewController *pendingVC=[pendingViewControllers objectAtIndex:0];
    willTransitionPage=(int)[_controllers indexOfObject:pendingVC];
    self.view.backgroundColor=pendingVC.view.backgroundColor;
}

-(void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed{
    if(!completed){
        UIViewController *previousVC=[previousViewControllers objectAtIndex:0];
        self.view.backgroundColor=previousVC.view.backgroundColor;
        return;
    }
    beginDragPage=willTransitionPage;
}

-(void)drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx{
    UIImage *image=(UIImage *)objc_getAssociatedObject(layer, (__bridge const void *)LAYER_IMAGE_IDENTIFIER);
    NSString *title=(NSString *)objc_getAssociatedObject(layer, (__bridge const void *)LAYER_TITLE_IDENTIFIER);
    UIColor *titleColor=(UIColor *)objc_getAssociatedObject(layer, (__bridge const void *)LAYER_TITLECOLOR_IDENTIFIER);
    
    NSDictionary *attrs=[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:12],NSFontAttributeName,titleColor,NSForegroundColorAttributeName, nil];
    CGRect r=[title boundingRectWithSize:CGSizeMake(layer.bounds.size.width-10, layer.bounds.size.height-ZQHTBC_TABBAR_IMAGESIZE) options:NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil];
    
    UIGraphicsPushContext(ctx);
    [image drawInRect:CGRectMake((layer.bounds.size.width-ZQHTBC_TABBAR_IMAGESIZE)/2, 3, ZQHTBC_TABBAR_IMAGESIZE, ZQHTBC_TABBAR_IMAGESIZE)];
    [title drawInRect:CGRectMake((layer.bounds.size.width-r.size.width)/2, ZQHTBC_TABBAR_IMAGESIZE+2, r.size.width, r.size.height) withAttributes:attrs];
    UIGraphicsPopContext();
}

#pragma mark - uiscrollview delegate

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat r=scrollView.contentOffset.x/[UIScreen mainScreen].bounds.size.width-1;
    if(fabsf(r)>1||r==0||beginDragPage==willTransitionPage) return;
    if(willTransitionPage==_tabBarItems.count||beginDragPage==_tabBarItems.count) return;
    
    r=fabs(r);
    
    ZQHTabBarItem *fromItem=[_tabBarItems objectAtIndex:beginDragPage];
    ZQHTabBarItem *toItem=[_tabBarItems objectAtIndex:willTransitionPage];
    
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    
    fromItem.ratio=1-r;
    toItem.ratio=r;
    
    [CATransaction commit];
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    for(int i=0;i<_tabBarItems.count;i++){
        ZQHTabBarItem *item=[_tabBarItems objectAtIndex:i];
        if(i==beginDragPage) item.ratio=1;
        else item.ratio=0;
    }
}

@end

@interface ZQHTabBarItem()

@property (strong,nonatomic) NSString *title;
@property (strong,nonatomic) UIColor *titleColorNormal;
@property (strong,nonatomic) UIColor *titleColorSelected;

@property (strong,nonatomic) UIImage *imageNormal;
@property (strong,nonatomic) UIImage *imageSelected;

@property (weak,nonatomic,readonly) CALayer *normalLayer;
@property (weak,nonatomic,readonly) CALayer *selectedLayer;

@end

@implementation ZQHTabBarItem

@synthesize title=_title,titleColorNormal=_titleColorNormal,titleColorSelected=_titleColorSelected;
@synthesize imageNormal=_imageNormal,imageSelected=_imageSelected;
@synthesize layerDelegate=_layerDelegate,clickDelegate=_clickDelegate,selectorName=_selectorName;
@synthesize normalLayer=_normalLayer,selectedLayer=_selectedLayer;
@synthesize ratio=_ratio;

-(id)initWithTitle:(NSString *)title titleNormalColor:(UIColor *)normalColor titleSelectedColor:(UIColor *)selectedColor imageNormal:(UIImage *)imageNormal imageSelected:(UIImage *)imageSelected{
    self=[super init];
    if(self){
        _title=title;
        _titleColorNormal=normalColor;
        _titleColorSelected=selectedColor;
        
        _imageNormal=imageNormal;
        _imageSelected=imageSelected;
        
        [self prepare];
    }
    
    return self;
}

-(void)prepare{
    [self setBackgroundColor:[UIColor clearColor]];
    
    CALayer *l=[[CALayer alloc]init];
    [self.layer addSublayer:l];
    _normalLayer=l;
    [_normalLayer setBounds:self.bounds];
    [_normalLayer setPosition:CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2)];
    [_normalLayer setContentsScale:[[UIScreen mainScreen] scale]];
    [_normalLayer setBackgroundColor:[[UIColor clearColor] CGColor]];
    objc_setAssociatedObject(_normalLayer, (__bridge const void *)LAYER_TITLE_IDENTIFIER, _title, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(_normalLayer, (__bridge const void *)LAYER_TITLECOLOR_IDENTIFIER, _titleColorNormal, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(_normalLayer, (__bridge const void *)LAYER_IMAGE_IDENTIFIER, _imageNormal, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    l=[[CALayer alloc]init];
    [self.layer addSublayer:l];
    _selectedLayer=l;
    _selectedLayer.opacity=0;
    [_selectedLayer setBounds:self.bounds];
    [_selectedLayer setPosition:CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2)];
    [_selectedLayer setContentsScale:[[UIScreen mainScreen] scale]];
    [_selectedLayer setBackgroundColor:[[UIColor clearColor] CGColor]];
    objc_setAssociatedObject(_selectedLayer, (__bridge const void *)LAYER_TITLE_IDENTIFIER, _title, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(_selectedLayer, (__bridge const void *)LAYER_TITLECOLOR_IDENTIFIER, _titleColorSelected, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(_selectedLayer, (__bridge const void *)LAYER_IMAGE_IDENTIFIER, _imageSelected, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(currentTag)];
    [tap setNumberOfTapsRequired:1];
    [tap setNumberOfTouchesRequired:1];
    [self addGestureRecognizer:tap];
}

-(void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    
    [_normalLayer setBounds:self.bounds];
    [_normalLayer setPosition:CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2)];
    
    [_selectedLayer setBounds:self.bounds];
    [_selectedLayer setPosition:CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2)];
}

-(void)setLayerDelegate:(id)layerDelegate{
    _layerDelegate=layerDelegate;
    
    [_normalLayer setDelegate:layerDelegate];
    [_normalLayer setNeedsDisplay];
    
    [_selectedLayer setDelegate:layerDelegate];
    [_selectedLayer setNeedsDisplay];
}

-(void)setRatio:(CGFloat)ratio{
    if(ratio>1||ratio<0) return;
    self.normalLayer.opacity=1-ratio;
    self.selectedLayer.opacity=ratio;
}

-(void)currentTag{
    if(!_selectorName||!_clickDelegate) return;
    
    SEL seletor=NSSelectorFromString(_selectorName);
    
    NSMethodSignature *sig=[[_clickDelegate class]instanceMethodSignatureForSelector:seletor];
    NSInvocation *invocation=[NSInvocation invocationWithMethodSignature:sig];
    [invocation setTarget:_clickDelegate];
    NSNumber *n=[NSNumber numberWithInteger:self.tag];
    [invocation setArgument:&n atIndex:2];
    [invocation setSelector:seletor];
    [invocation retainArguments];
    
    [invocation invoke];
}

@end
