package editor.views.sheets
{
	
	import editor.core.ed;
	import editor.vos.Page;
	
	import flash.utils.Timer;
	
	import mx.core.UIComponent;
	import mx.graphics.SolidColor;
	
	import spark.components.Group;
	import spark.components.Image;
	import spark.primitives.Rect;
	
	public class Layout_PageItem extends Group
	{
		public function Layout_PageItem()
		{
			super();
			
			back = new Rect;
			back.fill = new SolidColor(0xCCCCCC, .3);
			addElement(back);
			back.width = back.height = 800;
			var image:Image = new Image;
			image.width = image.height = 500;
			image.source = background;
			addElement(image);
		}
		/**
		 * @private
		 */
		[Embed(source="../../../flash/cache/assets/images/background.png")]
		private static const background:Class;
		
		/**
		 * 
		 * 更新视图。
		 * 
		 */
		
//		public function update():void
//		{
//			updateLayout();
//			updateSource();
//		}
		
		
		/**
		 * @private
		 */
//		private function updateLayout():void
//		{
//			x = component.x;
//			y = component.y;
//			width  = component.width;
//			height = component.height;
//		}
		
		/**
		 * @private
		 */
//		private function updateSource():void
//		{
//			updateBack();
//			
//			if(!updateProperty(componentProperty)) 
//			{
//				updateIcon();
//				
//				updateContent();
//			}
//		}
		
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
//		private function updateIcon():void
//		{
//			if (icon) 
//			{
//				if (containsElement(icon)) removeElement(icon);
//				icon = null;
//			}
//			if (componentType)
//			{
//				icon = new Image;
//				addElement(icon);
//				icon.setStyle("skinClass", editor.skins.ImageErrorSkin);
//				icon.smooth = true;
//				icon.visible = false;
//				icon.mouseEnabled = false;
//				var bmd:BitmapData = ImageManager.retrieveBitmapData(componentType.image);
//				if (bmd)
//				{
//					icon.visible = true;
//					icon.source = bmd;
//					icon.maxWidth  = bmd.width;
//					icon.maxHeight = bmd.height;
//					resizeIcon();
//				}
//				else
//				{
//					var handler:Function = function(e:Event):void
//					{
//						icon.removeEventListener(Event.COMPLETE, handler);
//						icon.removeEventListener(IOErrorEvent.IO_ERROR, handler);
//						if (e.type == Event.COMPLETE)
//						{
//							icon.visible = true;
//							icon.maxWidth  = icon.bitmapData.width;
//							icon.maxHeight = icon.bitmapData.height;
//							resizeIcon();
//						}
//					};
//					icon.addEventListener(Event.COMPLETE, handler);
//					icon.addEventListener(IOErrorEvent.IO_ERROR, handler);
//					icon.source = componentType.image;
//				}
//				
//			}
//		}
		
		/**
		 * @private
		 */
//		private function updateContent():void
//		{
//			if (AppUtil.isFillMode())
//			{
//				if (contentImage)
//				{
//					if (containsElement(contentImage)) removeElement(contentImage);
//					contentImage = null;
//				}
//				contentImage = new Image;
//				contentImage.source  = component.hasContent ? filledImage : emptyImage;
//				contentImage.toolTip = component.hasContent ? "已填充素材" : "未填充素材";
//				addElement(contentImage);
//				resizeImage();
//			}
//		}
		
		/**
		 * @private
		 */
//		private function updateProperty($property:Object):Boolean
//		{
//			if (ui)
//			{
//				if (containsElement(ui)) removeElement(ui);
//				ui = null;
//			}
//			if ($property)
//			{
//				if ($property is Array)
//				{
//					for each (var item:* in $property) 
//					if (updateProperty(item)) result = true;
//				}
//				else
//				{
//					if (componentTypeProperty && 
//						StringUtil.empty($property.value) == false && 
//						ObjectUtil.convert(componentTypeProperty["viewable"], Boolean))
//					{
//						var classRef:Class = ComponentUtil.getComponentByCode($property["type"]);
//						if (classRef)
//						{
//							var temp:ISource = (new classRef) as ISource;
//							
//							ui = temp as UIComponent;
//							if (ui)
//							{
//								var bmd:BitmapData = ImageManager.retrieveBitmapData($property.value);
//								temp.source = bmd ? bmd : $property.value;
//								addElement(ui);
//								
//								resizeUI();
//								var result:Boolean = true;
//							}
//						}
//					}
//				}
//			}
//			return result;
//		}
		
		
		/**
		 * @private
		 */
//		private function resizeIcon():void
//		{
//			if (icon)
//			{
//				icon.width  = Math.min(width , icon.maxWidth);
//				icon.height = Math.min(height, icon.maxHeight);
//				icon.x = .5 * (width  - icon.width);
//				icon.y = .5 * (height - icon.height);
//			}
//		}
//		
//		/**
//		 * @private
//		 */
//		private function resizeImage():void
//		{
//			if (contentImage)
//			{
//				var scale:Number = Math.min(Math.min(1, (width  - 20) / 50), Math.min(1, (height - 20) / 50));
//				
//				contentImage.scaleX = contentImage.scaleY = scale;
//				
//				contentImage.x = width  - 50 * scale;
//				contentImage.y = height - 50 * scale;
//			}
//		}
		
		/**
		 * @private
		 */
		private function resizeUI():void
		{
			if (ui)
			{
				ui.width  = width;
				ui.height = height;
			}
		}
		
		/**
		 * @private
		 */
//		private function resizeAll():void
//		{
//			updateBack();
//			
//			resizeIcon();
//			
//			resizeImage();
//			
//			resizeUI();
//		}
		
		
//		/**
//		 * @private
//		 */
//		private function component_doubleClickHandler($e:MouseEvent):void
//		{
//			if (timer.running)
//			{
//				dispatchEvent(new MouseEvent(MouseEvent.DOUBLE_CLICK));
//			}
//			else
//			{
//				timer.reset();
//				timer.start();
//			}
//		}
		
		
		/**
		 * @inheritDoc
		 */
		
//		override public function set width($value:Number):void
//		{
//			super.width = int($value);
//			
//			resizeAll();
//		}
		
		
		/**
		 * @inheritDoc
		 */
		
//		override public function set height($value:Number):void
//		{
//			super.height = int($value);
//			
//			resizeAll();
//		}
		
		
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
		private var contentImage:Image;
		
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