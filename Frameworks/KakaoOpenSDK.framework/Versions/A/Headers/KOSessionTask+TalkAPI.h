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

#import "KOSessionTask.h"
#import "KOTalkProfile.h"

/*!
 @header KOSessionTask+TalkAPI.h
 인증된 session 정보를 바탕으로 각종 카카오톡 API를 호출할 수 있습니다.
 */

/*!
 인증된 session 정보를 바탕으로 각종 카카오톡 API를 호출할 수 있습니다.
 */
@interface KOSessionTask (TalkAPI)

#pragma mark - KakaoTalk

/*!
 @abstract 현재 로그인된 사용자의 카카오톡 프로필 정보를 얻을 수 있습니다.
 @param completionHandler 카카오톡 프로필 정보를 얻어 처리하는 핸들러
 @discussion
 */
+ (instancetype)talkProfileTaskWithCompletionHandler:(KOSessionTaskCompletionHandler)completionHandler;

/*!
 @abstract 현재 로그인된 사용자의 카카오톡 프로필 정보를 얻을 수 있습니다.
 @param secureResource 프로필, 썸네일 이미지 등의 리소스 정보들에 대해 https를 지원하는 형식으로 응답을 받을지의 여부. YES일 경우 https지원, NO일 경우 http지원.
 @param completionHandler 카카오톡 프로필 정보를 얻어 처리하는 핸들러
 @discussion
 */
+ (instancetype)talkProfileTaskWithSecureResource:(BOOL)secureResource
                                completionHandler:(KOSessionTaskCompletionHandler)completionHandler;

@end
