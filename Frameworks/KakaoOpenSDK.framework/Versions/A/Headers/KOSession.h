/**
* Copyright 2015 Daum Kakao Corp.
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

/*!
 @header KOSession.h
 카카오계정을 통해 인증 및 로그아웃할 수 있는 기능을 제공합니다.
 */

#import <Foundation/Foundation.h>
#import "KOSessionTask.h"

/*!
 @abstract Kakao 인증시의 내부 상태값
 @param KOSessionStateNotOpen 세션이 열리지 않은 상태. 인증이 되지 않은 상태.
 @param KOSessionStateOpening 세션을 열기위한 진행중의 상태. 인증 진행중의 상태.
 @param KOSessionStateOpen 세션이 성공적으로 열린 상태. 인증이 완료된 상태.
 */
typedef NS_ENUM(NSInteger, KOSessionState) {
    KOSessionStateNotOpen = 0,
    KOSessionStateOpening,
    KOSessionStateOpen
};

/*!
 @typedef KOSessionCompletionHandler
 @abstract Kakao 인증 완료시 실행될 Completion Handler
 @param error 오류 정보
 */
typedef void(^KOSessionCompletionHandler)(NSError *error);

/*!
 @typedef KOCompletionSuccessHandler
 @abstract Kakao API의 비동기 호출 성공 여부를 받아 처리해주는 Completion Handler
 @param success 성공 여부
 @param error 오류 정보
 */
typedef void(^KOCompletionSuccessHandler)(BOOL success, NSError *error);

/*!
 @abstract KOAuthType 카카오계정 로그인시의 인증 타입
 @constant KOAuthTypeTalk 카카오톡으로 간편 인증
 @constant KOAuthTypeStory 카카오스토리로 간편 인증
 @constant KOAuthTypeAccount 카카오계정으로 직접 ID, Password로 인증
 */
typedef NS_ENUM(NSInteger, KOAuthType) {
    KOAuthTypeTalk = 1 << 1,
    KOAuthTypeStory = 1 << 2,
    KOAuthTypeAccount = 1 << 3
};

/*!
 * @class KOSession
 * @abstract 인증 관리 클래스.
 */
@interface KOSession : NSObject

/*!
 * @property appKey
 * @abstract 카카오에서 발급한 클라이언트 아이디
 */
@property(nonatomic, readonly) NSString *appKey;
/*!
 * @property redirectUri
 * @abstract 클라이언트 실행을 위한 커스텀 스킴 주소
 */
@property(nonatomic, readonly) NSString *redirectUri;
/*!
 * @property accessToken
 * @abstract API 접근 oauth access token
 */
@property(nonatomic, readonly, copy) NSString *accessToken;
/*!
 * @property refreshToken
 * @abstract API 접근 oauth refresh token
 */
@property(nonatomic, readonly, copy) NSString *refreshToken;
/*!
 * @property state
 * @abstract 인증 상태
 */
@property(nonatomic, readonly) KOSessionState state;

/*!
 @abstract 현재 session 정보
 */

+ (KOSession *)sharedSession;

/*!
 카카오계정 로그인 callback인지 여부
 @param url 카카오 계정 인증 요청 code 또는 오류정보를 담은 url
 */
+ (BOOL)isKakaoAccountLoginCallback:(NSURL *)url;

/*!
 KakaoLink 메세지의 Action인지 여부
 @param url KakaoLink 메세지의 execparam 을 담은 url
 */
+ (BOOL)isKakaoLinkCallback:(NSURL *)url;

/*!
 KakaoStory Post의 Action인지 여부
 @param url KakaoStory Post 메세지의 execparam 을 담은 url
 */
+ (BOOL)isStoryPostCallback:(NSURL *)url;

/*!
 url에 포함된 code 정보로 oauth 인증 토큰을 요청한다. 인증 토큰 요청이 완료되면 completionHandler를 실행한다.
 @param url 인증 요청 code 또는 오류 정보(error, error_description)를 담은 url
 @param completionHandler 요청 완료시 실행될 block. 오류 처리와 인증 완료 작업을 수행한다.
 */
+ (BOOL)handleOpenURL:(NSURL *)url;

/*!
 openWithCompletionHandler 로 인증도중에 빠져나와 앱으로 돌아올때의 인증처리를 취소한다.
 */
+ (void)handleDidBecomeActive;

/*!
 기기의 로그인 수행 가능한 카카오 앱에 로그인 요청을 전달한다.
 @param completionHandler 요청 완료시 실행될 block. 오류 처리와 로그인 완료 작업을 수행한다.
 */
- (void)openWithCompletionHandler:(KOSessionCompletionHandler)completionHandler;

/*!
 기기의 로그인 수행 가능한 카카오 앱에 로그인 요청을 전달한다.
 @param completionHandler 요청 완료시 실행될 block. 오류 처리와 로그인 완료 작업을 수행한다.
 @param authParams 로그인 요청시의 인증에 필요한 부가적인 파라미터들을 전달한다.
 */
- (void)openWithCompletionHandler:(KOSessionCompletionHandler)completionHandler authParams:(NSDictionary *)authParams;

/*!
 기기의 로그인 수행 가능한 카카오 앱에 로그인 요청을 전달한다.
 @param completionHandler 요청 완료시 실행될 block. 오류 처리와 로그인 완료 작업을 수행한다.
 @param authParams 로그인 요청시의 인증에 필요한 부가적인 파라미터들을 전달한다.
 @param authType 로그인 요청시의 인증 타입(KOAuthType)의 array(var arguments로서 nil-terminated list). 주의) list의 마지막은 꼭 nil로 끝나야함. 예) KOAuthTypeTalk, KOAuthTypeStory, KOAuthTypeAccount, nil
 */
- (void)openWithCompletionHandler:(KOSessionCompletionHandler)completionHandler authParams:(NSDictionary *)authParams authType:(KOAuthType)authType, ...;

/*!
 현재 기기에서만 로그아웃한다.
 @param completionHandler 요청 완료시 실행될 block.
 */
- (void)logoutAndCloseWithCompletionHandler:(KOCompletionSuccessHandler)completionHandler;

/*!
 인증 토큰을 제거하여 session을 무효화한다.
 */
- (void)close;

/*!
 인증되어 있는지 여부.
 */
- (BOOL)isOpen;
//
//- (void)pendTask:(KOSessionTask*)task;

@end

// notifications
/*!
 로그인 인증 정보 변경 노티피케이션 이름
 */
extern NSString *const KOSessionDidChangeNotification;


// Auth Parameters Keys
/*!
 로그인 시 동의 화면의 타입 설정에 대한 키 이름
 */
extern NSString *const KOAuthKeyApprovalType;


// Auth Parameters Approval Type Values
/*!
 로그인 시 동의 화면의 타입 중 어플리케이션 개별 인증 설정
 */
extern NSString *const KOAuthApprovalIndividualType;

/*!
 로그인 시 동의 화면의 타입 중 프로젝트 인증 설정
 */
extern NSString *const KOAuthApprovalProjectType;
