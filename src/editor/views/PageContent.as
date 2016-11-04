package editor.views
{
	import cn.mvc.collections.Map;
	
	import editor.core.MDProvider;
	import editor.core.MDVars;
	import editor.core.ed;
	import editor.utils.AppUtil;
	import editor.utils.CanvasUtil;
	import editor.utils.CommandUtil;
	import editor.utils.ComponentUtil;
	import editor.utils.PageUtil;
	import editor.views.sheets.Layout_PageItem;
	import editor.vos.Component;
	import editor.vos.Page;
	import editor.vos.Sheet;
	
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import mx.core.UIComponent;
	
	import spark.components.Group;

	public final class PageContent extends _InternalContent
	{
		public function PageContent()
		{
			super();
		}
		
		private function findMax($property:String):Number
		{
			var max:Number = 0.0;
			for each (var $page:Page in MDProvider.instance.program.pages)
			{
				if ($page[$property] > max) max = $page[$property]; 
			}
			return max;
		}
		
		/**
		 * 
		 * 更新视图。
		 * 
		 */
		
		public function update():void
		{
			ed::selectedItem = lastSelectedItem = null;			
			
			background.graphics.clear();
			
			container.removeAllElements();
			editing.removeAllElements();
			
			itemsMap.clear();
			
			width  = findMax("width")  < 1920 ? 1920 : findMax("width");
			height = findMax("height") < 1080 ? 1080 : findMax("height");
			
			background.graphics.beginFill(0xffffff);
			background.graphics.drawRect(0, 0, width, height);
			background.graphics.endFill();
			for each (var item:Page in provider.program.pages) updatePage(item, 1);
			if (config.selectedSheet) selectedItem = itemsMap[config.selectedSheet.id];
		}
		
		/**
		 * 
		 * 更新元素。
		 * 0 : 修改
		 * 1 : 添加
		 * 2 : 删除
		 * 
		 */
		
		public function updatePage($page:Page, $type:uint = 0):Layout_PageItem
		{
			switch ($type)
			{
				case 0:
					if (itemsMap[$page.id])
					{
						var item:Layout_PageItem = itemsMap[$page.id];
						item.update();
					}
					break;
				case 1:
					if(!itemsMap[$page.id])
					{
						item = new Layout_PageItem;
						item.page = $page;
						container.addElement(item);
						itemsMap[$page.id] = item;
					}
					break;
				case 2:
					if (itemsMap[$page.id])
					{
						item = itemsMap[$page.id];
						
						if (selectedItem == item)
							selectedItem = null;
						
						if (editing.containsElement(item))
							editing.removeElement(item);
						else if (container.containsElement(item))
							container.removeElement(item);
						
						delete itemsMap[$page.id];
					}
					break;
			}
			
			return item;
		}
		
		
		/**
		 * @inheritDoc
		 */
		
		override protected function createChildren():void
		{
			super.createChildren();
			
			addElement(background);
			addElement(container);
			addElement(editing);
			addElement(ruleContainer);
			
			ruleContainer.width = width;
			ruleContainer.height = height;
			
			background.mouseChildren = background.mouseEnabled = false;
			
			addEventListener(MouseEvent.MOUSE_DOWN, item_mouseDownHandler);
			addEventListener(MouseEvent.CLICK, item_clickHandler);
		}
		
		
		/**
		 * @private
		 */
		private function item_mouseDownHandler($e:MouseEvent):void
		{
			moving = false;
			down = new Point(mouseX, mouseY);
			var item:Layout_PageItem = PageUtil.convertPageItem($e.target);
			if (item)
			{
				//编辑模式下立即停止冒泡。
				if (AppUtil.isEditMode()) $e.stopImmediatePropagation();
				dragging = item;
				stat.x = dragging.x;
				stat.y = dragging.y;
				//对齐
				if(config.alignMode) ruleContainer.controlLine(dragging);
				
				stage.addEventListener(MouseEvent.MOUSE_MOVE, item_mouseMoveHandler);
				stage.addEventListener(MouseEvent.MOUSE_UP, item_mouseUpHandler);
			}
		}
		
		/**
		 * @private
		 */
		private function item_mouseMoveHandler($e:MouseEvent):void
		{
			
			var mouse:Point = new Point(mouseX, mouseY);
			if (config.mode == "edit" && moving)
			{
				if (dragging)
				{
					var plus:Point = mouse.subtract(down);
					var tempX:Number = stat.x + plus.x;
					var tempY:Number = stat.y + plus.y;
					if (config.alignMode)
					{
						showLine(dragging);
						tempX = CanvasUtil.autoCombine(dragging, new Point(tempX, tempY)).x;
						tempY = CanvasUtil.autoCombine(dragging, new Point(tempX, tempY)).y;
					}
					dragging.x = ComponentUtil.reviseComponent(tempX, width  - dragging.width);
					dragging.y = ComponentUtil.reviseComponent(tempY, height  - dragging.height);
				}
			}
			else
			{
				if (Point.distance(mouse, down) > 5) 
				{
					moving = true;
					down = mouse;
				}
			}
		}
		
		
		/**
		 * @private
		 */
		private function item_mouseUpHandler($e:MouseEvent):void
		{
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, item_mouseMoveHandler);
			stage.removeEventListener(MouseEvent.MOUSE_UP, item_mouseUpHandler);
			
			if (dragging && moving)
			{
				var plus:Point = new Point(mouseX, mouseY).subtract(down);
				CommandUtil.edtSheet(dragging.page, {
					x: dragging.x,
					y: dragging.y
				});
			}
			dragging = null;
			
			ruleContainer.cleanLine();
		}
		
		/**
		 * @private
		 */
		private function item_clickHandler($e:MouseEvent):void
		{
			if(!moving) 
			{
				var item:Layout_PageItem = PageUtil.convertPageItem($e.target);
				if (item)
					config.selectedSheet = item ? item.page : null;
				else 
					config.selectedSheet = null;
			}
		}
		
		
		/**
		 * 
		 * 获取组件个数。
		 * 
		 */
		
		public function get numComponents():uint
		{
			return container.numElements + editing.numElements;
		}
		
		
		/**
		 * 
		 * 选中的组件视图。
		 * 
		 */
		
		public function get selectedComponent():Page
		{
			return ed::selectedComponent;
		}
		
		/**
		 * @private
		 */
		public function set selectedComponent($value:Page):void
		{
			if ($value!= selectedComponent)
			{
				ed::selectedComponent = $value;
				selectedItem = selectedComponent ? itemsMap[selectedComponent.id] : null;
			}
		}
		
		/**
		 * 
		 * 选中的组件视图。
		 * 
		 */
		
		[Bindable]
		public function get selectedItem():Layout_PageItem
		{
			return ed::selectedItem;
		}
		
		/**
		 * @private
		 */
		public function set selectedItem($value:Layout_PageItem):void
		{
			if ($value != selectedItem)
			{
				lastSelectedItem = selectedItem;
				ed::selectedItem = $value;
				
				if (lastSelectedItem) 
					container.addElement(lastSelectedItem);
				if (selectedItem) editing.addElement(selectedItem);
			}
		}
		
		/**
		 * 
		 * 数据源。
		 * 
		 */
		
		public function get sheet():Sheet
		{
			return ed::sheet;
		}
		
		/**
		 * @private
		 */
		public function set sheet($value:Sheet):void
		{
			ed::sheet = $value;
			
			update();
		}
		
		private function get provider():MDProvider
		{
			return MDProvider.instance;
		}
		
		/**
		 * 
		 * 返回所有组件
		 * 
		 */
		public function get itemsMap():Map
		{
			return ed::itemsMap;
		}
		
		private function get pageArrs():Map
		{
			return provider.program.sheets;
		}
		
		private function get content():PageContent
		{
			return vars.canvas.content as PageContent;
		}
		
		private function get vars():MDVars
		{
			return MDVars.instance;
		}
		
		/**
		 * @private
		 */
		private var lastSelectedItem:Layout_PageItem;
		
		/**
		 * @private
		 */
		private var container:Group = new Group;
		
		/**
		 * @private
		 */
		private var editing:Group = new Group;
		
		/**
		 * @private
		 */
		private var background:UIComponent = new UIComponent;
		
		
		/**
		 * @private
		 */
		
		/**
		 * @private
		 */
		private var dragging:Layout_PageItem;
		
		/**
		 * @private
		 */
		private var moving:Boolean;
		
		/**
		 * @private
		 */
		private var down:Point;
		
		/**
		 * @private
		 */
		private var stat:Point = new Point;
		
		/**
		 * @private
		 */
		ed var sheet:Sheet;
		
		/**
		 * @private
		 */
		ed var itemsMap:Map = new Map;

		
		/**
		 * @private
		 */
		ed var selectedItem:Layout_PageItem;
		
		/**
		 * @private
		 */
		ed var selectedComponent:Page;
	}
}