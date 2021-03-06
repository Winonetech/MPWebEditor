package cn.mvc.states
{
	
	/**
	 * 
	 * RunningCommandState 描述了命令的闲置状态。
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
	
	
	public final class CommandRunningState extends State
	{
		
		/**
		 * 
		 * 构造函数。
		 * 
		 */
		
		public function CommandRunningState()
		{
			super();
		}
		
		
		/**
		 * @inheritDoc
		 */
		
		override protected function initializeVariables():void
		{
			vs::name = CommandStateConsts.RUNNING;
		}
		
	}
}