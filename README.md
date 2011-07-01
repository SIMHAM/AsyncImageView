Use like a regular UIImageView, and run loadImageFromURL: withSlug: to load the image.
--------------------------------------------------------------------------------------
	
``` obj-c
	NSString *imageURL = @"http://kttns.org/tacos";
	
	CGRect imageFrame = CGRectMake(0, 0, 100.0f, 100.0f);
	UIImageView *image = [UIImageView alloc] initWithFrame:imageFrame];
	[image loadImageFromURL:imageURL withSlug:@"unique_id"];
	[image release]; //Probably won't want to do this. :p
```