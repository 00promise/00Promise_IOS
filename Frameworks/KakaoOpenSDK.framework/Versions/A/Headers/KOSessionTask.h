/**
* Copyright 2014 Daum Kakao Corp.
*
* Redistribution and modification in source or binary forms are not permitted without specific prior written permission.
*
* Licensed under the Apache License, Version 2.0 (the "License");
* you may not use this file except in compliance with the License.
* You may obtain a copy of the License at
*
*    http://www.apache.org/licenses/LICENSE-2.0
*
* Unless required by applicable law or agreed to in writing, software
* distributed under the License is distributed on an "AS IS" BASIS,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the License for the specific language governing permissions and
* limitations under the License.
*/

#import <UIKit/UIKit.h>
#import "KOHTTPMethod.h"

typedef void(^KOSessionTaskCompletionHandler)(id result, NSError *error);

@interface KOSessionTask : NSObject

- (id)initWithPath:(NSString *)path
        parameters:(NSDictionary *)parameters
        httpMethod:(KORequestHTTPMethod)httpMethod
 multipartFormData:(BOOL)multipartFormData
 completionHandler:(KOSessionTaskCompletionHandler)completionHandler;

+ (instancetype)taskWithPath:(NSString *)path
                  parameters:(NSDictionary *)parameters
                  httpMethod:(KORequestHTTPMethod)httpMethod
           multipartFormData:(BOOL)multipartFormData
           completionHandler:(KOSessionTaskCompletionHandler)completionHandler;

- (void)cancel;

- (void)cancelWithError:(NSError *)error;

@end
