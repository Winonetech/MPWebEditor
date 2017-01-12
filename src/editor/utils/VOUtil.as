package editor.utils
{
	
	/**
	 * 
	 * 数据结构常用工具。
	 * 
	 */
	
	
	import cn.mvc.core.NoInstance;
	import cn.mvc.utils.IDUtil;
	import cn.mvc.utils.StringUtil;
	
	import editor.core.MDProvider;
	import editor.vos.AD;
	import editor.vos.Component;
	import editor.vos.Page;
	
	
	public final class VOUtil extends NoInstance
	{
		
		/**
		 * 
		 * 创建一个新的广告版面数据。
		 * 
		 * @param $x:Number (default = 0) 版面X坐标。
		 * @param $y:Number (default = 0) 版面Y坐标。
		 * @param $w:Number (default = 1920) 版面宽度。
		 * @param $h:Number (default = 1080) 版面高度。
		 * 
		 */
		
		public static function createAD(
			$x:Number = 0, 
			$y:Number = 0, 
			$w:Number = 1920, 
			$h:Number = 1080
		):AD
		{
			return new AD({
				"id" : IDUtil.generateID("ad"),
				"label" : "广告",
				"coordX": $x, 
				"coordY": $y, 
				"width" : $w, 
				"height": $h, 
				"waitTime": 30,
				"backgroundColor": "#FFFFFF",
				"adEnabled": true
			});
		}
		
		
		/**
		 * 
		 * 创建一个新的版面数据。
		 * 
		 * @param $parentID:String (default = null) 父级页面ID，为空时代表顶级页面。
		 * @param $layoutID:String (default = null) 布局ID。
		 * @param $order:uint (default = uint.MAX_VALUE) 页面顺序。
		 * @param $x:Number (default = 0) 页面X坐标。
		 * @param $y:Number (default = 0) 页面Y坐标。
		 * @param $w:Number (default = 1920) 页面宽度。
		 * @param $h:Number (default = 1080) 页面高度。
		 * @param $label:String (default = null) 页面名字。
		 * 
		 */
		
		public static function createPage(
			$parentID:String = null, 
			$layoutID:String = null,
			$order:uint = uint.MAX_VALUE, 
			$x:Number = 0, 
			$y:Number = 0, 
			$w:Number = 1920, 
			$h:Number = 1080,
			$bcg:String = null,
			$label:String = null):Page
		{
			var id:uint = IDUtil.generateID("page");
			var page:Page = new Page({
				"label": $label || "新建页面" + id, 
				"order": $order, 
				"coordX": $x, 
				"coordY": $y, 
				"width" : $w, 
				"height": $h, 
				"backgroundColor": $bcg || "#FFFFFF",
				"tweenEnabled": true
			});
			StringUtil.empty($parentID)
				? page.layoutID = $layoutID
				: page.parentID = $parentID;
			return page;
		}
		
		
		/**
		 * 
		 * 创建一个新的元素数据。
		 * 
		 * @param $sheetID:String 版面ID，版面可以是广告或页面。
		 * @param $componentTypeID:String 布局ID。
		 * @param $order:uint (default = uint.MAX_VALUE) 页面顺序。
		 * @param $x:Number (default = 0) 组件X坐标。
		 * @param $y:Number (default = 0) 组件Y坐标。
		 * @param $w:Number (default = 1920) 组件宽度。
		 * @param $h:Number (default = 1080) 组件高度。
		 * @param $label:String (default = null) 组件名字。
		 * 
		 */
		
		public static function createComponent(
			$sheetID:String,
			$componentTypeID:String,
			$order:uint = uint.MAX_VALUE,
			$x:Number = 0,
			$y:Number = 0,
			$w:Number = 90,
			$h:Number = 60,
			$label:String = null
		):Component
		{
			var id:uint = IDUtil.generateID("component");
			var code:String = getComponentCode($componentTypeID);
			
			var componenet:Component = new Component({
				"id": id, 
				"label": $label || "新建" + getComponentTypeName($componentTypeID) + id, 
				"order" : $order, 
				"coordX": $x, 
				"coordY": $y, 
				"width" : $w, 
				"height": $h, 
				"interactEnabled": true, 
				"componentTypeId": $componentTypeID
			});
			componenet.sheetID = $sheetID;
			return componenet;
		}
		
		
		/**
		 * @private
		 */
		private static function getComponentTypeName($id:String):String
		{
			var provider:MDProvider = MDProvider.instance;
			return (provider.program && provider.program.componentTypesMap[$id])
				? provider.program.componentTypesMap[$id].label : "元素";
		}
		
		/**
		 * @private
		 */
		private static function getComponentCode($id:String):String
		{
			var provider:MDProvider = MDProvider.instance;
			return (provider.program && provider.program.componentTypesMap[$id])
			? provider.program.componentTypesMap[$id].code : null;
		}
		
	}
}