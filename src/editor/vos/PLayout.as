package editor.vos
{
	
	/**
	 * 
	 * 页面集数据结构。
	 * 
	 */
	
	
	import cn.mvc.collections.Map;
	import cn.mvc.utils.ArrayUtil;
	import cn.mvc.utils.MathUtil;
	
	import editor.commands.EdtPageHomeCommand;
	import editor.commands.EdtSheetCommand;
	import editor.core.MDPresenter;
	import editor.core.MDVars;
	import editor.core.ed;
	import editor.utils.TabUtil;
	import editor.views.Debugger;
	
	import mx.messaging.management.Attribute;
	
	
	[Bindable]
	public final class PLayout extends _InternalVO
	{
		
		/**
		 * 
		 * 构造函数。
		 * 
		 */
		
		public function PLayout($data:Object = null, $name:String = "layout")
		{
			super($data, $name);
		}
		
		
		/**
		 * 
		 * 添加元素。
		 * 
		 */
		
		public function addComponent($sheet:Sheet, $component:Component, $order:Boolean = false):Array
		{
			if ($sheet && $component && !components[$component.id])
			{
				components[$component.id] = $component;
				var result:Array = $sheet.ed::addComponent($component, $order);
			}
			return result;
		}
		
		
		/**
		 * 
		 * 删除元素。
		 * 
		 */
		
		public function delComponent($sheet:Sheet, $component:Component):Array
		{
			if ($sheet && $component && components[$component.id])
			{
				delete components[$component.id];
				
				var result:Array = $sheet.ed::delComponent($component);
			}
			return result;
		}
		
		
		/**
		 * 
		 * 删除所有组件 
		 * 
		 */
		public function delAllComponent($sheet:Sheet):void
		{
			if($sheet)
			{
				for each(var $component:Component in $sheet.componentsArr)
				{
					delete components[$component.id];
				}
				
				$sheet.componentsMap.clear();
				$sheet.componentsArr.splice(0);
			}
		}
		
		
		/**
		 * 
		 * 更改元素顺序。
		 * 
		 */
		
		public function ordComponent($sheet:Sheet, $component:Component, $order:uint):Array
		{
			if ($sheet && $component)
				var result:Array = $sheet.ed::ordComponent($component, $order);
			return result;
		}
		
		public function ordPage($page:Page, $order:uint):Array
		{
			return $page ? ($page.parent ? $page.parent.ed::ordPage($page, $order) : 
				this.ed::ordPage($page, $order)) : null;
		}
		
		/**
		 * 
		 * 添加子页。
		 * 
		 */
		
		public function addPage($page:Page, $parent:Page = null, $order:Boolean = false):Array
		{
			if ($page && !pages[$page.id])
			{
				var result:Array;
				$page.parent = $parent;
				result = $parent ? $parent.ed::addPage($page, true) :
					ed::addChild($page, $order);
				pages [$page.id] = $page;
				sheets[$page.id] = $page;
				
				if (home)
					$page.home = false;
				else
					if ($page.home) home = $page;
			}
			return result;
		}
		
		
		/**
		 * 
		 * 更换页面父级。
		 * 
		 */
		
		public function altPage($page:Page, $parent:Page = null, $index:uint = uint.MAX_VALUE):Array
		{
			if ($page)
			{
				if ($page.parent != $parent)
				{
						var arrDel:Array = ed::delChild($page);
						$page.parent = $parent ? $parent : null;
						$page.order = $index;
						
						var arrAdd:Array = ed::addChild($page, true);
						if ($parent) $parent.expand = true;
						
						if (home == $page) MDPresenter.instance.execute(new EdtPageHomeCommand($page, children[0], false));
						var result:Array;
						
						result = arrAdd ? (arrDel ? arrDel.concat(arrAdd) : arrAdd) : (arrDel ? arrDel : null);
				}//if ($page.parent != $parent)
			}//if ($page)
			return result;
		}
		
		/**
		 * 
		 * 是否是第一次进入
		 * 
		 */
		private static var isFirst:Boolean = true;
		
		/**
		 * 
		 * 存放push在comboBox内的Page
		 * 
		 */
		private var comboArr:Array = [];

		/**
		 * 
		 * 存放未push在comboBox内的Page
		 * 
		 */
		private var tabArr:Array = [];
		
		/**
		 * 
		 * 遍历页面的子页面 并按照是否push进comboBox进行分类
		 * 
		 */
		private function loopTree($page:Page):void
		{
			var length:int = $page.pagesArr.length;
			if (MDVars.instance.titleBar.comboBox && included($page)) 
			{
				comboArr.push($page);
			}
			else
			{
				tabArr.push($page);
			}
			for (var i:int = 0; i < length; i++)
			{
				loopTree($page.pagesArr[i]);
			}
		}
		
		
		private function included($page:Page):Boolean
		{
			for each (var tab:Object in MDVars.instance.titleBar.comboBox.dataProvider)
			{
				if (tab["tab"] == TabUtil.sheet2Tab($page)) return true;
			}
			return false;
		}
		
		
		/**
		 * 
		 * 临时存放返回结果
		 * 
		 */
		private var _result:Array;
		
		/**
		 * 
		 * 删除目标页面ID
		 * 
		 */
		private var targetDelId:String;
		
		/**
		 * 
		 * 删除子页。
		 * 
		 */
		
		public function delPage($page:Page):Array
		{
			if (isFirst)
			{
				isFirst = false;
				_result = [];
				targetDelId = $page.id;
				loopTree($page);
				for (var i:int = 0; i < comboArr.length; i++)
				{
					delPage(comboArr[i]);
				}
				comboArr = [];
				for (var j:int = 0; j < tabArr.length; j++)
				{
					delPage(tabArr[j]);
				}
				tabArr   = [];
				isFirst  = true;
				$page = null;
			}
			
			if ($page && pages[$page.id])
			{
				if ($page.id != targetDelId)
				{
					$page.parent
						? $page.parent.ed::delPage($page)
						: ed::delChild($page);
				}
				else 
				{
					_result = $page.parent
						? $page.parent.ed::delPage($page)
						: ed::delChild($page);
				}
				delete pages [$page.id];
				delete sheets[$page.id];
				
				if (home == $page) 
				{
					home = children[0];
					MDPresenter.instance.execute(new EdtPageHomeCommand($page, home, false));
				}
				
				
				if (TabUtil.sheet2Tab($page))
					TabUtil.sheet2Tab($page).closePage();
			}
			return _result;
		}
		
		
		/**
		 * 
		 * 添加子页面项。
		 * 
		 */
		
		ed function addChild($child:Page, $order:Boolean = false):Array
		{
			if ($child) 
			{
				var arrayTemp:Array = $child.parent ? $child.parent.pagesArr : children;
				var order:uint = MathUtil.clamp($child.order, 0, arrayTemp.length);
				arrayTemp.splice(order, 0, $child);
				if ($order) var result:Array = ed::updateOrder(arrayTemp);
			}
			return result;
		}
		
		
		/**
		 * 
		 * 删除子页面项。
		 * 
		 */
		
		ed function delChild($child:Page):Array
		{
			if ($child)
			{
				var arrayTemp:Array = $child.parent ? $child.parent.pagesArr : children;
				if (arrayTemp[$child.order] == $child)
					arrayTemp.splice($child.order, 1);
				var result:Array = ed::updateOrder(arrayTemp);
			}
 			return result;
		}
		
		
		
		ed function ordPage($child:Page, $order:uint):Array
		{
			if ($child)
			{
				var arrayTemp:Array = $child.parent ? $child.parent.pagesArr : children;
				var order:uint = MathUtil.clamp($order, 0, arrayTemp.length - 1);
				if ($child.order != order)
				{
					ArrayUtil.order(arrayTemp, $child.order, $order);
					var result:Array = ed::updateOrder(arrayTemp);
				}
			}
			return result;
		}
		
		
		/**
		 * 
		 * 更新顺序。
		 * 只push改变了order的那些item。
		 * 只对子类进行改变
		 * 
		 */
		
		ed function updateOrder($array:Array):Array
		{
			var l:uint = $array.length;
			var result:Array, i:uint;
			for (i = 0; i < l; i++) 
			{
				if ($array[i].order != i)
				{
					result = result || [];
					$array[i].order = i;
					ArrayUtil.push(result, $array[i]);
				}
			}
				
			return result;
		}
		
		
		/**
		 * 
		 * 按序排列。
		 * 
		 */
		
		ed function arrangeOrder():void
		{
			ArrayUtil.normalize(children);
			
			children.sortOn("order", Array.NUMERIC);
			
			ed::updateOrder(children);
		}
		
		
		/**
		 * @private
		 */
		private function isSub($page:Page, $parent:Page):Boolean
		{
			var temp:Page = $page && $page.parent;
			while (temp && temp != $parent) temp = temp.parent;
			return (temp && temp == $parent);
		}
		
		
		
		/**
		 * 
		 * 首页。
		 * 
		 */
		
		public function get home():Page
		{
			return ed::home;
		}
		
		/**
		 * @private
		 */
		public function set home($value:Page):void
		{
			lastHome = home;
			ed::home = $value;
			if (lastHome) lastHome.home = false;
			if (home) home.home = true;
		}
		
		private var lastHome:Page;
		
		
		/**
		 * 
		 * 节目ID。
		 * 
		 */
		
		public function get programID():String
		{
			return getProperty("programId");
		}
		
		
		/**
		 * 
		 * 节目名称。
		 * 
		 */
		
		public function get programName():String
		{
			return getProperty("programName");
		}
		
		
		/**
		 * 
		 * 版面默认分辨率宽度。
		 * 
		 */
		
		public function get defaultWidth():Number
		{
			return getProperty("defaultWidth", Number);
		}
		
		
		/**
		 * 
		 * 版面默认分辨率高度。
		 * 
		 */
		
		public function get defaultHeight():Number
		{
			return getProperty("defaultHeight", Number);
		}
		
		
		/**
		 * 
		 * 子级对父级页面切换形式。
		 * 
		 */
		
		public function get b2t():String
		{
			return getProperty("b2t");
		}
		
		/**
		 * @private
		 */
		public function set b2t($value:String):void
		{
			setProperty("b2t", $value);
		}
		
		
		/**
		 * 
		 * 父级对子级页面切换形式。
		 * 
		 */
		
		public function get t2b():String
		{
			return getProperty("t2b");
		}
		
		/**
		 * @private
		 */
		public function set t2b($value:String):void
		{
			setProperty("t2b", $value);
		}
		
		
		/**
		 * 
		 * 同一级别页面切换形式。
		 * 
		 */
		
		public function get vis():String
		{
			return getProperty("vis");
		}
		
		/**
		 * @private
		 */
		public function set vis($value:String):void
		{
			setProperty("vis", $value);
		}
		
		
		/**
		 * 
		 * 域。
		 * 
		 */
		
		public function get domain():String
		{
			return getProperty("domain");
		}
		
		/**
		 * @private
		 */
		public function set domain($value:String):void
		{
			setProperty("domain", $value);
		}
		
		
		/**
		 * 
		 * 一级页面数组。
		 * 
		 */
		
		public function get children():Array
		{
			return ed::children;
		}
		
		
		/**
		 * 
		 * 广告数据。
		 * 
		 */
		
		public var ad:AD;
		
		
		/**
		 * 
		 * 元素类型数组。
		 * 
		 */
		
		public var componentTypesArr:Array = [];
		
		
		/**
		 * 
		 * 元素类型集合。
		 * 
		 */
		
		public var componentTypesMap:Map = new Map;
		
		
		/**
		 * 
		 * 页面集合。
		 * 
		 */
		
		public var pages:Map = new Map;
		
		
		/**
		 * 
		 * 版面集合。
		 * 
		 */
		
		public var sheets:Map = new Map;
		
		
		/**
		 * 
		 * 元素集合。
		 * 
		 */
		
		public var components:Map = new Map;
		
		
		/**
		 * @private
		 */
		ed var children:Array = [];
		
		/**
		 * @private
		 */
		ed var home:Page;
		
	}
}