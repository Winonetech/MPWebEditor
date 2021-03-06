package cn.mvc.states
{
	
	/**
	 * 
	 * 描述了UI组件初始化状态。
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
	
	
	public class UIInitializeState extends State
	{
		
		/**
		 * 
		 * 构造函数。
		 * 
		 */
		
		public function UIInitializeState()
		{
			super();
		}
		
		
		/**
		 * @inheritDoc
		 */
		
		override protected function initializeVariables():void
		{
			vs::name = UIStateConsts.INITIALIZE;
		}
		
	}
}