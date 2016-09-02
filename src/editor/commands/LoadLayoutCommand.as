package editor.commands
{
	
	/**
	 * 
	 * 加载整个布局。
	 * 
	 */
	
	
	import cn.mvc.events.TimeoutEvent;
	import cn.mvc.net.URILoader;
	import cn.mvc.utils.ObjectUtil;
	import cn.mvc.utils.RegexpUtil;
	
	import editor.consts.URLConsts;
	import editor.views.Debugger;
	
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;
	
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.http.HTTPService;
	
	
	public final class LoadLayoutCommand extends _InternalCommand
	{
		
		/**
		 * 
		 * 构造函数。
		 * 
		 */
		
		public function LoadLayoutCommand()
		{
			super();
		}
		
		
		/**
		 * @inheritDoc
		 */
		
		override public function execute():void
		{
			commandStart();
			
			loadLayout();
		}
		
		
		/**
		 * @private
		 */
		private function loadLayout():void
		{
			http = new HTTPService;
			http.contentType = "application/json";
			http.method = "GET";
			
			http.addEventListener(ResultEvent.RESULT, handlerDefault);
			http.addEventListener(FaultEvent.FAULT, handlerDefault);
			http.url = RegexpUtil.replaceTag(URLConsts.URL_LAYOUT, provider);
			http.send();
			Debugger.log(http.url);
		}
		
		
		/**
		 * @private
		 */
		private function handlerDefault(e:Event):void
		{
			http.removeEventListener(ResultEvent.RESULT, handlerDefault);
			http.removeEventListener(FaultEvent.FAULT, handlerDefault);
			
			if (e.type == ResultEvent.RESULT)
			{
				var temp:Object = ObjectUtil.convert((e as ResultEvent).result, Object);
				if (temp["result"] == "success")
				{
					provider.raw["layout"] = temp.dataObj;
					
					Debugger.log("加载布局数据完毕！");
				}
				else
				{
					Debugger.log("加载布局数据出错，请联系服务端管理员！");
				}
				
				commandEnd();
			}
			else
			{
				if (count++ < 2)
				{
					Debugger.log("load layout error, reload");
					loadLayout();
				}
				else
				{
					Debugger.log("加载布局数据出错！");
					
					switch (e.type)
					{
						case IOErrorEvent.IO_ERROR:
							Debugger.log((e as IOErrorEvent).text);
							break;
						case TimeoutEvent.TIMEOUT:
							Debugger.log("加载数据超时！");
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
		
		/**
		 * @private
		 */
		private var http:HTTPService;
		
	}
}