//
//  AsyncImageView.h
//

#import <UIKit/UIKit.h>

#import "ASIHTTPRequest.h"

@interface AsyncImageView : UIImageView<ASIHTTPRequestDelegate> {
    UIActivityIndicatorView *loadingImage_;
    ASIHTTPRequest *request_;
    
    NSString *imageSlug_;
    NSString *tmpDirectory_;
}

//
@property(retain, nonatomic) UIActivityIndicatorView *loadingImage;
@property(retain, nonatomic) ASIHTTPRequest *request;
@property(retain, nonatomic) NSString *tmpDirectory;
@property(retain, nonatomic) NSString *imageSlug;

//Public Methods
-(void)loadImageFromURL:(NSString *)url withSlug:(NSString *)slug;

@end
