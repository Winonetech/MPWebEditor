package editor.controls
{
	
	/**
	 * 
	 * 解决文本框点击获得焦点后，点击外部，不能失去焦点的问题。
	 * 
	 */
	
	
	import flash.display.InteractiveObject;
	import flash.events.FocusEvent;
	import flash.geom.Point;
	
	import spark.components.TextInput;
	
	
	public final class MDTextInput extends TextInput
	{
		
		/**
		 * 
		 * 文本框。
		 * 
		 */
		
		public function MDTextInput()
		{
			super();
			
			addEventListener(FocusEvent.MOUSE_FOCUS_CHANGE, textInput_mouseFocusChangeHandler, false, 0, true);
		}
		
		
		/**
		 * @private
		 */
		private function textInput_mouseFocusChangeHandler(e:FocusEvent):void
		{
			dispatchEvent(new FocusEvent(FocusEvent.FOCUS_OUT));
			
			//获取当前鼠标位置下的物件列表。
			var iobjs:Array = stage.getObjectsUnderPoint(new Point(stage.mouseX, stage.mouseY));
			//设定焦点
			stage.focus = InteractiveObject(iobjs[iobjs.length - 1].parent);
		}
		
	}
}