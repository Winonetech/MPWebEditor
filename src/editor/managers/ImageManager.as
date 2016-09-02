package editor.managers
{
	
	/**
	 * 
	 * 图片资源管理。
	 * 
	 */
	
	
	import cn.mvc.managers.Manager;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;
	import flash.utils.Dictionary;
	
	
	public final class ImageManager extends Manager
	{
		
		/**
		 * 
		 * 获取位图缓存资源。
		 * 
		 */
		
		public static function retrieveBitmapData($source:String):BitmapData
		{
			if(!CACHE[$source])
			{
				if(!LOADS[$source])
				{
					var loader:Loader = new Loader;
					loader.contentLoaderInfo.addEventListener(Event.COMPLETE, loader_defaultHandler);
					loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, loader_defaultHandler);
					loader.load(new URLRequest($source));
					LOADS[$source] = loader;
					URLS[loader] = $source;
				}
				
				
			}
			return CACHE[$source];
		}
		
		
		/**
		 * @private
		 */
		private static function loader_defaultHandler($e:Event):void
		{
			var info:LoaderInfo = $e.target as LoaderInfo;
			info.removeEventListener(Event.COMPLETE, loader_defaultHandler);
			info.removeEventListener(IOErrorEvent.IO_ERROR, loader_defaultHandler);
			
			if ($e.type == Event.COMPLETE)
			{
				var loader:Loader = info.loader;
				var url:String = URLS[loader];
				delete LOADS[url];
				delete URLS[loader];
				CACHE[url] = (info.content as Bitmap).bitmapData;
			}
		}
		
		
		/**
		 * @private
		 */
		private static const CACHE:Object = {};
		
		/**
		 * @private
		 */
		private static const LOADS:Object = {};
		
		/**
		 * @private
		 */
		private static const URLS:Dictionary = new Dictionary;
		
	}
}