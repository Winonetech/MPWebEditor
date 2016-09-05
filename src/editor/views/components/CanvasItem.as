package editor.views.components
{
	
	/**
	 * 
	 * 画布内容项。
	 * 
	 */
	
	
	import cn.mvc.interfaces.ISource;
	import cn.mvc.utils.ObjectUtil;
	import cn.mvc.utils.RectangleUtil;
	import cn.mvc.utils.StringUtil;
	
	import editor.core.MDConfig;
	import editor.core.ed;
	import editor.managers.ImageManager;
	import editor.skins.ImageErrorSkin;
	import editor.utils.ComponentUtil;
	import editor.vos.Component;
	import editor.vos.ComponentType;
	
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Timer;
	
	import mx.controls.HRule;
	import mx.core.UIComponent;
	
	import spark.components.Group;
	import spark.components.Image;
	import spark.components.Label;
	import spark.components.TextArea;
	
	
	public class CanvasItem extends Group
	{
		
		/**
		 * 
		 * 构造函数。
		 * 
		 */
		
		public function CanvasItem()
		{
			super();
			
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
		 * @inheritDoc
		 */
		
		override protected function createChildren():void
		{
			addElementAt(back, 0);
			
			mouseChildren = false;
			
			addEventListener(MouseEvent.CLICK, component_doubleClickHandler);
		}
		
		
		/**
		 * @private
		 */
		private function updateLayout():void
		{
			x = component.x;
			y = component.y;
			width  = component.width;
			height = component.height;
		}
		
		/**
		 * @private
		 */
		private function updateSource():void
		{
			updateBack();
			
			clearCurrent();
			
			if(!updateProperty(componentProperty)) updateIcon();
		}
		
		/**
		 * @private
		 */
		private function updateBack():void
		{
			if (back)
			{
				back.graphics.clear();
				back.graphics.beginFill(0xCCCCCC, .5);
				back.graphics.drawRect(0, 0, width, height);
				back.graphics.endFill();
			}
		}
		
		/**
		 * @private
		 */
		private function updateIcon():void
		{
			if (componentType)
			{
				addElement(icon = new Image);
				icon.setStyle("skinClass", editor.skins.ImageErrorSkin);
				icon.smooth = true;
				icon.visible = false;
				var bmd:BitmapData = ImageManager.retrieveBitmapData(componentType.image);
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
					icon.source = componentType.image;
				}
			}
			var label:Label = new Label;
			label.text = "youdongxi";
			label.setStyle("color", 0);
			label.setStyle("fontSize", 50);
			addElement(label);
		}
		
		/**
		 * @private
		 */
		private function updateProperty($property:Object):Boolean
		{
			var result:Boolean;
			if ($property)
			{
				if ($property is Array)
				{
					for each (var item:* in $property) 
						if (updateProperty(item)) result = true;
				}
				else
				{
					if (componentTypeProperty && 
						StringUtil.empty($property.value) == false && 
						ObjectUtil.convert(componentTypeProperty["viewable"], Boolean))
					{
						var classRef:Class = ComponentUtil.getComponentByCode($property["type"]);
						if (classRef)
						{
							var temp:ISource = (new classRef) as ISource;
							
							ui = temp as UIComponent;
							if (ui)
							{
								var bmd:BitmapData = ImageManager.retrieveBitmapData($property.value);
								temp.source = bmd ? bmd : $property.value;
								addElement(ui);
								
								resizeUI();
								result = true;
							}
						}
					}
				}
			}
			return result;
		}
		
		/**
		 * @private
		 */
		private function clearCurrent():void
		{
			while(numElements > 1) removeElementAt(1);
		}
		
		/**
		 * @private
		 */
		private function resizeBack():void
		{
			updateBack();
		}
		
		/**
		 * @private
		 */
		private function resizeIcon():void
		{
			if (icon && containsElement(icon))
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
		private function resizeUI():void
		{
			if (ui && containsElement(ui))
			{
				ui.width  = width;
				ui.height = height;
			}
		}
		
		/**
		 * @private
		 */
		private function resizeAll():void
		{
			updateBack();
			
			resizeIcon();
			
			resizeUI();
		}
		
		
		/**
		 * @private
		 */
		private function component_doubleClickHandler($e:MouseEvent):void
		{
			if (timer.running)
			{
				dispatchEvent(new MouseEvent(MouseEvent.DOUBLE_CLICK));
			}
			else
			{
				timer.reset();
				timer.start();
			}
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
		 * 
		 * 获取此元素的矩形占位。
		 * 
		 */
		
		public function get rect():Rectangle
		{
			return new Rectangle(x, y, width, height);
		}
		
		public function get center():Point
		{
			return RectangleUtil.getCenter(rect);
		}
		/**
		 * 
		 * 是否被选中。
		 * 
		 */
		
		public function get selected():Boolean
		{
			return component ? component.selected : false;
		}
		
		/**
		 * @private
		 */
		public function set selected($value:Boolean):void
		{
			if (component) component.selected = $value;
		}
		
		
		/**
		 * 
		 * 元素顺序。
		 * 
		 */
		
		public function get order():uint
		{
			return component ? component.order : 0;
		}
		
		
		/**
		 * 
		 * 元素类别引用。
		 * 
		 */
		
		public function get componentProperty():Object
		{
			return component ? component.property : null;
		}
		
		
		/**
		 * 
		 * 元素类别引用。
		 * 
		 */
		
		public function get componentTypeProperty():Object
		{
			return componentType ? componentType.property : null;
		}
		
		
		/**
		 * 
		 * 元素类别引用。
		 * 
		 */
		
		public function get componentType():ComponentType
		{
			return component ? component.componentType : null;
		}
		
		
		/**
		 * 
		 * 元素数据。
		 * 
		 */
		
		[Bindable]
		public function get component():Component
		{
			return ed::component;
		}
		
		/**
		 * @private
		 */
		public function set component($value:Component):void
		{
			ed::component = $value;
			
			update();
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
		private var back:UIComponent = new UIComponent;
		
		/**
		 * @private
		 */
		private var childrens:Array = [];
		
		/**
		 * @private
		 */
		private var timer:Timer = new Timer(250, 1);
		
		
		/**
		 * @private
		 */
		ed var component:Component;
		
	}
}