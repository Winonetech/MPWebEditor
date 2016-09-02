package cn.mvc.core
{
	
	/**
	 * 
	 * 命令基类。<br>
	 * 开发人员需要定义命令的子类来继承，如果是同步命令，则只需重写受保护的processExecute方法，
	 * 如果是异步命令，则需重写execute()方法，并在异步命令的开始和结束的地方调用commandStart和
	 * commandEnd。
	 * 
	 * @author vision
	 * @langversion 3.0
	 * @playerversion Flash 9, AIR 1.1
	 * @productversion vision 1.0
	 * 
	 */
	
	
	import cn.mvc.collections.Holder;
	import cn.mvc.consts.CommandStateConsts;
	import cn.mvc.events.CommandEvent;
	import cn.mvc.events.StateEvent;
	import cn.mvc.interfaces.IState;
	import cn.mvc.states.CommandFinishedState;
	import cn.mvc.states.CommandIdleState;
	import cn.mvc.states.CommandInitializeState;
	import cn.mvc.states.CommandRunningState;
	import cn.mvc.utils.StateUtil;
	
	
	/**
	 * 
	 * 命令开始执行时派发。
	 * 
	 */
	
	[Event(name="commandStart", type="cn.mvc.events.CommandEvent")]
	
	/**
	 * 
	 * 命令结束执行时派发。
	 * 
	 */
	
	[Event(name="commandEnd", type="cn.mvc.events.CommandEvent")]
	
	
	/**
	 * 
	 * 命令状态改变时派发。
	 * 
	 */
	
	[Event(name="stateChange", type="cn.vision.events.StateEvent")]
	
	
	public class Command extends MCEventDispatcher implements IState
	{
		
		/**
		 * 
		 * 构造函数。
		 * 
		 */
		public function Command()
		{
			super();
			
			initialize();
		}
		
		
		/**
		 * 
		 * 结束正在执行的命令。<br>
		 * 只有异步命令才可以关闭，如从页面加载数据，而关闭操作则需要重写close方法
		 * 
		 */
		
		public function close():void
		{
			executing && commandEnd();
		}
		
		
		/**
		 * 
		 * 执行命令。<br>
		 * 开发人员在重写子类时，如果是异步命令，需覆盖此方法，并在命令的开始与结束时调用
		 * commandStart和commandEnd方法；如果是同步命令，则无需重写此方法，只需重写
		 * processExecute。
		 * 
		 * @see cn.mvc.core.Command.processExecute()
		 * @see cn.mvc.core.Command.commandStart()
		 * @see cn.mvc.core.Command.commandEnd()
		 * 
		 */
		
		public function execute():void
		{
			commandStart();
			
			processExecute();
			
			commandEnd();
		}
		
		
		/**
		 * 
		 * 命令执行<br>
		 * 重写命令的子类且是同步命令时，需要覆盖此方法。
		 * 
		 * @see cn.mvc.core.Command.execute()
		 * 
		 */
		
		protected function processExecute():void
		{
			
		}
		
		
		/**
		 * 
		 * 命令开始，发送命令开始事件。<br>
		 * 重写命令的子类时，一般无需重写此方法，此方法只在开发人员重写execute方法时调用它。
		 * 
		 * @see cn.mvc.core.Command.execute()
		 * 
		 */
		
		protected function commandStart():void
		{
			if(!vs::executing)
			{
				vs::executing = true;
				state = CommandStateConsts.RUNNING;
				dispatchEvent(new CommandEvent(CommandEvent.COMMAND_START, this));
			}
		}
		
		
		/**
		 * 
		 * 命令结束，发送命令结束事件。<br>
		 * 重写命令的子类时，一般无需重写此方法，此方法只在开发人员重写execute方法时调用它。
		 * 
		 * @see cn.mvc.core.Command.execute()
		 * 
		 */
		
		protected function commandEnd():void
		{
			if (vs::executing)
			{
				vs::executing = false;
				state = CommandStateConsts.FINISHED;
				dispatchEvent(new CommandEvent(CommandEvent.COMMAND_END, this));
			}
		}
		
		
		
		
		/**
		 * @private
		 */
		private function initialize():void
		{
			//variables
			vs::state = CommandStateConsts.INITIALIZE;
			
			stateStore = new Holder;
			
			stateStore.registData(CommandStateConsts.INITIALIZE, new CommandInitializeState);
			stateStore.registData(CommandStateConsts.IDLE      , new CommandIdleState);
			stateStore.registData(CommandStateConsts.RUNNING   , new CommandRunningState);
			stateStore.registData(CommandStateConsts.FINISHED  , new CommandFinishedState);
			
			state = CommandStateConsts.IDLE;
		}
		
		
		/**
		 * 
		 * 是否在执行中。
		 * 
		 */
		
		public function get executing():Boolean
		{
			return vs::executing as Boolean;
		}
		
		
		/**
		 * @inheritDoc
		 */
		
		public function get lastState():String
		{
			return vs::lastState;
		}
		
		
		/**
		 * 
		 * 命令的优先级。
		 * 
		 */
		
		public function get priority():uint
		{
			return vs::priority;
		}
		
		/**
		 * @private
		 */
		public function set priority($value:uint):void
		{
			vs::priority = $value;
		}
		
		
		/**
		 * @inheritDoc
		 */
		
		public function get state():String
		{
			return vs::state;
		}
		
		/**
		 * @private
		 */
		public function set state($value:String):void
		{
			if ($value != vs::state)
			{
				vs::lastState = vs::state;
				vs::state = $value;
				//冻结上一个状态并激活当前状态
				StateUtil.vs::changeState(lastState, state, stateStore);
				
				dispatchEvent(new StateEvent(StateEvent.STATE_CHANGE, vs::lastState, vs::state));
			}
		}
		
		
		/**
		 * @private
		 */
		protected var stateStore:Holder;
		
		
		/**
		 * @private
		 */
		vs var executing:Boolean;
		
		/**
		 * @private
		 */
		vs var lastState:String;
		
		/**
		 * @private
		 */
		vs var state:String;
		
		/**
		 * @private
		 */
		vs var priority:uint;
		
	}
}