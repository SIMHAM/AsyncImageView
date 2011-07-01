//
//  AsyncImageView.m
//  Smorgie
//
//  Created by Frankie Laguna on 6/30/11.
//  Copyright 2011 The Atom Group. All rights reserved.
//

#import "AsyncImageView.h"
#import "RequestHelper.h"

@implementation AsyncImageView
@synthesize loadingImage = loadingImage_;
@synthesize request = request_;
@synthesize tmpDirectory = tmpDirectory_;
@synthesize imageSlug = imageSlug_;

#pragma mark -
#pragma mark Init/Dealloc
- (void)dealloc {
    self.loadingImage = nil;
    [loadingImage_ release];
    
    //Make sure to cancel any requests in progress
    //Setting the delegate to nil so if the request does finish, it won't break the app
    [self.request cancel];
    [self.request setDelegate:nil];
    
    self.request = nil;
    [request_ release];
        
    self.tmpDirectory = nil;
    [tmpDirectory_ release];
    
    self.imageSlug = nil;
    [imageSlug_ release];
    
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {        
        //Add the loading spinner and center it in the UIImageView
        self.loadingImage = [[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray] autorelease];
        
        CGRect newFrame = CGRectMake(0, 0, frame.size.width, frame.size.height);
        
        [self.loadingImage setContentMode:UIViewContentModeCenter];
        [self.loadingImage setFrame:newFrame];
        [self.loadingImage startAnimating];
        [self addSubview:self.loadingImage];
    }
    
    return self;
}

-(void)setImage:(UIImage *)newImage{
    [super setImage:newImage];
    
    [self.loadingImage stopAnimating];
    [self.loadingImage removeFromSuperview];
}

-(void)setFailedImage{
    //TODO: Have a default failed image.
    
    [self.loadingImage stopAnimating];
    [self.loadingImage removeFromSuperview];
    
    self.image = nil;
}

-(UIImage *)getCachedImageWithSlug:(NSString *)slug{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if(![fileManager fileExistsAtPath:self.tmpDirectory]){        
        return nil;
    }
    
    NSData *fileData = [fileManager contentsAtPath:self.tmpDirectory];
    
    return [UIImage imageWithData:fileData];
}

-(void)loadImageFromURL:(NSString *)url withSlug:(NSString *)slug{
    if(url == nil){
        [self setFailedImage];
        
        return;
    }
    
    UIImage *cachedImage = [self getCachedImageWithSlug:slug];
    
    if(cachedImage != nil){
        self.image = cachedImage;
        
        return;
    }
    
    self.imageSlug = slug;
    self.tmpDirectory = [NSString stringWithFormat:@"%@%@.jpg", NSTemporaryDirectory(), slug];
    
    RequestHelper *helper = [[RequestHelper alloc] init];
    
    self.request = [helper imageDownloadRequestWithURL:url];
    [self.request setDelegate:self];
    [self.request setDownloadDestinationPath:self.tmpDirectory];
    [self.request startAsynchronous];
    
    [helper release];
}

#pragma mark -
#pragma mark ASIHTTPRequestDelegate
-(void)requestStarted:(ASIHTTPRequest *)req{
    //NSLog(@"Making req");
}

-(void)requestFailed:(ASIHTTPRequest *)req{
    NSLog(@"Failed %@", [req error]);
    
    [self setFailedImage];
}

-(void)requestFinished:(ASIHTTPRequest *)req{
    //NSLog(@"Finished");
    
    self.image = [self getCachedImageWithSlug:self.imageSlug];
}

@end
