#Instagras : Instagram ActionScript 3 library

What is Instagras ?
-------------------
Instagras (Instagram for AS) is an actionscript 3 library to help you create intagram content driven application using the flash platform.
All the api Calls is through the Instagras Class.

How to use it?
--------------
1.clone the repo at  : 'https://github.com/Khaledgarbaya/Instagras.git'

2.The main class that you'll be working with is the Instagras Call.It Static so you don't need to instantiate it.

3.Sample code : 
  		
      import net.khaledgarbaya.instagras.Instagras;
			
      private var appID:String="CLIENT_ID";

      // init the api
      Instagras.init(appID,initCallBack);
      
      //login
      	protected function login():void
  	{
  			
                  Instagras.login(loginCallBack,{client_id:appID,
  				  response_type:"code",//the redirect uri will be http://yoursite.com/#access_token
  			          redirect_uri:"REDIRECT_URI",
  				  scope: 'likes+comments'});
  	}
		  
      //after the login
        private function loginCallBack(result:Object, failt:Object):void
  	{
              //login callback	
              //no you can use the Instagras.api("method") to get some data for example
              Intagras.api("users/self",apiCallBack)
  	}
      	private function apiCallBack(result:Object, fail:Object):void
      	{
      		//the data will be stored into the result object
      	
      	}
	//init callback
        private function initCallBack(result:Object, fail:Object):void
  	{
  	  	  
  	  	  if(result == null);//the class have the access token and ready to use it
 			login();
  	}
      
LICENSE
-------
Simplified BSD License
======================

* Copyright 2013 [Khaled Garbaya](http://khaledgarbaya.net/) . All rights reserved.

* Redistribution and use in source and binary forms, with or without modification,
are permitted provided that the following conditions are met:

   1. Redistributions of source code must retain the above copyright notice, this list of
      conditions and the following disclaimer.

   2. Redistributions in binary form must reproduce the above copyright notice, this list
      of conditions and the following disclaimer in the documentation and/or other materials
      provided with the distribution.

THIS SOFTWARE IS PROVIDED BY KHALED GARBAYA AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

Upcoming Features
-----------------
* Performance tweaks
* Code Cleanup
* Add more Samples to the Instagras-samples Repo ( 'https://github.com/Khaledgarbaya/Instagras-samples' )
* Add Desktop API
* Add Mobile API

