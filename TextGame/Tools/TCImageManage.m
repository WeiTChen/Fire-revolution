//
//  TCImageManage.m
//  封装方法
//
//  Created by William on 16/4/15.
//  Copyright © 2016年 William. All rights reserved.
//

#import "TCImageManage.h"

typedef void(^saveImageSuccess)(void);
typedef void(^saveImageFailure)(NSError *err);


@interface TCImageManage()
typedef enum
{
    firstImageView,
    secondImageView
    
}carouseLastImageView;
/**
 *  文件管理类
 */
@property (nonatomic,strong) NSFileManager *manage;

/**
 *  保存图片成功回调
 */
@property (nonatomic,copy) saveImageSuccess saveImageSuccessBlock;
/**
 *  保存图片失败回调
 */
@property (nonatomic,copy) saveImageFailure saveImageFailureBlock;

/**
 *  录播图第一张
 */
@property (nonatomic,strong) UIImageView *firstCarouselImg;
/**
 *  轮播图第二张
 */
@property (nonatomic,strong) UIImageView *secondCarouselImg;

/**
 *  轮播倒计时
 */
@property (nonatomic,assign) int carouseCountdown;

/**
 *  轮播图片数组
 */
@property (nonatomic,strong) NSArray *carouseImgAry;

/**
 *  记录当前轮播到哪张图了
 */
@property (nonatomic,assign) int carouseNowCount;

/**
 *  记录上次播放图片的是哪个控件
 */
@property (nonatomic,assign) int carouseLastImageV;

/**
 *  轮播图timer
 */
@property (nonatomic,strong) NSTimer *carouseTimer;

@end


@implementation TCImageManage
#pragma mark - ----------内部实现----------
#pragma mark - 懒加载
- (NSFileManager *)manage
{
    if (!_manage)
    {
        _manage = [NSFileManager defaultManager];
    }
    return _manage;
}

- (NSString *)getLibraryPath:(NSString *)imageURL
{
    NSString *libraryPath = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES).firstObject;
    libraryPath = [libraryPath stringByAppendingPathComponent:@"user"];
    if (![_manage fileExistsAtPath:libraryPath])
    {
        [_manage createDirectoryAtPath:libraryPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    [self initcache];
    
    return [libraryPath stringByAppendingPathComponent:imageURL];
}

- (UIImageView *)firstCarouselImg
{
    if (!_firstCarouselImg)
    {
        _firstCarouselImg = [[UIImageView alloc]init];
    }
    return _firstCarouselImg;
}

- (UIImageView *)secondCarouselImg
{
    if (!_secondCarouselImg)
    {
        _secondCarouselImg = [[UIImageView alloc]init];
    }
    return _secondCarouselImg;
}

#pragma mark - 下载
- (void)download:(NSString *)urlStr imageView:(UIImageView *)imageView filePath:(NSString *)filePath ellipse:(BOOL)ellipse
{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        NSData *fileData = [NSData dataWithContentsOfURL:[NSURL URLWithString:urlStr]];
        if (!fileData) {
            return;
        }
        [self.manage createFileAtPath:[self getLibraryPath:urlStr] contents:fileData attributes:nil];
        UIImage *image = [UIImage imageWithData:fileData];
        if (image)
        {
            [_cache setObject:image forKey:urlStr];
            [fileData writeToFile:filePath atomically:YES];
            //通过网络下载的文件
            UIImage *image = ellipse?[self circleImage:[UIImage imageWithData:fileData] withParam:0]:[UIImage imageWithData:fileData];
            dispatch_async(dispatch_get_main_queue(), ^{
                imageView.image = image;
                NSLog(@"网络图片赋值");
            });
        }
    });
}

- (void)download:(NSString *)urlStr button:(UIButton *)button state:(UIControlState)state filePath:(NSString *)filePath ellipse:(BOOL)ellipse
{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        NSData *fileData = [NSData dataWithContentsOfURL:[NSURL URLWithString:urlStr]];
        [self.manage createFileAtPath:[self getLibraryPath:urlStr] contents:fileData attributes:nil];
        UIImage *image = [UIImage imageWithData:fileData];
        if (image)
        {
            [_cache setObject:image forKey:urlStr];
            [fileData writeToFile:filePath atomically:YES];
            //通过网络下载的文件
            dispatch_async(dispatch_get_main_queue(), ^{
                UIImage *image = [UIImage imageWithData:fileData];
                [button setBackgroundImage:ellipse?[self circleImage:image withParam:0]:image forState:state];
            });
        }
    });
}

#pragma mark - 单例
- (void)initcache
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _cache = [[NSCache alloc]init];
    });
}

