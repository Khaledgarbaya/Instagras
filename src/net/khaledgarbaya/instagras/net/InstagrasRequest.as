package net.khaledgarbaya.instagras.net
{
	import flash.net.URLRequest;

	public class InstagrasRequest extends AbstractIntagrasRequest
	{
		public function InstagrasRequest()
		{
			super();
		}
		public function call(url:String,
							 requestMethod:String = 'GET',
							 callback:Function = null,
							 values:* = null):void {
			
			_url = url;
			_requestMethod = requestMethod;
			_callback = callback;
			
			var requestUrl:String = url;
			
			urlRequest = new URLRequest(requestUrl);
			urlRequest.method = _requestMethod;
			
			//If there are no user defined values, just send the request as is.
			if (values == null) {
				loadURLLoader();
				return;
			}
			else
			{
				urlRequest.data = objectToURLVariables(values);
				loadURLLoader();
			}
		}
	}
}