package editor.utils
{
	import cn.mvc.core.NoInstance;
	
	import editor.views.properties.PropertyItem;
	import editor.views.sheets.Layout_PageItem;
	import editor.views.sheets.PageItem;
	import editor.vos.Page;
	
	import mx.controls.Alert;
	
	public class PageUtil extends NoInstance
	{
		
		
		/**
		 * 
		 * 判定点击的元素是否为Layout_PageItem或Layout_PageItem的子元素。
		 * 
		 * @param $page:* 要判断的元素。
		 * 
		 * @return Layout_PageItem 如果是，则返回对应的Layout_PageItem，如果不是，则返回null。
		 * 
		 */
		
		public static function convertPageItem($page:*):Layout_PageItem
		{
			var result:Boolean = $page is Layout_PageItem;
			if ($page != null)
				return result ? $page : convertPageItem($page.parent);
			else return null;
		}
		
		
		
		/**
		 * 
		 * Page数组的排序。排序规则为order从小至大。
		 * @param $arr:Array 元素必须含有order字段。
		 * @return 排序后的数组。
		 * 
		 */
		
		public static function sortByOrder($arr:Object):Array
		{
			var result:Array = [];
			if ($arr is Array) 
			{
				var compare:Function = function(a:Object, b:Object):int
				{
					return a.order > b.order ? 1 : (a.order < b.order ? -1 : 0);
				};
				
				result = $arr as Array;
				result = result.sort(compare);
			}
			return result;
		}
		
		
		/**
		 * 
		 * 判定$selected是否允许添加到$container中。
		 * 
		 */
		public static function isAllowAdd($selected:Page, $container:Page):Boolean
		{
			var result:Boolean;
			var tempS:Page;
			var tempC:Page;
			if ($selected)
			{
				if ($container)
				{
					if ($selected.parent == $container) return false;
					tempS = $selected;
					tempC = $container.parent;
					while (tempS != tempC)
					{
						if (tempC == null)
						{
							result = true;
							break;
						}
						tempC = tempC.parent;
					}
				}
				else
				{
					result = true;
				}
			}
			if (!result) Alert.show("“" + $container.label + "” 页面是" + " “" + $selected.label + "” 页面的子级，不能调换！");
			return result;
		}
	}
}