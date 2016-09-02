package cn.mvc.utils
{
	import cn.mvc.core.NoInstance;
	
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	public final class RectangleUtil extends NoInstance
	{
		public static function getCenter(rec:Rectangle):Point
		{
			return new Point((rec.left + rec.right) / 2, (rec.top + rec.bottom) / 2);
		}
	}
}