package net.khaledgarbaya.instagras.core
{
	import flash.external.ExternalInterface;

	public class InstagrasJSBridge
	{
		public static const NS:String = "IGAS";
		public function InstagrasJSBridge()
		{
			try {
				if( ExternalInterface.available ) {
					ExternalInterface.call( script_js );	
					
					/*Get a reference to the embedded SWF (object/embed tag). Note that Chrome/Mozilla Browsers get the 'name' attribute whereas IE uses the 'id' attribute. 
					This is important to note, since it relies on how you embed the SWF. In the examples, we embed using swfObject and we have to set the attribute 'name' the 
					same as the id.*/
					ExternalInterface.call( "IGAS.setSWFObjectID", ExternalInterface.objectID );
				}
			} catch( error:Error ) {}
		}
		
		/**
		 * you will need to add th javascript SDK in your html page  :  https://github.com/Instagram/instagram-javascript-sdk (Official JS SDK For Instagram)
		 */
		private const script_js:XML =
			<script>
				<![CDATA[
					function() {
						IGAS = {
							endPoint: 'https://instagram.com/oauth/authorize/?',
							setSWFObjectID: function( swfObjectID ) {																
								console.log("setSWFObjectID");
								IGAS.swfObjectID = swfObjectID;
							},
							updateSwfAuthResponse: function( response ) {								
								console.log("updateSwfAuthResponse");
								swf = IGAS.getSwf();
								
								if( response == null ) {
									swf.authResponseChange( null );
								} else {
									console.log("not null");
									swf.authResponseChange( JSON.stringify( response ) );
								}
								
							},
							handleUserLogin: function( response ) {
								console.log("handleUserLogin");
								IGAS.updateSwfAuthResponse( response.session );
							},
							getSwf: function getSwf() {								
								return document.getElementById( IGAS.swfObjectID );		
								console.log("getLoginStatus");
							},
							getToken : function() {
							      return window.location.hash.replace('#access_token=', '');
							},
							init: function( opts ) {
								console.log(this.getToken());
								if(this.getToken())
								{
									IGAS.updateSwfAuthResponse( {accessToken:this.getToken()} );
								}
								else{
									IGAS.updateSwfAuthResponse( null );
								}
							},
							login: function(options) {
						     opts = JSON.parse(options)
							  console.log(opts.client_id);
						      this.authUri = 'https://instagram.com/oauth/authorize/?client_id='+opts.client_id+'&redirect_uri='+opts.redirect_uri+'&response_type=token&scope='+opts.scope
						      return window.location.href = this.authUri;
						    }
					};
				}
				]]>
		</script>;
	}
}