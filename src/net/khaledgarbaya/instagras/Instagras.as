package net.khaledgarbaya.instagras
{
	import flash.external.ExternalInterface;
	import flash.utils.Dictionary;
	
	import net.khaledgarbaya.instagras.core.AbstractInstagras;
	import net.khaledgarbaya.instagras.core.InstagrasJSBridge;
	import net.khaledgarbaya.instagras.data.InstagrasAuthResponse;
	import net.khaledgarbaya.instagras.net.InstagrasRequest;
	import net.khaledgarbaya.instagras.utils.InstagrasRequestMethod;
	
	public class Instagras extends AbstractInstagras
	{
		/**
		 * @private
		 *
		 */
		protected var jsCallbacks:Object;
		
		/**
		 * @private
		 *
		 */
		protected var openUICalls:Dictionary;
		
		/**
		 * @private
		 *
		 */
		protected var jsBridge:InstagrasJSBridge;
		/**
		 * @private
		 *
		 */
		protected var applicationId:String;
		
		/**
		 * @private
		 *
		 */
		protected static var _instance:Instagras;
		
		/**
		 * @private
		 *
		 */
		protected static var _canInit:Boolean = false;
		
		/**
		 * @private
		 *
		 */
		protected var _initCallback:Function;
		
		/**
		 * @private
		 *
		 */
		protected var _loginCallback:Function;
		
		/**
		 * @private
		 *
		 */
		protected var _logoutCallback:Function;
		
		public function Instagras()
		{
			super();
			
			if (_canInit == false) {
				throw new Error(
					'Instagras is a singleton and cannot be instantiated.'
				);
			}
		}
		public static function init(applicationId:String,
									callback:Function = null,
									options:Object = null,
									accessToken:String = null
		):void
		{
			
			getInstance().init(applicationId, callback, options, accessToken);
		}
		
		public static function login(callback:Function, options:Object = null):void 
		{
			getInstance().login(callback, options);
		}
		public static function logout(callback:Function):void 
		{
			getInstance().logout(callback);
		}
		public static function api(method:String,
								   callback:Function = null,
								   params:* = null,
								   requestMethod:String = 'GET'
		):void
		{
			
			getInstance().api(method,
				callback,
				params,
				requestMethod
			);
		}
		/**
		 * @private
		 *
		 */
		protected function login(callback:Function, options:Object = null):void {
			_loginCallback = callback;
			
			ExternalInterface.call('IG.login', JSON.stringify(options));
		}
		/**
		 * @private
		 *
		 */
		protected function logout(callback:Function):void {
			_logoutCallback = callback;      
			ExternalInterface.call('IG.logout');
		}		
		
		public static function getRawResult(data:Object):Object {			
			return getInstance().getRawResult(data);
		}
		
		public static function hasNext(data:Object):Boolean {
			var result:Object = getInstance().getRawResult(data);
			if(!result.paging){ return false; }
			return (result.paging.next != null);
		}
		
		public static function hasPrevious(data:Object):Boolean {
			var result:Object = getInstance().getRawResult(data);
			if(!result.paging){ return false; }
			return (result.paging.previous != null);
		}
		
		public static function nextPage(data:Object, callback:Function):InstagrasRequest {
			return getInstance().nextPage(data, callback);
		}
		
		public static function previousPage(data:Object, callback:Function):InstagrasRequest {
			return getInstance().previousPage(data, callback);
		}
		
		public static function postData(
			method:String,
			callback:Function = null,
			params:Object = null
		):void {
			
			api(method, callback, params, InstagrasRequestMethod.POST);
		}
		public static function getLoginStatus():void {
			getInstance().getLoginStatus();
		}
		/**
		 * @private
		 *
		 */
		protected function getLoginStatus():void {
			ExternalInterface.call('IG.getLoginStatus');
		}
		protected function init(applicationId:String,
								callback:Function = null,
								options:Object = null,
								accessToken:String = null
		):void {
			
			ExternalInterface.addCallback('handleJsEvent', handleJSEvent);
			ExternalInterface.addCallback('authResponseChange', handleAuthResponseChange);
			ExternalInterface.addCallback('logout', handleLogout);
			ExternalInterface.addCallback('uiResponse', handleUI);
			
			_initCallback = callback;
			
			this.applicationId = applicationId;
			this.oauth2 = true;
			
			if (options == null) { options = {};}
			options.appId = applicationId;
			options.oauth = true;
			
			ExternalInterface.call('IG.init', JSON.stringify(options));
			
			if (accessToken != null) {
				authResponse = new InstagrasAuthResponse();
				authResponse.accessToken = accessToken;
			}
			
			if (options.status !== false) {
				getLoginStatus();
			} else if (_initCallback != null) {
				_initCallback(authResponse, null);
				_initCallback = null;
			}
		}
		/**
		 * @private
		 *
		 */
		protected function callJS(methodName:String, params:Object):void {
			ExternalInterface.call(methodName, params);
		}
		/**
		 * @private
		 *
		 */
		protected function handleUI( result:String, method:String ):void {
			var decodedResult:Object = result ? JSON.parse(result) : null;
			var uiCallback:Function = openUICalls[method];
			if (uiCallback === null) {
				delete openUICalls[method];
			} else {
				uiCallback(decodedResult);
				delete openUICalls[method];
			}
		}
		
		/**
		 * @private
		 *
		 */
		protected function handleLogout():void {
			authResponse = null;
			if (_logoutCallback != null) {
				_logoutCallback(true);
				_logoutCallback = null;
			}
		}
		
		/**
		 * @private
		 *
		 */
		protected function handleJSEvent(event:String,
										 result:String = null
		):void {
			
			if (jsCallbacks[event] != null) {
				var decodedResult:Object;
				try {
					decodedResult = JSON.parse(result);
				} catch (e:Error) { }
				
				for (var func:Object in jsCallbacks[event]) {
					(func as Function)(decodedResult);
					delete jsCallbacks[event][func];
				}
			}
		}
		
		/**
		 * @private
		 *
		 */
		protected function handleAuthResponseChange(result:String):void {
			var resultObj:Object;
			var success:Boolean = true;
			
			if (result != null) {
				try {
					resultObj = JSON.parse(result);
				} catch (e:Error) {
					success = false;
				}
			} else {
				success = false;
			}
			
			if (success) {
				if (authResponse == null) {
					authResponse = new InstagrasAuthResponse();		  
					authResponse.fromJSON(resultObj);
				} else {
					authResponse.fromJSON(resultObj);
				}
			}
			
			if (_initCallback != null) {
				_initCallback(authResponse, null);
				_initCallback = null;
			}
			
			if (_loginCallback != null) {
				_loginCallback(authResponse, null);
				_loginCallback = null;
			}
		}
		
		/**
		 * @private
		 *
		 */
		protected static function getInstance():Instagras {
			if (_instance == null) {
				_canInit = true;
				_instance = new Instagras();
				_canInit = false;
			}
			return _instance;
		}
	}
}