package editor.commands
{
	import cn.mvc.utils.ArrayUtil;
	import cn.mvc.utils.RegexpUtil;
	
	import editor.consts.URLConsts;
	import editor.core.MDProvider;
	import editor.views.Debugger;
	import editor.vos.Page;


	/**
	 * 
	 * 拖动页面时顺序改变命令 
	 *
	 */
	public class OrdPageCommand extends _InternalCommCommand
	{
		public function OrdPageCommand($page:Page = null, $order:uint = 0)
		{
			super();
			page  = $page;
			order = $order;
			url = RegexpUtil.replaceTag(RegexpUtil.replaceTag(URLConsts.URL_PAGE_ORD, page), provider);
		}
		

		
		override protected function processUndo():void
		{
			var temp:Array = orderPages(page, last);
			
			var submits:Array, child:Page;
			for each (child in temp)
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
		
		
		override protected function processRedo():void
		{
			var temp:Array = orderPages(page, pres);
			
			var submits:Array, child:Page;
			for each (child in temp)
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
		
		override protected function excuteCommand():void
		{
			last = page.order;
			pres = order;
			
			orders = page ? orderPages(page, order) : config.orders;
			
			config.orders = null;
			
			var submits:Array, child:Page;
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
		
		override protected function update($result:Object = null):void
		{
			if ($result == "ok")
			{
				if (vars.sheets)
					vars.sheets.update();
			}
			else
			{
				Debugger.log("修改顺序出错");
			}
		}
		
		
		private function orderPages($page:Page, $order:int):Array
		{
			return MDProvider.instance.program.ordPage($page, $order);
		}
		
		private var parent:Page;
		
		private var page:Page;
		
		private var order:int;
		
		private var orders:Array;
		
		private var last:uint;
		
		private var pres:uint;
		
	}
}