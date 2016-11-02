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
	import editor.core.MDConfig;
	import editor.core.MDProvider;
	import editor.core.MDVars;
	import editor.views.Debugger;
	import editor.views.PageSelector;
	import editor.views.components.CanvasItem;
	import editor.views.properties.PropertyItem;
	import editor.vos.Component;
	import editor.vos.Sheet;

	
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
		 * @param $sheet  : 需要修改的页面。默认值为null。注意：一般情况下无需设定该参数，仅用于撤销机制。
		 * 
		 */
		
		public static function limitSheetComponents($change:Number, $state:String, $sheet:Sheet = null):void
		{
			var dic:Map = content.itemsMap;
			
			var coor:String = STATE_OBJ[$state][0];
			var prop:String = STATE_OBJ[$state][1];
			var tempP:Number;
			var tempC:Number;
			if (!MDConfig.instance.isLayoutOpened)
			{
				for each(var item:CanvasItem in dic)
				{
					tempP = Math.max(1, Math.round(item[prop] * $change));
					tempC = Math.round(item[coor] * $change);
					var scope:Object = {};
					scope[prop] = tempP;
					scope[coor] = tempC;
					CommandUtil.edtComponent(item.component, scope, false);
				}
				content.update();
			}
			else
			{
				var sheet:Sheet = $sheet || MDConfig.instance.selectedSheet;
				for each (var component:Component in sheet.componentsMap)
				{
					tempP = Math.max(1, Math.round(component[prop] * $change));
					tempC = Math.round(component[coor] * $change);
					var obj:Object = {};
					obj[prop] = tempP;
					obj[coor] = tempC;
					CommandUtil.edtComponent(component, obj, false);
				}
			}
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