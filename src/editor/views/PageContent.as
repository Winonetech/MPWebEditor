package editor.views
{
	import cn.mvc.collections.Map;
	import cn.mvc.utils.ColorUtil;
	import cn.mvc.utils.MathUtil;
	
	import editor.core.MDConfig;
	import editor.core.MDProvider;
	import editor.core.MDVars;
	import editor.core.ed;
	import editor.views.components.CanvasItem;
	import editor.views.sheets.Layout_PageItem;
	import editor.vos.Page;
	import editor.vos.Sheet;
	
	import flash.geom.Point;
	
	import mx.core.UIComponent;
	
	import spark.components.Group;

	public final class PageContent extends _InternalContent
	{
		public function PageContent()
		{
			super();
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
			
						
			
			
			
			
			width  = 1920;
			height = 1080;
			background.graphics.beginFill(0xffffff);
			background.graphics.drawRect(0, 0, width, height);
			background.graphics.endFill();
			canvas.addElement(this);
//			container.addElement(new Canvas4LayoutItem);
//				for each (var item:* in ) 
//				{
//					if (item is Page)
//					{
//						item = item as Page;
//						updatePage(item, 1);
//					}
//				}
				
		}
		
		
		
		/**
		 * 
		 * 更新元素。
		 * 0 : 修改
		 * 1 : 添加
		 * 2 : 删除
		 * 
		 */
		
		public function updatePage($component:Sheet, $type:uint = 0):CanvasItem
		{
			switch ($type)
			{
				case 0:
					if (itemsMap[$component.id])
					{
						var item:CanvasItem = itemsMap[$component.id];
						item.update();
					}
					break;
				case 1:
					if(!itemsMap[$component.id])
					{
						item = new CanvasItem;
//						item.component = $component;
						container.addElement(item);
						itemsMap[$component.id] = item;
					}
					break;
				case 2:
					if (itemsMap[$component.id])
					{
						item = itemsMap[$component.id];
						
						if (selectedItem == item)
							selectedItem = null;
						
						if (editing.containsElement(item))
							editing.removeElement(item);
						else if (container.containsElement(item))
							container.removeElement(item);
						
						delete itemsMap[$component.id];
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
			
//			addEventListener(DragEvent.DRAG_ENTER, type_dragEnterHandler);
//			addEventListener(DragEvent.DRAG_DROP , type_dragDropHandler);
//			
//			addEventListener(MouseEvent.MOUSE_DOWN, item_mouseDownHandler);
//			addEventListener(MouseEvent.CLICK, item_clickHandler);
//			addEventListener(MouseEvent.DOUBLE_CLICK, item_doubleClickHandler);
		}
		
		
		/**
		 * @private
		 */
//		private function type_dragEnterHandler($e:DragEvent):void
//		{
//			if ($e.dragSource.hasFormat("componentType"))
//				DragManager.acceptDragDrop($e.currentTarget as UIComponent);
//		}
//		
//		/**
//		 * @private
//		 */
//		private function type_dragDropHandler($e:DragEvent):void
//		{
//			var type:ComponentType = $e.dragSource.dataForFormat("componentType") as ComponentType;
//			CommandUtil.addComponent(sheet, type, numComponents, 
//				ComponentUtil.reviseComponent(mouseX, width - 45),
//				ComponentUtil.reviseComponent(mouseY, height - 30));
//		}
//		
//		/**
//		 * @private
//		 */
//		private function item_mouseDownHandler($e:MouseEvent):void
//		{
//			moving = false;
//			down = new Point(mouseX, mouseY);
//			var item:CanvasItem = ComponentUtil.convertCanvasItem($e.target);
//			if (item)
//			{
//				//编辑模式下立即停止冒泡。
//				if (AppUtil.isEditMode()) $e.stopImmediatePropagation();
//				dragging = item;
//				stat.x = dragging.x;
//				stat.y = dragging.y;
//				//对齐
//				if(config.alignMode) ruleContainer.controlLine(dragging);
//				
//				stage.addEventListener(MouseEvent.MOUSE_MOVE, item_mouseMoveHandler);
//				stage.addEventListener(MouseEvent.MOUSE_UP, item_mouseUpHandler);
//			}
//		}
//		
//		/**
//		 * @private
//		 */
//		private function item_mouseMoveHandler($e:MouseEvent):void
//		{
//			
//			var mouse:Point = new Point(mouseX, mouseY);
//			if (config.mode == "edit" && moving)
//			{
//				if (dragging)
//				{
//					var plus:Point = mouse.subtract(down);
//					var tempX:Number = stat.x + plus.x;
//					var tempY:Number = stat.y + plus.y;
//					if (config.alignMode)
//					{
//						showLine(dragging);
//						tempX = CanvasUtil.autoCombine(dragging, new Point(tempX, tempY)).x;
//						tempY = CanvasUtil.autoCombine(dragging, new Point(tempX, tempY)).y;
//					}
//					dragging.x = ComponentUtil.reviseComponent(tempX, width  - dragging.width);
//					dragging.y = ComponentUtil.reviseComponent(tempY, height  - dragging.height);
//				}
//			}
//			else
//			{
//				if (Point.distance(mouse, down) > 5) 
//				{
//					moving = true;
//					down = mouse;
//				}
//			}
//		}
//		
//		
//		/**
//		 * @private
//		 */
//		private function item_mouseUpHandler($e:MouseEvent):void
//		{
//			stage.removeEventListener(MouseEvent.MOUSE_MOVE, item_mouseMoveHandler);
//			stage.removeEventListener(MouseEvent.MOUSE_UP, item_mouseUpHandler);
//			
//			if (dragging && moving)
//			{
//				var plus:Point = new Point(mouseX, mouseY).subtract(down);
//				CommandUtil.edtComponent(dragging.component, {
//					x: dragging.x,
//					y: dragging.y
//				});
//			}
//			dragging = null;
//			
//			ruleContainer.cleanLine();
//		}
//		
//		/**
//		 * @private
//		 */
//		private function item_clickHandler($e:MouseEvent):void
//		{
//			if(!moving) 
//			{
//				var item:CanvasItem = ComponentUtil.convertCanvasItem($e.target);
//				if (item)
//				{
//					config.selectedSheet = null;
//					config.selectedComponent = item ? item.component : null;
//				}
//			}
//		}
//		
//		/**
//		 * @private
//		 */
//		private function item_doubleClickHandler($e:MouseEvent):void
//		{
//			var item:CanvasItem = ComponentUtil.convertCanvasItem($e.target);
//			if (item)
//			{
//				if (AppUtil.isEditMode())
//				{
//					var rectangle:Rectangle = CanvasUtil.getMaxmizeRect(
//						CanvasUtil.getRect(item), 
//						CanvasUtil.getExceptRects(itemsMap, item), 
//						new Rectangle(0, 0, width, height));
//					CommandUtil.edtComponent(item.component, {
//						x: rectangle.x,
//						y: rectangle.y,
//						width : rectangle.width,
//						height: rectangle.height
//					});
//				}
//				else if (AppUtil.isFillMode())
//				{
//					CommandUtil.fillComponent(item.component.id, item.component.componentTypeCode);
//					Debugger.log("填充内容：组件ID = " + item.component.id + "，组件编码 = " + item.component.componentTypeCode);
//				}
//			}
//		}
		
		
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
		
		[Bindable]
		public function get selectedItem():CanvasItem
		{
			return ed::selectedItem;
		}
		
		/**
		 * @private
		 */
		public function set selectedItem($value:CanvasItem):void
		{
			if ($value!= selectedItem)
			{
				lastSelectedItem = selectedItem;
				ed::selectedItem = $value;
				
				if (lastSelectedItem) 
					container.addElementAt(lastSelectedItem, MathUtil.clamp(lastSelectedItem.order, 0, numElements));
				if (selectedItem) editing.addElement(selectedItem);
			}
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
		
		private function get canvas():*
		{
			var temp:* = vars.canvas.content;
			return (temp is CanvasContent) ? temp as CanvasContent : temp as PageContent;
		}
		
		private function get vars():MDVars
		{
			return MDVars.instance;
		}
		
		public function get c4lc():PageContent
		{
			return this;
		}
		/**
		 * @private
		 */
		private var lastSelectedItem:CanvasItem;
		
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
		private var dragging:CanvasItem;
		
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
		ed var itemsMap:Map = new Map;

		
		/**
		 * @private
		 */
		ed var selectedItem:CanvasItem;
		
	}
}