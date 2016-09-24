package editor.utils
{
	
	/**
	 * 
	 * 数据结构常用工具。
	 * 
	 */
	
	
	import cn.mvc.collections.Map;
	import cn.mvc.core.NoInstance;
	
	import editor.controls.MDFlash;
	import editor.core.MDProvider;
	import editor.core.MDVars;
	import editor.views.PageSelector;
	import editor.views.components.CanvasItem;
	import editor.views.properties.PropertyItem;

	
	public final class ComponentUtil extends NoInstance
	{
		
		/**
		 * 
		 * 判定点击的元素是否为CanvasItem或CanvasItem的子元素。
		 * 
		 * @param $component:* 要判断的元素。
		 * 
		 * @return CanvasItem 如果是，则返回对应的CanvasItem，如果不是，则返回null。
		 * 
		 */
		
		public static function convertCanvasItem($component:*):CanvasItem
		{
			var result:Boolean = $component is CanvasItem;
			if ($component != null)
				return result ? $component : convertCanvasItem($component.parent);
			else return null;
		}
		
		
		/**
		 * 
		 * 组件属性修正函数。
		 * 
		 * @param $value     : 修正值。
		 * @param $border    : 该修正值对应类型的边界（最大）值。
		 * 
		 */
		
		public static function reviseComponent($value:int, $border:int):int
		{
			return $value < 0 ? 0 : ($value > $border ? $border : $value);
		}
		
		
		/**
		 * 
		 * 因版面宽高改变而修改组件布局
		 * 
		 * @param $change : 缩放比例因子（改变后的值  / 改变前的值）
		 * @param $state  : 页面改变的属性。可能值为："width"或"height"
		 * 
		 */
		
		public static function limitSheetComponents($change:Number, $state:String):void
		{
			var dic:Map = content.itemsMap;
			
			var coor:String = STATE_OBJ[$state][0];
			var prop:String = STATE_OBJ[$state][1];
			
			for each(var item:CanvasItem in dic)
			{
				item.component[prop] = Math.max(1, Math.round(item[prop] * $change));
				item.component[coor] = Math.round(item[coor] * $change);
				var scope:Object = {};
				scope[coor] = item.component[coor];
				scope[prop] = item.component[prop];
				CommandUtil.edtComponent(item.component, scope);
			}
			content.update();
		}//function
		
		
		/**
		 * 
		 * 显示选择页面弹出面板。
		 * 
		 * @param $item:PropertyItem 显示页面选择框。
		 * 
		 */
		
		public static function showPageSelector($item:PropertyItem):void
		{
			if(!vars.selector)
			{
				vars.selector = new PageSelector;
				vars.selector.program = MDProvider.instance.program;
			}
			else
			{
				vars.selector.update();
			}
			vars.selector.show($item, vars.application);
		}
		
		
		/**
		 * 
		 * 根据属性类型获取组件。
		 * 
		 * @param $type:String
		 * 
		 */
		
		public static function getComponentByCode($type:String):Class
		{
			return CODE_COMPONENT[$type];
		}
		
		
		/**
		 * @private
		 */
		private static function get vars():MDVars
		{
			return MDVars.instance;
		}
		
		/**
		 * @private
		 */
		private static function get content():*
		{
			return vars.canvas.content;
		}
		
		
		/**
		 * @private
		 */
		private static const CODE_COMPONENT:Object = 
		{
			image: editor.controls.MDImage, 
			text : editor.controls.MDText, 
			video: editor.controls.MDVideo, 
			flash: editor.controls.MDFlash
		};
		
		/**
		 * @private
		 */
		private static const STATE_OBJ:Object = 
		{
			"width"  : ["x", "width"],
			"height" : ["y", "height"]
		};
		
	}	
}