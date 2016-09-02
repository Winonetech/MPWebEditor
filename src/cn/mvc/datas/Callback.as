package cn.mvc.datas
{
	
	/**
	 * 
	 * 函数回调类，存储一个函数以及相关参数。
	 * 
	 * @author vision
	 * @langversion 3.0
	 * @playerversion Flash 9, AIR 1.1
	 * @productversion vision 1.0
	 * 
	 */
	
	
	import cn.mvc.core.MCObject;
	import cn.mvc.interfaces.IAvailable;
	
	
	public final class Callback extends MCObject implements IAvailable
	{
		
		/**
		 * 
		 * <code>Callback</code>构造函数。
		 * 
		 */
		
		public function Callback($callback:Function = null, $args:Array = null)
		{
			super();
			
			initialize($callback, $args);
		}
		
		
		/**
		 * 
		 * 调用函数。
		 * 
		 */
		
		public function call():*
		{
			return callback.apply(null, args);
		}
		
		
		/**
		 * @private
		 */
		private function initialize($callback:Function, $args:Array):void
		{
			callback = $callback;
			args = $args;
		}
		
		
		/**
		 * @inheritDoc
		 */
		
		public function get available():Boolean
		{
			return Boolean(callback);
		}
		
		
		/**
		 * 
		 * 回掉函数。
		 * 
		 */
		
		public var callback:Function;
		
		
		/**
		 * 
		 * 相关参数。
		 * 
		 */
		
		public var args:Array;
		
	}
}