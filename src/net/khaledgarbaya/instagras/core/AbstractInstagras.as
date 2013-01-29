package net.khaledgarbaya.instagras.core
{
	import flash.utils.Dictionary;
	
	import net.khaledgarbaya.instagras.data.InstagrasAuthResponse;
	import net.khaledgarbaya.instagras.data.InstagrasSession;
	import net.khaledgarbaya.instagras.net.InstagrasRequest;

	public class AbstractInstagras
	{
		/**
		 * @private
		 *
		 */
		protected var session:InstagrasSession;
		
		/**
		 * @private
		 *
		 */
		protected var authResponse:InstagrasAuthResponse;
		
		/**
		 * @private
		 *
		 */
		protected var oauth2:Boolean;
		
		/**
		 * @private
		 *
		 */
		protected var openRequests:Dictionary;
		
		/**
		 * @private
		 *
		 */
		protected var resultHash:Dictionary;
		
		/**
		 * @private
		 *
		 */
		protected var locale:String;
		
		/**
		 * @private
		 *
		 */
		protected var parserHash:Dictionary;
		public function AbstractInstagras()
		{			
			openRequests = new Dictionary();
			resultHash = new Dictionary(true);
			parserHash = new Dictionary();
		}
		/**
		 * @private
		 *
		 */
		protected function get accessToken():String {
			if ((oauth2 && authResponse != null) || session != null) {
				return oauth2 ? authResponse.accessToken : session.accessToken;
			} else {
				return null;
			}
		}
		/**
		 * @private
		 *
		 */
		protected function api(method:String,
							   callback:Function = null,
							   params:* = null,
							   requestMethod:String = 'GET'
		):void {
			method = (method.indexOf('/') != 0) ?  '/'+method : method;
			
			if (accessToken){
				if (params == null) { params = {}; }
				if (params.access_token == null) { params.access_token = accessToken; }
			}
			
			var req:InstagrasRequest = new InstagrasRequest();
			
			if (locale) { params.locale = locale; }
			
			//We need to hold on to a reference or the GC might clear this during the load.
			openRequests[req] = callback;
			
			req.call(InstagrasURLDefaults.INSTA_API_URL+method, requestMethod, handleRequestLoad, params);
		}
		/**
		 * @private
		 * 
		 */
		protected function pagingCall(url:String, callback:Function):InstagrasRequest {
			var req:InstagrasRequest = new InstagrasRequest();
			
			//We need to hold on to a reference or the GC might clear this during the load.
			openRequests[req] = callback;
			
			req.callURL(handleRequestLoad, url, locale);
			
			return req;
		}
		
		/**
		 * @private
		 * 
		 */
		protected function getRawResult(data:Object):Object {
			return resultHash[data];
		}
		
		/**
		 * @private
		 * 
		 */
		protected function nextPage(data:Object, callback:Function = null):InstagrasRequest {
			var req:InstagrasRequest = null;
			var rawObj:Object = getRawResult(data);
			if (rawObj && rawObj.paging && rawObj.paging.next) {
				req = pagingCall(rawObj.paging.next, callback);
			} else if(callback != null) {
				callback(null, 'no page');
			}
			return req;
		}
		
		/**
		 * @private
		 * 
		 */
		protected function previousPage(data:Object, callback:Function = null):InstagrasRequest {
			var req:InstagrasRequest = null;
			var rawObj:Object = getRawResult(data);
			if (rawObj && rawObj.paging && rawObj.paging.previous) {
				req = pagingCall(rawObj.paging.previous, callback);
			} else if(callback != null) {
				callback(null, 'no page');
			}
			return req;
		}
		
		/**
		 * @private
		 * 
		 */
		protected function handleRequestLoad(target:InstagrasRequest):void {
			var resultCallback:Function = openRequests[target];
			if (resultCallback === null) {
				delete openRequests[target];
			}
			
			if (target.success) {
				var data:Object = ('data' in target.data) ? target.data.data : target.data;
				resultHash[data] = target.data; //keeps a reference to the entire raw object Facebook returns (including paging, etc.)
				if (data.hasOwnProperty("error_code")) {
					resultCallback(null, data);
				} else {
					resultCallback(data, null);
				}
			} else {
				resultCallback(null, target.data);
			}
			
			delete openRequests[target];
		}
	}
}