package cn.mvc.states
{
	
	/**
	 * 
	 * 描述了UI组件准备完毕状态，此时组件已可以使用。
	 * 
	 * @author vision
	 * @langversion 3.0
	 * @playerversion Flash 9, AIR 1.1
	 * @productversion vision 1.0
	 * 
	 */
	
	
	import cn.mvc.consts.UIStateConsts;
	import cn.mvc.core.vs;
	import cn.mvc.core.State;
	
	
	public class UIReadyState extends State
	{
		
		/**
		 * 
		 * 构造函数。
		 * 
		 */
		
		public function UIReadyState()
		{
			super();
		}
		
		
		/**
		 * @inheritDoc
		 */
		
		override protected function initializeVariables():void
		{
			vs::name = UIStateConsts.READY;
		}
		
	}
}