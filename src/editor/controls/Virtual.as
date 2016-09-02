package editor.controls
{
	
	/**
	 * 
	 * 临时虚拟图像。
	 * 
	 */
	
	
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	
	import spark.components.Image;
	
	
	public final class Virtual extends Image
	{
		
		/**
		 * 
		 * 构造函数。
		 * 
		 */
		
		public function Virtual()
		{
			super();
			
			mouseChildren = mouseEnabled = false;
		}
		
		/**
		 * @inheritDoc
		 */
		
		override public function set source($value:Object):void
		{
			if ($value)
			{
				var displayObject:DisplayObject = $value as DisplayObject;
				if (displayObject)
				{
					var bmd:BitmapData = new BitmapData(displayObject.width, displayObject.height, true, 0);
					bmd.draw(displayObject);
					super.source = bmd;
				}
			}
		}
		
	}
}