#Instagras : Instagram ActionScript 3 library

What is Instagras ?
-------------------
Instagras (Intagram for AS) is an actionscript 3 library to help you create intagram content driven application using the flash platform.
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
  			}
      
		  //init callback
        private function initCallBack(result:Object, fail:Object):void
  			{
  			  	  if(result == null);//the class have the access token and ready to use it
                 login();
  			}
      
LICENCE
-------
* this code is open source and feel free to use it modify , I will be glad to receive at mail from you first at  khaledgarbaya@gmail.com
* Feel Free to report any issue or bug I'll be glad to try to fix it for you
* Copyright  © [Khaled Garbaya](http://khaledgarbaya.net/)

Upcoming Features
-----------------
* Performance tweaks
* Code Cleanup
* Add more Samples to the Instagras-samples Repo ( 'https://github.com/Khaledgarbaya/Instagras-samples' )

