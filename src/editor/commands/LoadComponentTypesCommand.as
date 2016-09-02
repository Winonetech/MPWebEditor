package editor.commands
{
	
	/**
	 * 
	 * 加载元素类型。
	 * 
	 */
	
	
	import cn.mvc.events.TimeoutEvent;
	import cn.mvc.net.URILoader;
	import cn.mvc.utils.ObjectUtil;
	
	import editor.views.Debugger;
	
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;
	
	import mx.rpc.events.ResultEvent;
	
	
	public final class LoadComponentTypesCommand extends _InternalCommand
	{
		
		/**
		 * 
		 * 构造函数。
		 * 
		 */
		
		public function LoadComponentTypesCommand()
		{
			super();
		}
		
		
		/**
		 * @inheritDoc
		 */
		
		override public function execute():void
		{
			commandStart();
			
			loadComponentTypes();
		}
		
		
		/**
		 * @private
		 */
		private function loadComponentTypes():void
		{
			var loader:URILoader = new URILoader;
			loader.timeout = 5;
			loader.addEventListener(Event.COMPLETE, handlerDefault);
			loader.addEventListener(IOErrorEvent.IO_ERROR, handlerDefault);
			loader.addEventListener(TimeoutEvent.TIMEOUT, handlerDefault);
			loader.load(new URLRequest("flash/cache/assets/elementTypes.json"));
		}
		
		/**
		 * @private
		 */
		private function handlerDefault(e:Event):void
		{
			var loader:URILoader = e.target as URILoader;
			loader.removeEventListener(Event.COMPLETE, handlerDefault);
			loader.removeEventListener(IOErrorEvent.IO_ERROR, handlerDefault);
			loader.removeEventListener(TimeoutEvent.TIMEOUT, handlerDefault);
			
			
			if (e.type == Event.COMPLETE)
			{
				provider.raw["componentTypes"] = ObjectUtil.convert(e.target.data, Object);
				
				Debugger.log("加载组件类型数据完毕！");
				
				commandEnd();
			}
			else
			{
				if (count++ < 2)
				{
					loadComponentTypes();
				}
				else
				{
					Debugger.log("加载组件类型数据出错！");
					
					switch (e.type)
					{
						case IOErrorEvent.IO_ERROR:
							Debugger.log((e as IOErrorEvent).text);
							break;
						case TimeoutEvent.TIMEOUT:
							Debugger.log("加载超时！");
							break;
					}
					
					commandEnd();
				}
			}
			
			
		}
		
		
		/**
		 * @private
		 */
		private var count:uint = 0;
		
	}
}