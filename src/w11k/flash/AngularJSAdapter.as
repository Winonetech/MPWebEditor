package w11k.flash
{
	import flash.external.ExternalInterface;
	
	import mx.controls.Alert;
	import mx.core.FlexGlobals;
	
	public class AngularJSAdapter
	{
		
		public function AngularJSAdapter()
		{
			if (instance)
			{
				throw new Error("Singleton, use getInstance");
			}
			
			if (ExternalInterface.available)
			{
				const application :* = FlexGlobals.topLevelApplication;
				const parameters :* = application.parameters;
				
				flashId = parameters.w11kFlashId;
			}
			else
			{
				throw new Error('ExternalInterface has to be availabe to be able to use this adapter');
			}
			
			instance = this;
		}
		
		public function fireFlashReady():void
		{
			if (ExternalInterface.available)
			{
				try
				{
					ExternalInterface.call("w11kFlashIsReady", flashId);
				}
				catch (e:Error) 
				{
					Alert.show(e.message, e.name);
				}
			}
		}
		
		public function call(expression :String, locals :Object = null) :*
		{
			if (ExternalInterface.available)
			{
				try
				{
					var result:* = ExternalInterface.call("w11kFlashCall", flashId, expression, locals);
				}
				catch (e:Error) 
				{
					Alert.show(e.message, e.name);
				}
			}
			return result;
		}
		
        public function expose(externalName :String, func :Function):void
		{
			if (ExternalInterface.available)
			{
				try
				{
					ExternalInterface.addCallback(externalName, func);
				}
				catch (e:Error) 
				{
					Alert.show(e.message, e.name);
				}
			}
        }
		
		public static function getInstance() :AngularJSAdapter
		{
			return instance;
		}
		
		private var flashId :String;
		
		private static var instance :AngularJSAdapter = new AngularJSAdapter();
		
	}
}
