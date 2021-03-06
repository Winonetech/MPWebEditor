package cn.mvc.core
{
	
	/**
	 * 
	 * 可视元素的基类。
	 * 
	 * @author vision
	 * @langversion 3.0
	 * @playerversion Flash 9, AIR 1.1
	 * @productversion vision 1.0
	 * 
	 */
	
	
	import cn.mvc.collections.Holder;
	import cn.mvc.consts.UIStateConsts;
	import cn.mvc.events.StateEvent;
	import cn.mvc.interfaces.IEnable;
	import cn.mvc.interfaces.IExtra;
	import cn.mvc.interfaces.IID;
	import cn.mvc.interfaces.IName;
	import cn.mvc.interfaces.IState;
	import cn.mvc.states.UIInitializeState;
	import cn.mvc.states.UIReadyState;
	import cn.mvc.utils.ClassUtil;
	import cn.mvc.utils.IDUtil;
	import cn.mvc.utils.StateUtil;
	
	import flash.display.Sprite;
	import flash.events.Event;
	
	
	public class UI extends Sprite implements IEnable, IExtra, IID, IName, IState
	{
		
		/**
		 * 
		 * 构造函数。
		 * 
		 */
		
		public function UI()
		{
			super();
			
			initialize();
			
			state = UIStateConsts.READY;
		}
		
		
		/**
		 * 
		 * 组件初始化操作。
		 * 
		 */
		
		vs function updateProperties():void
		{
			
		}
		
		
		
		
		/**
		 * 
		 * 组件初始化操作。
		 * 
		 */
		
		protected function initialize():void
		{
			//variables
			vs::vid = IDUtil.generateID();
			vs::enabled = true;
			vs::state = UIStateConsts.INITIALIZE;
			
			stateStore = new Holder;
			
			//states
			stateStore.registData(UIStateConsts.INITIALIZE, new UIInitializeState);
			stateStore.registData(UIStateConsts.READY, new UIReadyState);
			
			//listeners
		}
		
		
		/**
		 * @private
		 */
		private function handlerRender($e:Event):void
		{
			trace("ui-render");
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
		
		public function get enabled():Boolean
		{
			return Boolean(vs::enabled);
		}
		
		/**
		 * @private
		 */
		public function set enabled($value:Boolean):void
		{
			vs::enabled = $value;
		}
		
		
		/**
		 * @inheritDoc
		 */
		
		public function get extra():MCObject
		{
			return vs::extra || (vs::extra = {});
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
		 * @inheritDoc
		 */
		
		public function get lastState():String
		{
			return vs::lastState;
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
		 * @inheritDoc
		 */
		
		public function get vid():uint
		{
			return vs::vid;
		}
		
		
		/**
		 * @private
		 */
		protected var stateStore:Holder;
		
		
		/**
		 * @private
		 */
		vs var className:String;
		
		/**
		 * @private
		 */
		vs var enabled:Boolean;
		
		/**
		 * @private
		 */
		vs var extra:Object;
		
		/**
		 * @private
		 */
		vs var instanceName:String;
		
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
		vs var vid:uint;
		
	}
}
