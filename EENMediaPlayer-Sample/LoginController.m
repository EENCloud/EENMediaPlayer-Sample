//
//  LoginController.m
//  TestPlayer
//
//  Created by Greg Slomin on 8/4/17.
//  Copyright © 2017 Eagle Eye Networks. All rights reserved.
//

#import "LoginController.h"
#import <AFNetworking/AFNetworking.h>

@interface LoginController ()
@property (weak, nonatomic) IBOutlet UITextField *userField;
@property (weak, nonatomic) IBOutlet UITextField *passField;
@property (weak, nonatomic) IBOutlet UITextField *esnField;
@property (weak, nonatomic) IBOutlet UIButton *submitButton;
@property (nonatomic, retain) NSString *cluster;
@property (nonatomic, retain) AFHTTPSessionManager *sessionManager;
@end

@implementation LoginController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.sessionManager = [AFHTTPSessionManager manager];
    _userField.text = @"gslomin+ios2@eagleeyenetworks.com";
    _passField.text = @"iufan4lifeul";
    _esnField.text = @"1000f60d";
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)submitTouched:(id)sender {
    
    NSString *user = _userField.text;
    NSString *pass = _passField.text;
    NSString *esn = _esnField.text;
    
    [_sessionManager POST:@"https://login.eagleeyenetworks.com/g/aaa/authenticate" parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [formData appendPartWithFormData:[user dataUsingEncoding:NSUTF8StringEncoding] name:@"username"];
        [formData appendPartWithFormData:[pass dataUsingEncoding:NSUTF8StringEncoding] name:@"password"];
        [formData appendPartWithFormData:[@"eagleeyenetworks" dataUsingEncoding:NSUTF8StringEncoding] name:@"realm"];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"Response: %@", responseObject);
        [self authorize:responseObject[@"token"]];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"Failure: %@", error);
    }];
    
}

-(void)authorize:(NSString*)token {
    [_sessionManager POST:@"https://login.eagleeyenetworks.com/g/aaa/authorize" parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [formData appendPartWithFormData:[token dataUsingEncoding:NSUTF8StringEncoding] name:@"token"];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"Response: %@", responseObject);
        self.cluster = responseObject[@"active_brand_subdomain"];
        [self performSegueWithIdentifier:@"showVideo" sender:self];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"Failure: %@", error);
    }];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    ViewController *vc = [segue destinationViewController];
    vc.cluster = self.cluster;
    vc.esn = self.esnField.text;
}


@end