#pragma mark - ----------外部调用----------
+ (instancetype)sharedInstance
{
    static TCImageManage *manage;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manage = [[self alloc]init];
    });
    return manage;
}

- (void)imageView:(UIImageView *)imageView setImageWithURL:(NSString *)urlStr placeholder:(UIImage *)placeholder ellipse:(BOOL)ellipse
{
    if (urlStr == nil || [urlStr isKindOfClass:[NSNull class]] || urlStr.length == 0) {
        imageView.image = ellipse?[self circleImage:placeholder withParam:0]:placeholder;
        return;
    }
    NSString *str = urlStr;
    NSString *s;
    while (1) {
        NSRange range = [str rangeOfString:@"."];
        if (range.length > 0) {
            str = [str substringWithRange:NSMakeRange(range.location+1, str.length-range.location-1)];
        }else{
            s = str;
            break;
        }
    }
    if (s.length == 0) {
        return;
    }
    NSString *imageURL = [[urlStr MD5] stringByAppendingString:[NSString stringWithFormat:@".%@",s]];
    NSString *libraryPath = [self getLibraryPath:imageURL];
    if ([_cache objectForKey:urlStr])
    {
        //缓存中取出文件
        UIImage *image = [_cache objectForKey:urlStr];
        imageView.image = ellipse?[self circleImage:image withParam:0]:image;
        return;
    }
    else if ([self.manage fileExistsAtPath:libraryPath])
    {
        //内存中取出文件
        UIImage *image = [UIImage imageWithContentsOfFile:libraryPath];
        imageView.image = ellipse?[self circleImage:image withParam:0]:image;
        if ([_cache objectForKey:urlStr] != image)
        {
            [_cache setObject:image forKey:urlStr];
        }
        return;
    }
    else
    {
        imageView.image = ellipse?[self circleImage:placeholder withParam:0]:placeholder;
        [self download:urlStr imageView:imageView filePath:libraryPath ellipse:(BOOL)ellipse];
        return;
    }
}

- (void)setImageWithURLForButton:(UIButton *)button state:(UIControlState)state URL:(NSString *)urlStr backgroundImage:(BOOL)backgroundImage ellipse:(BOOL)ellipse
{
    NSString *imageURL = [urlStr stringByReplacingOccurrencesOfString:@"/" withString:@""];
    NSString *libraryPath = [self getLibraryPath:imageURL];
    if (backgroundImage)
    {
        [button setBackgroundImage:PLACEHOLDER_IMAGE forState:UIControlStateNormal];
    }
    else
    {
        [button setImage:PLACEHOLDER_IMAGE forState:UIControlStateNormal];
    }
    UIImage *image;
    if ([_cache objectForKey:urlStr])
    {
        //缓存中取出文件
        image = [_cache objectForKey:urlStr];
        [button setBackgroundImage:ellipse?[self circleImage:image withParam:0]:image forState:state];
    }
    else if ([self.manage fileExistsAtPath:libraryPath])
    {
        //内存中取出文件
        image = [UIImage imageWithContentsOfFile:libraryPath];
        if (image) {
            [button setBackgroundImage:ellipse?[self circleImage:image withParam:0]:image forState:state];
            if ([_cache objectForKey:urlStr] != image)
            {
                [_cache setObject:image forKey:urlStr];
            }
        }else{
            [self.manage removeItemAtPath:libraryPath error:nil];
        }
    }
    else
    {
        [self download:urlStr button:button state:state filePath:libraryPath ellipse:ellipse];
        return;
    }
}

- (UIImage*) circleImage:(UIImage*) image withParam:(CGFloat) inset {
    UIGraphicsBeginImageContext(image.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 2);
    CGContextSetStrokeColorWithColor(context, [UIColor clearColor].CGColor);
    CGRect rect = CGRectMake(inset, inset, image.size.width - inset * 2.0f, image.size.height - inset * 2.0f);
    CGContextAddEllipseInRect(context, rect);
    CGContextClip(context);
    [image drawInRect:rect];
    CGContextAddEllipseInRect(context, rect);
    CGContextStrokePath(context);
    UIImage *newimg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newimg;
}

//截屏
- (UIImage *)screenshot:(UIView *)view NeedSave:(BOOL)isNeed success:(void (^)(void))success failure:(void (^)(NSError *))failure
{
    _saveImageSuccessBlock = success;
    _saveImageFailureBlock = failure;
    UIGraphicsBeginImageContext(view.bounds.size);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *viewImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    if (isNeed)
    {
        UIImageWriteToSavedPhotosAlbum(viewImg, self, @selector(didFinishSaveImage:Error:contextInfo:), nil);
    }
    return viewImg;
}

