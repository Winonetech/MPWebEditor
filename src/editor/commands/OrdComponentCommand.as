package editor.commands
{
	
	/**
	 * 
	 * 修改组件顺序，或针对当前版面的所有组件更新顺序并提交后台。
	 * 
	 */
	
	
	import cn.mvc.utils.ArrayUtil;
	import cn.mvc.utils.RegexpUtil;
	
	import editor.consts.URLConsts;
	import editor.views.Debugger;
	import editor.vos.Component;
	import editor.vos.Sheet;
	

	public final class OrdComponentCommand extends _InternalCommCommand
	{
		
		/**
		 * 
		 * 构造函数。
		 * 
		 * @param $sheet:Sheet (default = null) 要操作的版面，如为空，则默认为正在编辑的版面。
		 * @param $component:Component (default = null) 要修改顺序的组件，如为空，则默认检查并更正当前版面所有组件的顺序。
		 * @param $order:uint (default = 0) 组件的新顺序，只有在$component参数不为空时才有效。
		 * 
		 */
		
		public function OrdComponentCommand($sheet:Sheet = null, $component:Component = null, $order:uint = 0)
		{
			super();
			
			sheet = $sheet;
			component = $component;
			order = $order;
			url = RegexpUtil.replaceTag(URLConsts.URL_COMPONENT_ORD, provider);
		}
		
		
		/**
		 * @inheritDoc
		 */
		
		override protected function excuteCommand():void
		{
			orders = sheet ? provider.program.ordComponent(sheet, component, order) : config.orders;
			
			config.orders = null;
			
			var submits:Array, child:Component;
			for each (child in orders)
			{
				submits = submits || [];
				ArrayUtil.push(submits, {
					"id"    : child.id,
					"order" : child.order
				});
			}
			
			submits
				? communicate(JSON.stringify(submits))
				: commandEnd();
		}
		
		
		/**
		 * @inheritDoc
		 */
		
		override protected function update($result:Object = null):void
		{
			if ($result == "ok")
			{
				if (vars.components)
					vars.components.update();
				if (vars.canvas)
					vars.canvas.update();
			}
			else
			{
				Debugger.log("修改顺序出错");
			}
		}
		
		
		/**
		 * @private
		 */
		private var orders:Array;
		
		/**
		 * @private
		 */
		private var sheet:Sheet;
		
		/**
		 * @private
		 */
		private var component:Component;
		
		/**
		 * @private
		 */
		private var order:uint;
		
	}
}