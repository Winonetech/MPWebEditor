package editor.commands
{
	
	/**
	 * 
	 * 全屏。
	 * 
	 */
	
	
	import flash.display.Stage;
	import flash.display.StageDisplayState;
	
	import mx.controls.Alert;

	
	public final class FullScreenCommand extends _InternalCommand
	{
		
		/**
		 * 
		 * 构造函数。
		 * 
		 * @param $check:Boolean (default = false) 是否为检测模式，如果是，则在全屏模式下
		 * 会切换至正常模式，正常模式下则无变化；否则，在全屏模式与正常模式之间切换。
		 * 
		 */
		
		public function FullScreenCommand($check:Boolean = false)
		{
			super();
			
			check = $check;
		}
		
		
		/**
		 * @inheritDoc
		 */
		
		override protected function excuteCommand():void
		{
			try
			{
				var stage:Stage = vars.application.stage;
				if (check)
				{
					if (stage.displayState!= StageDisplayState.NORMAL)
						stage.displayState = StageDisplayState.NORMAL;
				}
				else
				{
					stage.displayState = (stage.displayState == StageDisplayState.NORMAL)
						? StageDisplayState.FULL_SCREEN_INTERACTIVE : StageDisplayState.NORMAL;
				}
			}
			catch(e:Error)
			{
				Alert.show(e.message, "提示");
			}
		}
		
		
		/**
		 * @private
		 */
		private var check:Boolean;
		
	}
}