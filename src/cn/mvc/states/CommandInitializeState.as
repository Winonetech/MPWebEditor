package cn.mvc.states
{
	
	/**
	 * 
	 * IdleCommandState 描述了命令的闲置状态。
	 * 
	 * @author vision
	 * @langversion 3.0
	 * @playerversion Flash 9, AIR 1.1
	 * @productversion vision 1.0
	 * 
	 */
	
	
	import cn.mvc.consts.CommandStateConsts;
	import cn.mvc.core.vs;
	import cn.mvc.core.State;
	
	
	public class CommandInitializeState extends State
	{
		
		/**
		 * 
		 * 构造函数。
		 * 
		 */
		
		public function CommandInitializeState()
		{
			super();
		}
		
		
		/**
		 * @inheritDoc
		 */
		
		override protected function initializeVariables():void
		{
			vs::name = CommandStateConsts.INITIALIZE;
		}
		
	}
}