package cn.mvc.states
{
	
	/**
	 * 
	 * 描述了队列的闲置状态。
	 * 
	 * @author vision
	 * @langversion 3.0
	 * @playerversion Flash 9, AIR 1.1
	 * @productversion vision 1.0
	 * 
	 */
	
	
	import cn.mvc.consts.QueueStateConsts;
	import cn.mvc.core.vs;
	import cn.mvc.core.State;
	
	
	public class QueueIdleState extends State
	{
		
		/**
		 * 
		 * 构造函数。
		 * 
		 */
		
		public function QueueIdleState()
		{
			super();
		}
		
		
		/**
		 * @inheritDoc
		 */
		
		override protected function initializeVariables():void
		{
			vs::name = QueueStateConsts.IDLE;
		}
		
	}
}