package editor.views.canvas
{
	
	/**
	 * 
	 * 网格。
	 * 
	 */
	
	
	import flash.display.Shape;
	
	import mx.core.UIComponent;
	
	
	public final class Grid extends UIComponent
	{
		
		/**
		 * 
		 * 构造函数。
		 * 
		 */
		
		public function Grid()
		{
			super();
			
			mouseChildren = mouseEnabled = false;
		}
		
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			drawGrid(width, height);
			
			updateScale();
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function createChildren():void
		{
			__scale = 1;
			
			alpha = .3;
			addChild(layer010 = new Shape);
			addChild(layer050 = new Shape);
			addChild(layer100 = new Shape);
			addChild(layer500 = new Shape);
			drawGrid();
			
			updateScale();
		}
		
		private function drawGrid(w:Number = 100, h:Number = 100):void
		{
			var i:int;
			with (layer010.graphics) {
				clear();
				lineStyle(.1, 0xCCCCCC);
				for (i=0;i<=h;i+=50) {
					moveTo(0, i);
					lineTo(w, i);
				}
				for (i=0;i<=w;i+=50) {
					moveTo(i, 0);
					lineTo(i, h);
				}
			}
			with (layer050.graphics) {
				clear();
				lineStyle(.1, 0xCCCCCC);
				for (i=0;i<=h;i+=100) {
					moveTo(0, i);
					lineTo(w, i);
				}
				for (i=0;i<=w;i+=100) {
					moveTo(i, 0);
					lineTo(i, h);
				}
			}
			with (layer100.graphics) {
				clear();
				lineStyle(.1, 0xCCCCCC);
				for (i=0;i<=h;i+=200) {
					moveTo(0, i);
					lineTo(w, i);
				}
				for (i=0;i<=w;i+=200) {
					moveTo(i, 0);
					lineTo(i, h);
				}
			}
			with (layer500.graphics) {
				clear();
				lineStyle(.1, 0xCCCCCC);
				for (i=0;i<=h;i+=1000) {
					moveTo(0, i);
					lineTo(w, i);
				}
				for (i=0;i<=w;i+=1000) {
					moveTo(i, 0);
					lineTo(i, h);
				}
			}
		}
		
		private function updateScale():void
		{
			//layer010.visible = (scale >=.5);
			//layer050.visible = (scale >=.2 && scale < .5)
			//layer100.visible = (scale < .2);
			//layer500.visible = (scale < .1);
		}
		
		
		/**
		 * 
		 * 缩放。
		 * 
		 */
		
		public function get scale():Number
		{
			return __scale;
		}
		
		/**
		 * @private
		 */
		public function set scale(value:Number):void
		{
			if (value==scale) return;
			
			__scale = value;
			updateScale();
		}
		
		/**
		 * @private
		 */
		private var __scale:Number = 1;
		
		/**
		 * @private
		 */
		private var layer010:Shape;
		
		/**
		 * @private
		 */
		private var layer050:Shape;
		
		/**
		 * @private
		 */
		private var layer100:Shape;
		
		/**
		 * @private
		 */
		private var layer500:Shape;
		
	}
}