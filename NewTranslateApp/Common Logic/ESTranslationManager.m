//
//  ESTranslateManager.m
//  NewTranslateApp
//
//  Created by Ekaterina Systerova on 28.11.2017.
//  Copyright © 2017 Ekaterina Systerova. All rights reserved.
//

#import "ESTranslationManager.h"
#import "Word.h"
#import "Language.h"

const NSString *kYandexApiKey = @"trnsl.1.1.20150314T143415Z.27b846e36cc8cc1b.68a816b75ece8c9412a0e83d2f07d689f13426c9";
const NSString *kYandexBaseUrl = @"https://translate.yandex.net/api/v1.5/tr.json/";

static ESTranslationManager *shared;

@implementation ESTranslationManager

- (id)initWithBaseURL:(NSURL *)url
{
    self = [super initWithBaseURL:url];
    if (self) {
        [AFNetworkReachabilityManager sharedManager];
        [[AFNetworkReachabilityManager sharedManager] startMonitoring];
        
        self.responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
        self.requestSerializer = [AFJSONRequestSerializer serializer];
        [self.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    }
    return self;
}

+ (ESTranslationManager *)shared {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [[ESTranslationManager alloc] initWithBaseURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", kYandexBaseUrl]]];
    });
    return shared;
}

+ (void)translationForWord:(NSString *)nativeWord language:(NSString *)language completion:(void(^)(BOOL success, NSError *error))completion {
    
    //    https://translate.yandex.net/api/v1.5/tr.json/translate
    //    ? [key=<API-ключ>]
    //    & [text=<переводимый текст>]
    //    & [lang=<направление перевода>]
    //    & [format=<формат текста>]
    //    & [options=<опции перевода>]
    //    & [callback=<имя callback-функции>]
    
    NSString *url = [NSString stringWithFormat:@"translate?key=%@&text=%@&lang=%@&options=1", kYandexApiKey, [nativeWord stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]], language];
    
    [[ESTranslationManager shared] GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if (responseObject && [responseObject isKindOfClass:[NSDictionary class]]) {
            
            NSDictionary *response = responseObject;
            NSDictionary *detected = response[@"detected"];
            
            if (detected && [detected isKindOfClass:[NSDictionary class]]) {
                
                [Word saveWord:nativeWord fromDictionary:response completion:completion];
                
            } else {
                
                NSString *message = response[@"message"];
                NSNumber *code = response[@"code"];
                NSError *error = [NSError errorWithDomain:@"com.katesysterova.newTranslateApp" code:[code intValue] userInfo:@{NSLocalizedDescriptionKey : message}];
                completion(NO, error);
            }
        }
        if (completion) {
            completion(NO, nil);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        if (completion) {
            completion(NO, error);
        }
    }];
}

+ (void)languages:(void(^)(BOOL success, NSError *error))completion {
    
    //    https://translate.yandex.net/api/v1.5/tr.json/getLangs
    //    ? [key=<API-ключ>]
    //    & [ui=<код языка>]
    //    & [callback=<имя callback-функции>]
    
    NSString *url = [NSString stringWithFormat:@"getLangs?key=%@&ui=ru", kYandexApiKey];
    
    [[ESTranslationManager shared] GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if (responseObject && [responseObject isKindOfClass:[NSDictionary class]]) {
            
            NSDictionary *response = responseObject;
            NSDictionary *languages = response[@"langs"];

            if (languages && [languages isKindOfClass:[NSDictionary class]]) {
                
                [Language saveLanguagesFromDictionary:languages completion:completion];
                
            } else {
                
                NSString *message = response[@"message"];
                NSNumber *code = response[@"code"];
                NSError *error = [NSError errorWithDomain:@"com.katesysterova.newTranslateApp" code:[code intValue] userInfo:@{NSLocalizedDescriptionKey : message}];
                completion(NO, error);
            }
        }
        else
        {
            completion(NO, nil);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        completion(NO, error);
    }];
}
@end
