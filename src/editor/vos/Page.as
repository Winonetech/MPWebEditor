package editor.vos
{
	
	/**
	 * 
	 * 页面版面数据结构。
	 * 
	 */
	
	
	import cn.mvc.collections.Map;
	import cn.mvc.utils.ArrayUtil;
	import cn.mvc.utils.IDUtil;
	import cn.mvc.utils.MathUtil;
	import cn.mvc.utils.StringUtil;
	
	import editor.core.MDVars;
	import editor.core.ed;
	import editor.views.sheets.PageItem;
	
	
	[Bindable]
	public final class Page extends Sheet
	{
		
		/**
		 * 
		 * 构造函数。
		 * 
		 */
		
		public function Page($data:Object = null, $name:String = "page")
		{
			super($data, $name);
		}
		
		
		/**
		 * 
		 * 更新页面顺序。
		 * 改变其order
		 */
		
		ed function updatePagesOrder():Array
		{
			const l:uint = pagesArr.length;
			var result:Array, i:uint;
			for (i = 0; i < l; i++) 
			{
				if (pagesArr[i].order != i)
				{
					result = result || [];
					pagesArr[i].order = i;
					ArrayUtil.push(result, pagesArr[i]);
				}
			}
			return result;
		}
		
		
		/**
		 * 
		 * 页面按序排列。
		 * 
		 */
		
		ed function arrangePageOrder():void
		{
			ArrayUtil.normalize(pagesArr);
			
			pagesArr.sortOn("order", Array.NUMERIC);
			
			ed::updatePagesOrder();
		}
		
		
		/**
		 * 
		 * 添加子项。
		 * 
		 */
		
		ed function addPage($child:Page, $order:Boolean = false):Array
		{
			if ($child) 
			{
				const order:uint = MathUtil.clamp($child.order, 0, pagesArr.length);
				
				pagesMap[$child.id] = $child;
				pagesArr.splice(order, 0, $child);
				
				if ($order) var result:Array = ed::updatePagesOrder();
			}
			return result;
		}
		
		
		/**
		 * 
		 * 删除子项。
		 * 
		 */
		
		ed function delPage($child:Page):Array
		{
			if ($child) 
			{
				delete pagesMap[$child.id];
				if (pagesArr[$child.order] == $child)
				{
					pagesArr.splice($child.order, 1);
					$child.order = uint.MAX_VALUE;
				}
				
				var result:Array = ed::updatePagesOrder();
			}
			return result;
		}
		
		
		/**
		 * 
		 * 调整其子页面顺序。
		 * 
		 */
		
		ed function ordPage($child:Page, $order:uint):Array
		{
			if ($child)
			{
				var order:uint = MathUtil.clamp($order, 0, pagesArr.length - 1);
				if ($child.order != order)
				{
					ArrayUtil.order(pagesArr, $child.order, $order);
					var result:Array = ed::updatePagesOrder();
				}
			}
			return result;
		}
		
		
		/**
		 * 
		 * 是否允许缓动。
		 * 
		 */
		
		public function get tweenable():Boolean
		{
			return getProperty("tweenEnabled", Boolean);
		}
		
		/**
		 * @private
		 */
		public function set tweenable($value:Boolean):void
		{
			setProperty("tweenEnabled", $value);
		}
		
		
		/**
		 * 
		 * 顺序。
		 * 
		 */
		
		public function get order():uint
		{
			return getProperty("order", uint);
		}
		
		/**
		 * @private
		 */
		public function set order($value:uint):void
		{
			setProperty("order", $value);
		}
		
		
		/**
		 * 
		 * 是否为首页。
		 * 
		 */
		
		public function get home():Boolean
		{
			return getProperty("home", Boolean);
		}
		
		
		/**
		 * @private
		 */
		public function set home($value:Boolean):void
		{
			setProperty("home", $value);
		}
		

		/**
		 * 
		 * 父级ID。
		 * 
		 */
		
		public function get parentID():String
		{
			return data && data.parent ? data.parent.id : null;
		}
		
		/**
		 * @private
		 */
		public function set parentID($value:String):void
		{
			if (StringUtil.empty($value))
			{
				delete data["parent"];
			}
			else
			{
				data["parent"] = data["parent"] || {};
				data["parent"]["id"] = $value;
			}
		}
		
		
		/**
		 * 
		 * 布局ID。
		 * 
		 */
		
		public function get layoutID():String
		{
			return data && data.layout ? data.layout.id : null;
		}
		
		/**
		 * @private
		 */
		public function set layoutID($value:String):void
		{
			if (StringUtil.empty($value))
			{
				delete data["layout"];
			}
			else
			{
				data["layout"] = data["layout"] || {};
				data["layout"]["id"] = $value;
			}
		}
		
		
		/**
		 * 
		 * 页面层级。
		 * 
		 */
		
		public function get level():uint
		{
			if (ed::level == 0)
			{
				ed::level = 1;
				var temp:Page = parent;
				while (temp)
				{
					temp = temp.parent;
					ed::level++;
				}
			}
			return ed::level;
		}
		
		
		/**
		 * 
		 * 父级页面数据结构引用。
		 * 
		 */
		
		public function get parent():Page
		{
			return ed::parent;
		}
		
		/**
		 * @private
		 */
		public function set parent($value:Page):void
		{
			ed::parent = $value;
			ed::level = 0;
		}
		
		
		/**
		 * 
		 * 子页面数组。
		 * 
		 */
		
		public function get pagesArr():Array
		{
			return ed::pagesArr;
		}
		
		
		/**
		 * 
		 * 子页面集合。
		 * 
		 */
		
		public function get pagesMap():Map
		{
			return ed::pagesMap;
		}
		
		
		/**
		 * 
		 * 是否展开。
		 * 
		 */
		
		public var expand:Boolean;
		
		public var expandable:Boolean;
		
		
		/**
		 * 是否为模版
		 */
		public var template:Boolean;
		
		/**
		 * @private
		 */
		ed var level:uint = 0;
		/**
		 * @private
		 */
		ed var parent:Page;
		
		/**
		 * @private
		 */
		ed var pagesArr:Array = [];
		
		/**
		 * @private
		 */
		ed var pagesMap:Map = new Map;
		
	}
}