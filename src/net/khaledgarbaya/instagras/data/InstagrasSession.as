package net.khaledgarbaya.instagras.data
{
	public class InstagrasSession
	{
		/**
		 * The current user's ID.
		 *
		 */
		public var uid:String;
		
		/**
		 * The current user's full information, as requested from a 'self' ID.
		 * This data will vary based on what privacy settings the user has
		 * enabled in their user profile.
		 *
		 */
		public var user:Object;
		
		/**
		 * Current session for the logged in user.
		 *
		 */
		public var sessionKey:String;
		
		/**
		 * The date this session will expire.
		 *
		 */
		public var expireDate:Date;
		
		/**
		 * Oauth access token for Instagram services.
		 *
		 */
		public var accessToken:String;
		
		/**
		 * Secret key.
		 *
		 */
		public var secret:String;
		
		/**
		 * User's sig.
		 *
		 */
		public var sig:String;
		
		/**
		 * When a user accepts extended permissions, they are stored here.
		 *
		 *
		 */
		public var availablePermissions:Array;
		
		public function InstagrasSession()
		{
		}
		
		/**
		 * Populates the session data from a decoded JSON object.
		 *
		 */
		public function fromJSON(result:Object):void {
			if (result != null) {
				sessionKey = result.session_key;
				expireDate = new Date(result.expires);
				accessToken = result.access_token;
				secret = result.secret;
				sig = result.sig;
				uid = result.uid;
			}
		}
		
		/**
		 * Provides the string value of this instance.
		 *
		 */
		public function toString():String 
		{
			return '[userId:' + uid + ']';
		}
	}
}