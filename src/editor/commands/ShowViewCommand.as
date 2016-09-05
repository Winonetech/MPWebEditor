package editor.commands
{
	
	/**
	 * 
	 * 显示视图。
	 * 
	 */
	
	
	import cn.mvc.managers.KeyboardManager;
	
	import editor.utils.CommandUtil;
	import editor.views.EditorView;
	
	import flash.events.Event;
	
	import mx.events.FlexEvent;
	
	
	public final class ShowViewCommand extends _InternalCommand
	{
		
		/**
		 * 
		 * 构造函数。
		 * 
		 */
		
		public function ShowViewCommand()
		{
			super();
		}
		
		
		/**
		 * @inheritDoc
		 */
		
		override public function execute():void
		{
			commandStart();
			
			showViews();
		}
		
		
		/**
		 * @private
		 */
		private function showViews():void
		{
			if (vars.editorView)
			{
				commandEnd();
			}
			else
			{
				vars.editorView = new EditorView;
				var handler:Function = function(e:Event):void
				{
					vars.editorView.removeEventListener(FlexEvent.CREATION_COMPLETE, handler);
					vars.sheets     = vars.editorView.sheets;
					vars.addone     = vars.editorView.addone;
					vars.canvas     = vars.editorView.canvas;
					vars.components = vars.editorView.components;
					vars.titleBar   = vars.editorView.titleBar;
					//注册删除组件快捷键DELETE
					KeyboardManager.keyboardManager.initialize(vars.application.stage);
					KeyboardManager.keyboardManager.registControl(CommandUtil.shotcutDel, [46]);
					
					commandEnd();
				}
				
				vars.editorView.addEventListener(FlexEvent.CREATION_COMPLETE, handler);
				vars.application.addElement(vars.editorView);
			}
		}
		
	}
}