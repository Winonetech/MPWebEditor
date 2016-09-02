package cn.mvc.consts
{
	
	/**
	 * 
	 * 定义了一些错误常量。
	 * 
	 * @author vision
	 * @langversion 3.0
	 * @playerversion Flash 9, AIR 1.1
	 * @productversion vision 1.0
	 * 
	 */
	
	
	import cn.mvc.core.NoInstance;
	import cn.mvc.core.vs;
	
	public final class ErrorConsts extends NoInstance
	{
		
		/**
		 * 
		 * 单例异常。
		 * 
		 */
		
		vs static const SINGLE_TON:String = "{$self} 是单例模式，请访问 {$self}.instance 获取 {$self} 的唯一实例!";
		
		
		/**
		 * 
		 * 无实例类异常。
		 * 
		 */
		
		vs static const CLASS_PATTERN:String = "{$self} 是无实例类，不能实例化！";
		
	}
}