- (UIImage *)screenshot:(UIView *)view WithFrame:(CGRect)frame NeedSave:(BOOL)isNeed success:(void (^)(void))success failure:(void (^)(NSError *))failure
{
    _saveImageSuccessBlock = success;
    _saveImageFailureBlock = failure;
    UIGraphicsBeginImageContext(view.frame.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
//    CGContextSaveGState(context);
    UIRectClip(frame);
    [view.layer renderInContext:context];
    UIImage *viewImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    if (isNeed)
    {
        UIImageWriteToSavedPhotosAlbum(viewImg, self, @selector(didFinishSaveImage:Error:contextInfo:), nil);
    }
    return  viewImg;
}

- (void)createCarouselWithScrollView:(UIScrollView *)scrollView ImageArray:(NSArray *)imgAry interval:(int)interval URLArray:(NSArray *)urlArray
{
    if (urlArray.count > 0)
    {
       [self downloadURLImageAry:urlArray];
    }
    CGRect frame = scrollView.frame;
    self.firstCarouselImg.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
    [scrollView addSubview:self.firstCarouselImg];
    self.secondCarouselImg.frame = CGRectMake(frame.size.width, 0, frame.size.width, frame.size.height);
    [scrollView addSubview:self.secondCarouselImg];
    _carouseCountdown = interval;
    self.carouseLastImageV = firstImageView;
    self.carouseNowCount = 2;
    _carouseImgAry = imgAry;
    self.firstCarouselImg.image = _carouseImgAry.firstObject;
    self.secondCarouselImg.image = _carouseImgAry[1];
    [self carouseStart];
    
}

- (void)downloadURLImageAry:(NSArray *)imageURLAry
{
    dispatch_queue_t imageQueue = dispatch_queue_create(0, 0);
    NSMutableArray *imageAry = [NSMutableArray array];
    __block int count = 0;
    for (int i = 0; i < imageURLAry.count; i++)
    {
        dispatch_async(imageQueue, ^{
            NSString *imageURL = imageURLAry[i];
            UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imageURL]]];
            [imageAry addObject:image];
            count++;
            if (count == imageURLAry.count)
            {
                _carouseImgAry = imageAry;
            }
        });
    }
    
    
}

//轮播内部处理逻辑
- (void)carouseRun
{
    __block CGRect firstFrame = self.firstCarouselImg.frame;
    __block CGRect secondFrame = self.secondCarouselImg.frame;
    //如果越界,重置为0
    if (self.carouseNowCount > self.carouseImgAry.count-1)
    {
        self.carouseNowCount = 0;
    }
    firstFrame.origin.x -= firstFrame.size.width;
    secondFrame.origin.x -= secondFrame.size.width;
    [UIView animateWithDuration:0.3 animations:^{
        self.firstCarouselImg.frame = firstFrame;
        self.secondCarouselImg.frame = secondFrame;
        
    } completion:^(BOOL finished) {
        if (self.carouseLastImageV == firstImageView)
        {
            firstFrame.origin.x = firstFrame.size.width;
            self.firstCarouselImg.frame = firstFrame;
            self.carouseLastImageV = secondImageView;
            self.firstCarouselImg.image = self.carouseImgAry[_carouseNowCount];
        }
        else
        {
            secondFrame.origin.x = secondFrame.size.width;
            self.secondCarouselImg.frame = secondFrame;
            self.carouseLastImageV = firstImageView;
            self.secondCarouselImg.image = self.carouseImgAry[_carouseNowCount];
        }
        self.carouseNowCount++;
    }];

}

- (void)carouseStart
{
    self.carouseTimer = [NSTimer scheduledTimerWithTimeInterval:self.carouseCountdown target:self selector:@selector(carouseRun) userInfo:nil repeats:YES];
}

- (void)carouseStop
{
    [self.carouseTimer invalidate];
}

- (void)dealloc
{
    [self.carouseTimer invalidate];
}

+ (UIImage *)createImageWithColor:(UIColor *)color imageSize:(CGSize)size{
    CGRect rect=CGRectMake(0.0f, 0.0f, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

#pragma mark - 保存图片回调
- (void)didFinishSaveImage:(UIImage *)image Error:(NSError *)error contextInfo:(void *)contextInfo
{
    if (!error)
    {
        if (_saveImageSuccessBlock)
        {
            _saveImageSuccessBlock();
            _saveImageSuccessBlock = nil;
            _saveImageFailureBlock = nil;
        }
    }
    else
    {
        if (_saveImageFailureBlock)
        {
            _saveImageFailureBlock(error);
            _saveImageSuccessBlock = nil;
            _saveImageFailureBlock = nil;
        }
    }
}


@end
