package editor.tools
{
	import editor.commands.EdtComponentCommand;
	import editor.core.MDConfig;
	import editor.core.MDPresenter;
	import editor.core.MDVars;
	import editor.views.Debugger;
	import editor.vos.Component;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	import w11k.flash.AngularJSAdapter;
	
	public final class FillTool extends EventDispatcher
	{
		public function FillTool(target:IEventDispatcher=null)
		{
			super(target);
		}
		
		
		public function fillComponent($component:Object):void
		{
			AngularJSAdapter.getInstance().call("fillComponent(component)", {"component" : $component});
		}
		
		public function fillComplete(componentId:String, hasContent:Boolean):void
		{
			var temp:Component = findComponentById(componentId);
			if (temp)
			{
				temp.hasContent = hasContent;
				MDVars.instance.editorView.canvas.content.updateComponent(temp);
				MDPresenter.instance.execute(new EdtComponentCommand(temp, {hasContent:temp.hasContent}));
			}
			
		}
		
		private function findComponentById($id:String):Component
		{
			return config.editingSheet 
				? config.editingSheet.componentsMap[$id] : null;
		}
		
		private var config:MDConfig = MDConfig.instance;
	}
}