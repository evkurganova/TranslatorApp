//
//  ESTranslateManager.m
//  NewTranslateApp
//
//  Created by Ekaterina Systerova on 28.11.2017.
//  Copyright © 2017 Ekaterina Systerova. All rights reserved.
//

#import "ESTranslationManager.h"
#import "ESAppSettings.h"
#import "Word+CoreDataClass.h"
#import "Language+CoreDataClass.h"

const NSString *kYandexApiKey = @"trnsl.1.1.20150314T143415Z.27b846e36cc8cc1b.68a816b75ece8c9412a0e83d2f07d689f13426c9";
const NSString *kYandexBaseUrl = @"https://translate.yandex.net/api/";
const NSString *kYandexApiVersion = @"v1.5";

static ESTranslationManager *shared;

@implementation ESTranslationManager

+ (ESTranslationManager *)shared {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [[ESTranslationManager alloc] initWithBaseURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@/", kYandexBaseUrl, kYandexApiVersion]]];
    });
    return shared;
}

+ (void)translationForWord:(NSString *)nativeWord completion:(void(^)(BOOL success, NSError *error, Word *word))completion {
    
    //    https://translate.yandex.net/api/v1.5/tr.json/translate
    //    ? [key=<API-ключ>]
    //    & [text=<переводимый текст>]
    //    & [lang=<направление перевода>]
    //    & [format=<формат текста>]
    //    & [options=<опции перевода>]
    //    & [callback=<имя callback-функции>]
    
    NSString *url = [NSString stringWithFormat:@"/tr.json/translate?key=%@&text=%@&lang=%@&options=1", kYandexApiKey, [nativeWord stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]], [ESAppSettings translationLanguage]];

    [[ESTranslationManager shared] GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if (responseObject && [responseObject isKindOfClass:[NSDictionary class]]) {
            
            NSDictionary *response = responseObject;
            NSDictionary *detected = response[@"detected"];
            
            if (detected && [detected isKindOfClass:[NSDictionary class]]) {
                NSArray *textArr = response[@"text"];
                NSString *translationCodeLanguage = response[@"lang"];
                
                //[textArr firstObject], [translationCodeLanguage substringWithRange:NSMakeRange(3, 2)]
                if (completion)
                {
                    completion(YES, nil, nil);
                }
                return;
            }
        }
        if (completion) {
            completion(NO, nil, nil);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        if (completion) {
            completion(NO, error, nil);
        }
    }];
}

+ (void)languages:(void(^)(BOOL success, NSError *error, NSArray<Language *> *languages))completion {
    
    //    https://translate.yandex.net/api/v1.5/tr.json/getLangs
    //    ? [key=<API-ключ>]
    //    & [ui=<код языка>]
    //    & [callback=<имя callback-функции>]
    
}
@end
