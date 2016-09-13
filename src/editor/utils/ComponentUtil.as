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
	import editor.views.CanvasContent;
	import editor.views.Debugger;
	import editor.views.PageSelector;
	import editor.views.components.CanvasItem;
	import editor.views.properties.PropertyItem;
	
	import flash.geom.Rectangle;
	import flash.sampler.stopSampling;
	
	import mx.controls.Alert;

	
	
	public final class ComponentUtil extends NoInstance
	{
		
		
		/**
		 * 
		 * 判定组件本身及其父容器是否为CanvasItem类型
		 * 
		 */
		public static function isType($component:*):CanvasItem
		{
			var result:Boolean = $component is CanvasItem;
			if ($component != null)
				return result ? $component : isType($component.parent);
			else return null;
		}
		
		/**
		 * 
		 * 组件属性修正函数。
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
		 * @param $change : 缩放比例因子（改变后的值  / 改变前的值）
		 * @param $state  : 页面改变的属性。可能值为："width"或"height"
		 * 
		 */
		public static function limitSheetComponents($change:Number, $state:String):void
		{
			var dic:Map = MDVars.instance.canvas.content.dic;
			var content:CanvasContent = MDVars.instance.canvas.content;
			switch($state)
			{
				case "width":
				{
					for each(var item1:CanvasItem in dic)
					{
						item1.component.width = 
							Math.round(item1.width * $change);
						if (item1.component.width == 0) item1.component.width ++;
						item1.component.x = 
							Math.round(item1.x * $change);
						CommandUtil.edtComponent(item1.component, {
							"x" : item1.component.x,
							"width" : item1.component.width
						});
					}
					break;
				}
				default:
				{
					for each (var item2:CanvasItem in dic)
					{
						item2.component.height = Math.round(item2.height * $change);
						if (item2.component.height == 0) item2.component.height++;
						item2.component.y = Math.round(item2.y * $change);
						CommandUtil.edtComponent(item2.component, {
							"height" : item2.component.height,
							"y" : item2.component.y
						});
					}//foreach
					break;
				}//default
				content.update();
			}//switch
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
		 * 根据当前组件矩形占位，获取最大化矩形占位，此矩形不能与其他矩形重叠。
		 * （宽度优先）
		 * 
		 */
		
		public static function getMaxmizeRect($selectedComponent:Rectangle, $otherComponents:Vector.<Rectangle>, $container:Rectangle):Rectangle
		{   
			//推入容器的上下左右值
			var l:Array = [$container.left];
			var r:Array = [$container.right];
			var t:Array = [$container.top];
			var b:Array = [$container.bottom];
			
			//被选矩阵与其他矩阵重叠则弹出提示 
			//并不会改变被选矩阵的占位 
			
			for each (var item:Rectangle in $otherComponents)
			{
				if($selectedComponent.intersects(item))
				{
					Alert.show("被选组件与其他组件有重叠！");
					return $selectedComponent;
				}
			}
			
			//推入每个符合条件的组件的左右值	
			for each (var item1:Rectangle in $otherComponents)
			{
				//判定左区域
				if(item1.top < $selectedComponent.bottom && 
				   item1.bottom > $selectedComponent.top && 
				   item1.right <= $selectedComponent.left) l.push(item1.right);
				//判定右区域
				if(item1.top < $selectedComponent.bottom && 
				   item1.bottom > $selectedComponent.top && 
				   item1.left >= $selectedComponent.right) r.push(item1.left);
			}
			
			var la:Number = l.length > 1 ? Math.max.apply(null, l) : $container.left;
			var ra:Number = r.length > 1 ? Math.min.apply(null, r) : $container.right;
			
			//推入每个符合条件的组件的上下值	
			for each (var item2:Rectangle in $otherComponents)
			{
				//判定上区域
				if(item2.right > la && item2.left < ra && 
				   item2.bottom <= $selectedComponent.top) t.push(item2.bottom);
				
				//判定下区域
				if(item2.right > la && item2.left < ra && 
					item2.top >= $selectedComponent.bottom) b.push(item2.top);
			}
			
			var ta:Number = t.length > 1 ? Math.max.apply(null,t) : $container.top;
			var ba:Number = b.length > 1 ? Math.min.apply(null,b) : $container.bottom;
			
			return new Rectangle(la, ta, ra - la, ba - ta);
		}		

		
		/**
		 * 
		 * 根据属性类型获取组件。
		 * 
		 * @param 
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
		private static const CODE_COMPONENT:Object = 
		{
			image: editor.controls.MDImage, 
			text : editor.controls.MDText, 
			video: editor.controls.MDVideo, 
			flash: editor.controls.MDFlash
		};
	}	
	}