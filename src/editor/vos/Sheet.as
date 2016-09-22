package editor.vos
{
	
	/**
	 * 
	 * 版面数据结构基类。
	 * 
	 */
	
	
	import cn.mvc.collections.Map;
	import cn.mvc.utils.ArrayUtil;
	import cn.mvc.utils.IDUtil;
	import cn.mvc.utils.MathUtil;
	
	import editor.core.ed;
	
	
	[Bindable]
	public class Sheet extends _InternalVO
	{
		
		/**
		 * 
		 * 构造函数。
		 * 
		 */
		
		public function Sheet($data:Object = null, $name:String = "sheet")
		{
			super($data, $name);
		}
		
		
		/**
		 * 
		 * 更新顺序。
		 * 
		 */
		
		ed function updateComponentsOrder():Array
		{
			const l:uint = componentsArr.length;
			var result:Array, i:uint;
			for (i = 0; i < l; i++) 
			{
				if (componentsArr[i].order != i)
				{
					result = result || [];
					componentsArr[i].order = i;
					ArrayUtil.push(result, componentsArr[i]);
				}
			}
			return result;
		}
		
		
		/**
		 * 
		 * 按序排列。
		 * 
		 */
		
		ed function arrangeComponentsOrder():void
		{
			ArrayUtil.normalize(componentsArr);
			
			componentsArr.sortOn("order", Array.NUMERIC);
			
			ed::updateComponentsOrder();
		}
		
		
		/**
		 * 
		 * 添加元素。
		 * 
		 */
		
		ed function addComponent($component:Component, $order:Boolean = false):Array
		{
			if ($component)
			{
				const order:uint = MathUtil.clamp($component.order, 0, componentsArr.length);
				
				componentsMap[$component.id] = $component;
				componentsArr.splice(order, 0, $component);
				
				if ($order) var result:Array = ed::updateComponentsOrder();
			}
			return result;
		}
		
		
		/**
		 * 
		 * 删除子项。
		 * 
		 */
		
		ed function delComponent($component:Component):Array
		{
			if ($component)
			{
				delete componentsMap[$component.id];
				if (componentsArr[$component.order] == $component)
					componentsArr.splice($component.order, 1);
				var result:Array = ed::updateComponentsOrder();
			}
			return result;
		}
		
		
		/**
		 * 
		 * 调整组件顺序。
		 * 
		 */
		
		ed function ordComponent($component:Component, $order:uint):Array
		{
			if ($component)
			{
				var order:uint = MathUtil.clamp($order, 0, componentsArr.length - 1);
				if ($component.order != order)
				{
					ArrayUtil.order(componentsArr, $component.order, $order);
					var result:Array = ed::updateComponentsOrder();
				}
			}
			return result;
		}
		
		
		/**
		 * 
		 * 名称。
		 * 
		 */
		
		public function get label():String
		{
			return getProperty("label");
		}
		
		/**
		 * @private
		 */
		public function set label($value:String):void
		{
			setProperty("label", $value);
		}
		
		
		/**
		 * 
		 * 背景颜色。
		 * 
		 */
		
		public function get backgroundColor():String
		{
			return getProperty("backgroundColor");
		}
		
		public function set backgroundColor($value:String):void
		{
			setProperty("backgroundColor", $value);
		}
		
		
		/**
		 * 
		 * 背景图片。
		 * 
		 */
		
		public function get background():String
		{
			return getProperty("background");
		}
		
		public function set background($value:String):void
		{
			setProperty("background", $value);
		}
		
		/**
		 * 
		 * h。
		 * 
		 */
		
		public function get height():Number
		{
			var r:Number = getProperty("height", Number);
			return isNaN(r) ? 0 : r;
		}
		
		/**
		 * @private
		 */
		public function set height($value:Number):void
		{
			setProperty("height", $value);
		}
		
		
		/**
		 * 
		 * w。
		 * 
		 */
		
		public function get width():Number
		{
			var r:Number = getProperty("width", Number);
			return isNaN(r) ? 0 : r;
		}
		
		/**
		 * @private
		 */
		public function set width($value:Number):void
		{
			setProperty("width", $value);
		}
		
		
		/**
		 * 
		 * x。
		 * 
		 */
		
		public function get x():Number
		{
			var r:Number = getProperty("coordX", Number);
			return isNaN(r) ? 0 : r;
		}
		
		/**
		 * @private
		 */
		public function set x($value:Number):void
		{
			setProperty("coordX", $value);
		}
		
		
		/**
		 * 
		 * y。
		 * 
		 */
		
		public function get y():Number
		{
			var r:Number = getProperty("coordY", Number);
			return isNaN(r) ? 0 : r;
		}
		
		/**
		 * @private
		 */
		public function set y($value:Number):void
		{
			setProperty("coordY", $value);
		}
		
		
		/**
		 * 
		 * 元素数组。
		 * 
		 */
		
		public function get componentsArr():Array
		{
			return ed::componentsArr;
		}
		
		
		/**
		 * 
		 * 元素集合。
		 * 
		 */
		
		public function get componentsMap():Map
		{
			return ed::componentsMap;
		}
		
		
		/**
		 * 
		 * 是否选中。
		 * 
		 */
		
		public var selected:Boolean;
		
		
		/**
		 * 
		 * 是否在编辑。
		 * 
		 */
		
		public var editing:Boolean;
		
		
		/**
		 * @private
		 */
		ed var componentsArr:Array = [];
		
		/**
		 * @private
		 */
		ed var componentsMap:Map = new Map;
		
	}
}