//
//  VideoViewController.h
//  SamplePlayer
//
//  Created by Greg Slomin on 6/1/16.
//  Copyright © 2016 Eagle Eye Networks. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import <EENMediaPlayer/EENMediaPlayer.h>

@interface VideoViewController : UIViewController<EENMediaPlayerDelegate>
@property (nonatomic, retain) NSString *cluster;
@property (nonatomic, retain) NSString *esn;
@property (nonatomic, retain) NSString *startTime;
@property (nonatomic, retain) NSString *endTime;

@end

