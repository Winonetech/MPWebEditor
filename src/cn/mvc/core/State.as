package cn.mvc.core
{
	
	/**
	 * 
	 * 是所有状态的基类，用于描述实例的状态，所做的操作。
	 * 
	 * @author vision
	 * @langversion 3.0
	 * @playerversion Flash 9, AIR 1.1
	 * @productversion vision 1.0
	 * 
	 */
	
	
	import cn.mvc.core.vs;
	import cn.mvc.core.MCObject;
	
	
	public class State extends MCObject
	{
		
		/**
		 * 
		 * <code>State</code>构造函数。
		 * 
		 */
		
		public function State()
		{
			super();
			
			initialize();
		}
		
		
		/**
		 * 
		 * 变量初始化。
		 * 
		 */
		
		protected function initializeVariables():void
		{
			vs::name = "state" + vid;
		}
		
		
		/**
		 * 初始化操作。
		 * @private
		 */
		private function initialize():void
		{
			initializeVariables();
		}
		
		
		/**
		 * 
		 * 激活当前状态。
		 * 
		 */
		
		public function active():void { }
		
		
		/**
		 * 
		 * 冻结当前状态。
		 * 
		 */
		
		public function freeze():void { }
		
		
		/**
		 * 
		 * 状态的名称。
		 * 
		 */
		public function get name():String
		{
			return vs::name;
		}
		
		/**
		 * @private
		 */
		public function set name($value:String):void
		{
			vs::name = $value;
		}
		
		
		/**
		 * @private
		 */
		vs var name:String;
		
	}
}