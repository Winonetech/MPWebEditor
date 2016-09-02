package cn.mvc.errors
{
	
	/**
	 * 
	 * 不可实例化类异常。当尝试构造此种类的实例时抛出此异常。
	 * 
	 * @author vision
	 * @langversion 3.0
	 * @playerversion Flash 9, AIR 1.1
	 * @productversion vision 1.0
	 * 
	 */
	
	import cn.mvc.utils.ClassUtil;
	
	
	public final class ClassPatternError extends VSError
	{
		
		/**
		 * 
		 * 构造函数。
		 * 
		 * @param $class:Class 抛出此异常的类。
		 * 
		 */
		
		public function ClassPatternError($class:Class = null)
		{
			super(ClassUtil.getClassName($class));
		}
	}
}