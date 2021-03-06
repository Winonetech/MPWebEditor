package cn.mvc.errors
{
	
	/**
	 * 
	 * MCError是所有错误的基类。
	 * 
	 * @author vision
	 * @langversion 3.0
	 * @playerversion Flash 9, AIR 1.1
	 * @productversion vision 1.0
	 * 
	 */
	
	import cn.mvc.core.vs;
	import cn.mvc.interfaces.IID;
	import cn.mvc.interfaces.IName;
	import cn.mvc.managers.ErrorManager;
	import cn.mvc.utils.ClassUtil;
	import cn.mvc.utils.IDUtil;
	import cn.mvc.utils.StringUtil;
	
	
	public class VSError extends Error implements IID, IName
	{
		
		/**
		 * 
		 * <code>VSError</code>构造函数。
		 * 
		 * @param $message:String (default = "") 出错信息。
		 * 
		 */
		
		public function VSError($message:String = "")
		{
			super(message, ErrorManager.registError(ClassUtil.getClass(this)));
			
			initialize();
		}
		
		
		/**
		 * 初始化操作。
		 * @private
		 */
		private function initialize():void
		{
			vs::vid = IDUtil.generateID();
			name = StringUtil.lowercaseInitials(className);
		}
		
		
		/**
		 * @inheritDoc
		 */
		
		public function get className():String
		{
			return vs::className = vs::className || ClassUtil.getClassName(this);
		}
		
		
		/**
		 * @inheritDoc
		 */
		
		public function get vid():uint
		{
			return vs::vid;
		}
		
		
		/**
		 * @inheritDoc
		 */
		
		public function get instanceName():String
		{
			return vs::instanceName;
		}
		
		/**
		 * @private
		 */
		public function set instanceName($value:String):void
		{
			vs::instanceName = $value;
		}
		
		
		/**
		 * @private
		 */
		vs var className:String;
		
		/**
		 * @private
		 */
		vs var instanceName:String;
		
		/**
		 * @private
		 */
		vs var vid:uint;
		
	}
}