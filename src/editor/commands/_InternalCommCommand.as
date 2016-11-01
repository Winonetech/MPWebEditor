package editor.commands
{
	
	/**
	 * 
	 * 通讯命令基类。
	 * 
	 */
	
	
	import editor.views.Debugger;
	import editor.views.ProgressWindow;
	
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.http.HTTPService;
	
	
	internal class _InternalCommCommand extends _InternalCommand
	{
		
		/**
		 * 
		 * 构造函数。
		 * 
		 */
		
		public function _InternalCommCommand()
		{
			super();
			initializeEnvironment();
		}
		
		
		/**
		 * @inheritDoc
		 */
		
		override public function execute():void
		{
			commandStart();
			
			excuteCommand();
		}
		
		
		/**
		 * 
		 * 与服务端通讯。
		 * 
		 */
		
		protected function communicate($data:Object = null, $end:Boolean = true):void
		{
			if (url)
			{
				end = $end;
				
				if ($data)
				{
					data = $data;
					timerCreate();
				}
				else
				{
					$data = data;
				}
				
				http.addEventListener(ResultEvent.RESULT, handlerDefault);
				http.addEventListener(FaultEvent.FAULT, handlerDefault);
				
				trace(url, method, $data);
				
				if ($data)
					http.send($data);
				else
					http.send();
			}
		}
		
		
		/**
		 * 
		 * 与服务端通讯。
		 * 
		 */
		
		protected function update($result:Object = null):void
		{
			
		}
		
		
		/**
		 * @private
		 */
		private function progressPlay(label:String = null):void
		{
			var progress:ProgressWindow = (vars.progress = vars.progress || new ProgressWindow);
			progress.label = label ? label : "与服务端通讯中，请稍后。。。";
			
			if(!vars.application.contains(progress))
				vars.application.addElement(progress);
		}
		
		/**
		 * @private
		 */
		private function progressStop():void
		{
			timerRemove();
			
			var progress:ProgressWindow = vars.progress;
			if (progress && 
				vars.application.contains(progress))
				vars.application.removeElement(progress);
		}
		
		/**
		 * @private
		 */
		private function timerCreate(repeat:uint = 1):void
		{
			if(!timer)
			{
				timer = new Timer(1000, repeat);
				timer.addEventListener(TimerEvent.TIMER_COMPLETE, handlerTimer);
				timer.start();
			}
		}
		
		/**
		 * @private
		 */
		private function timerReset():void
		{
			if (timer)
			{
				timer.reset();
				timer.start();
			}
		}
		
		/**
		 * @private
		 */
		private function timerRemove():void
		{
			if (timer)
			{
				timer.stop();
				timer.removeEventListener(TimerEvent.TIMER_COMPLETE, handlerTimer);
				timer = null;
			}
		}
		
		
		/**
		 * @private
		 */
		private function initializeEnvironment():void
		{
			http = new HTTPService;
			http.contentType = "application/json";
			http.method = "POST";
			revocable = true;
		}
		
		
		/**
		 * @private
		 */
		private function handlerDefault(e:Event):void
		{
			http.removeEventListener(ResultEvent.RESULT, handlerDefault);
			http.removeEventListener(FaultEvent.FAULT, handlerDefault);
			
			if (e.type == ResultEvent.RESULT)
			{
				update((e as ResultEvent).result);
				
				progressStop();
				
				if (end) commandEnd();
			}
			else
			{
				Debugger.log("交互出错，" + (e as FaultEvent).fault.faultString);
				
				progressPlay("连接断开。。。");
				
				communicate();
			}
		}
		
		/**
		 * @private
		 */
		private function handlerTimer(e:TimerEvent):void
		{
			timerRemove();
			
			progressPlay();
		}
		
		
		/**
		 * 
		 * 通讯路径。
		 * 
		 */
		
		public function get url():String
		{
			return http.url;
		}
		
		/**
		 * @private
		 */
		public function set url($value:String):void
		{
			http.url = $value;
		}
		
		
		/**
		 * 
		 * 方法。
		 * 
		 */
		
		public function get method():String
		{
			return http.method;
		}
		
		/**
		 * @private
		 */
		public function set method($value:String):void
		{
			http.method = $value;
		}
		
		
		/**
		 * @private
		 */
		protected var http:HTTPService;
		
		/**
		 * @private
		 */
		private var timer:Timer;
		
		/**
		 * @private
		 */
		private var data:Object;
		
		/**
		 * @private
		 */
		private var end:Boolean;
		
	}
}