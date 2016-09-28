package editor.views.sheets
{
	
	import editor.core.ed;
	import editor.managers.ImageManager;
	import editor.views.Debugger;
	import editor.vos.Page;
	
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.utils.Timer;
	
	import mx.core.UIComponent;
	import mx.graphics.SolidColor;
	
	import spark.components.Group;
	import spark.components.Image;
	import spark.components.Label;
	import spark.primitives.Rect;
	
	public class Layout_PageItem extends Group
	{
		public function Layout_PageItem()
		{
			super();
			
			back = new Rect;
			back.fill = new SolidColor(0xCCCCCC, .3);
			addElement(back);
		}
		
		/**
		 * 
		 * 更新视图。
		 * 
		 */
		
		public function update():void
		{
			updateLayout();
			updateSource();
		}
		
		
		/**
		 * @private
		 */
		private function updateLayout():void
		{
			x = page.x;
			y = page.y;
			width  = page.width;
			height = page.height;
		}
		
		/**
		 * @private
		 */
		private function updateSource():void
		{
			updateBack();
			
			updateIcon();
			
			updateContent();
		}
		
		/**
		 * @private
		 */
		private function updateBack():void
		{
			back.width  = width;
			back.height = height;
		}
		
		/**
		 * @private
		 */
		private function updateIcon():void
		{
			if (icon) 
			{
				if (containsElement(icon)) removeElement(icon);
				icon = null;
			}
			icon = new Image;
			addElement(icon);
			icon.smooth = true;
			icon.visible = false;
			icon.mouseEnabled = false;
			var bmd:BitmapData = ImageManager.retrieveBitmapData("flash/cache/assets/images/background.png");
			if (bmd)
			{
				icon.visible = true;
				icon.source = bmd;
				icon.maxWidth  = bmd.width;
				icon.maxHeight = bmd.height;
				resizeIcon();
			}
			else
			{
				var handler:Function = function(e:Event):void
				{
					icon.removeEventListener(Event.COMPLETE, handler);
					icon.removeEventListener(IOErrorEvent.IO_ERROR, handler);
					if (e.type == Event.COMPLETE)
					{
						icon.visible = true;
						icon.maxWidth  = icon.bitmapData.width;
						icon.maxHeight = icon.bitmapData.height;
						resizeIcon();
					}
				};
				icon.addEventListener(Event.COMPLETE, handler);
				icon.addEventListener(IOErrorEvent.IO_ERROR, handler);
				icon.source = "flash/cache/assets/images/background.png";
			}
		}
		
		/**
		 * @private
		 */
		private function updateContent():void
		{
				if (contentLabel)
				{
					if (containsElement(contentLabel)) removeElement(contentLabel);
					contentLabel = null;
				}
				contentLabel = new Label;
				addElement(contentLabel);
				contentLabel.toolTip = contentLabel.text = page.label;
				contentLabel.setStyle("color", 0);
				contentLabel.setStyle("fontSize", 30);
				contentLabel.maxWidth = width;
				contentLabel.maxHeight = height;
				resizeLabel();
		}
		
		
		
		/**
		 * @private
		 */
		private function resizeIcon():void
		{
			if (icon)
			{
				icon.width  = Math.min(width , icon.maxWidth);
				icon.height = Math.min(height, icon.maxHeight);
				icon.x = .5 * (width  - icon.width);
				icon.y = .5 * (height - icon.height);
			}
		}
		
		/**
		 * @private
		 */
		private function resizeLabel():void
		{
			if (contentLabel)
			{
				var scale:Number = Math.min(Math.min(1, (width  - 20) / 50), Math.min(1, (height - 20) / 50));
				contentLabel.scaleX = contentLabel.scaleY = scale;
				contentLabel.horizontalCenter = "0";
				contentLabel.verticalCenter   = "0";
			}
		}
		
		
		
		/**
		 * @private
		 */
		private function resizeAll():void
		{
			updateBack();
			
			resizeIcon();
			
			resizeLabel();
		}
		
		
		
		/**
		 * @inheritDoc
		 */
		
		override public function set width($value:Number):void
		{
			super.width = int($value);
			
			resizeAll();
		}
		
		
		/**
		 * @inheritDoc
		 */
		
		override public function set height($value:Number):void
		{
			super.height = int($value);
			
			resizeAll();
		}
		
		/**
		 * 
		 * 元素数据。
		 * 
		 */
		
		[Bindable]
		public function get page():Page
		{
			return ed::page;
		}
		
		public function set page($value:Page):void
		{
			ed::page = $value;
			update();
		}
		
		
		/**
		 * @inheritDoc
		 */
		
		override public function set x($value:Number):void
		{
			super.x = int($value);
		}
		
		
		/**
		 * @inheritDoc
		 */
		
		override public function set y($value:Number):void
		{
			super.y = int($value);
		}
		
		
		/**
		 * @private
		 */
		private var icon:Image;
		
		/**
		 * @private
		 */
		private var ui:UIComponent;
		
		/**
		 * @private
		 */
		private var back:Rect;
		
		/**
		 * @private
		 */
		public var contentLabel:Label;
		
		/**
		 * @private
		 */
		private var timer:Timer = new Timer(250, 1);
		
		
		
		/**
		 * @private
		 */
		ed var page:Page;
		
		
	}
}