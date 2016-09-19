package editor.utils
{
	
	import cn.mvc.core.NoInstance;
	import cn.mvc.utils.ArrayUtil;
	import cn.mvc.utils.MathUtil;
	import cn.mvc.utils.ObjectUtil;
	import cn.mvc.utils.RectangleUtil;
	
	import editor.core.MDVars;
	import editor.views.CanvasContent;
	import editor.views.components.CanvasItem;
	
	import flash.display.DisplayObject;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import mx.controls.Alert;
	
	
	public final class CanvasUtil extends NoInstance
	{
		
		/**
		 * 
		 * 返回满足吸附条件的点/Object。
		 * @param $currentComponent:DisplayObject 检测的组件。
		 * @param $point:Point 能否被吸附的点。
		 * @param $isMoving:Boolean 是否为拖动整个组件，或者改变组件大小，对应返回point还是Object。
		 * 
		 */
		public static function autoCombine($currentComponent:DisplayObject, $point:Point, $isMoving:Boolean = true, $forbid:String = "all"):*
		{
			var scale:Number = vars.canvas.viewer.contentScale;
			
			var obj:Object = showWhere($currentComponent, $forbid);
			var tempX:Number, tempW:Number, tempY:Number, tempH:Number;
			
			var center:Point = RectangleUtil.getCenter(CanvasUtil.getRect($currentComponent));
			
			if (obj["Ver"] != null)
			{
				if (obj["Ver"] > center.x)
				{
					if ($isMoving)
					{
						tempX = MathUtil.isBetween(obj["Ver"] - 5 / scale, $point.x + $currentComponent.width, obj["Ver"] + 5 / scale)
							? obj["Ver"] - $currentComponent.width : $point.x;
					}
					else
					{
						tempW = MathUtil.isBetween(obj["Ver"] - 5 / scale, $point.x + $currentComponent.x, obj["Ver"] + 5 / scale)
							? obj["Ver"] - $currentComponent.x : $point.x;
					}
				}
				else //线在左边
				{
					tempX = MathUtil.isBetween(obj["Ver"] - 5 / scale, $point.x, obj["Ver"] + 5 / scale)
						? obj["Ver"] : $point.x;
					tempW = $point.x;
				}
			}
			else //不在吸附范围内
			{
				tempX = tempW = $point.x;
				//trace("Ver not in")
			}
			
			if (obj["Hor"] != null) 
			{
				if (obj["Hor"] > center.y)
				{
					if ($isMoving)
					{
						tempY = MathUtil.isBetween(obj["Hor"] - 5 / scale, $point.y + $currentComponent.height, obj["Hor"] + 5 / scale)
							? obj["Hor"] - $currentComponent.height : $point.y;
					}
					else
					{
						tempH = MathUtil.isBetween(obj["Hor"] - 5 / scale, $point.y + $currentComponent.y, obj["Hor"] + 5 / scale)
							? obj["Hor"] - $currentComponent.y : $point.y;
					}
				}
				else //线在上边
				{
					tempY = MathUtil.isBetween(obj["Hor"] - 5 / scale, $point.y, obj["Hor"] + 5 / scale)
						? obj["Hor"] : $point.y;
					tempH = $point.y;
				}
			}
			else
			{
				tempY = tempH = $point.y;
			}
			return $isMoving ? new Point(tempX, tempY) : {"point":new Point(tempX, tempY), "tempW":tempW, "tempH":tempH};
		}
		
		
		/**
		 * 
		 * 获取辅助线属性。
		 * 
		 * @param $display:DisplayObject : 所需获取辅助线属性的元素。
		 * @param $type:* 对应的获取类型类型。
		 * 
		 */
		public static function showWhere($recMove:DisplayObject, $forbid:* = "all"):Object
		{
			if ($recMove)
			{
				if ($forbid is Array) var flag:Boolean = true;
				var pointR:Point = RectangleUtil.getCenter(CanvasUtil.getRect($recMove));
				var compare:Function = function(a:Rectangle, b:Rectangle):int
				{
					var pointA:Point = RectangleUtil.getCenter(a);
					var pointB:Point = RectangleUtil.getCenter(b);
					var temp:Number = Point.distance(pointA, pointR) - Point.distance(pointB, pointR);
					return temp > 0 ? 1 : (temp < 0 ? -1 : 0);
				};
				var obj:Object = {"Ver":null, "Hor":null};
				
				var newRects:Vector.<Rectangle> = getExceptRects(content.itemsMap, $recMove);
				var scale:Number = vars.canvas.viewer.contentScale;
				
				newRects.sort(compare);
				
				var item:Rectangle;
				//遍历X方向
				for each (item in newRects)
				{
					if (item)
					{
						if (flag) $forbid = "right";
						if (($forbid == "left" || $forbid == "all") && (MathUtil.isBetween(item.left - 5 / scale, $recMove.x, item.left + 5 / scale) ||
							MathUtil.isBetween(item.right - 5 / scale, $recMove.x, item.right + 5 / scale)))
						{
							obj["Ver"] = MathUtil.near(item.right, $recMove.x, item.left);
							break;
						}
						else if (($forbid == "right" || $forbid == "all") && (MathUtil.isBetween(item.left - 5 / scale, $recMove.x + $recMove.width, item.left + 5 / scale) || 
							MathUtil.isBetween(item.right - 5 / scale, $recMove.x + $recMove.width, item.right + 5 / scale)))
						{
							obj["Ver"] = MathUtil.near(item.right, $recMove.x + $recMove.width, item.left);
							break;
						}
					}// if (item)
				}// for each
				//遍历Y方向
				for each (item in newRects)
				{
					if (item)
					{
						if (flag) $forbid = "bottom";
						if (($forbid == "bottom" || $forbid == "all") && (MathUtil.isBetween(item.top - 5 / scale, $recMove.y + $recMove.height, item.top + 5 / scale) || 
							MathUtil.isBetween(item.bottom - 5 / scale, $recMove.y + $recMove.height, item.bottom + 5 / scale)))
						{
							obj["Hor"] = MathUtil.near(item.bottom, $recMove.y + $recMove.height, item.top);
							break;
						}
						else if (($forbid == "top" || $forbid == "all") && (MathUtil.isBetween(item.top - 5 / scale, $recMove.y, item.top + 5 / scale) || 
							MathUtil.isBetween(item.bottom - 5 / scale, $recMove.y, item.bottom + 5 / scale)))
						{
							obj["Hor"] = MathUtil.near(item.bottom, $recMove.y, item.top);
							break;
						}
					}// if (item)
				}
			}
			return obj;
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
		 * 获取除某些组件外的其他组件的矩形占位。
		 * 
		 * @param $display:DisplayObject 要获取的显示对象。
		 * 
		 */
		
		public static function getExceptRects($dic:Object, ...$args):Vector.<Rectangle>
		{
			var result:Vector.<Rectangle>, item:DisplayObject;
			
			if ($args) ArrayUtil.unshift($args, $dic);
			
			var components:Array = ObjectUtil.getItems.apply(null, $args);
			
			for each (item in components) 
			{
				result = result || new Vector.<Rectangle>;
				ArrayUtil.push(result, getRect(item));
			}
			return result;
		}
		
		
		/**
		 * 
		 * 获取显示的相对矩形范围，不包含旋转情况。
		 * 
		 * @param $display:DisplayObject 要获取的显示对象。
		 * 
		 */
		
		public static function getRect($display:DisplayObject):Rectangle
		{
			return new Rectangle($display.x, $display.y, $display.width, $display.height);
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
		private static function get content():CanvasContent
		{
			return vars.canvas.content;
		}
		
	}
}