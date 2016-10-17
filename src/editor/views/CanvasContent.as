package editor.views
{
	
	/**
	 * 
	 * 画布内容。
	 * 
	 */
	import cn.mvc.collections.Map;
	import cn.mvc.utils.ColorUtil;
	import cn.mvc.utils.MathUtil;
	
	import editor.core.ed;
	import editor.utils.AppUtil;
	import editor.utils.CanvasUtil;
	import editor.utils.CommandUtil;
	import editor.utils.ComponentUtil;
	import editor.views.components.CanvasItem;
	import editor.vos.Component;
	import editor.vos.ComponentType;
	import editor.vos.Sheet;
	
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import mx.core.UIComponent;
	import mx.events.DragEvent;
	import mx.managers.DragManager;
	
	import spark.components.Group;
	import spark.components.Image;
	
	
	public final class CanvasContent extends _InternalContent
	{
		
		/**
		 * 
		 * 构造函数。
		 * 
		 */
		
		public function CanvasContent()
		{
			super();
		}
		
		
		/**
		 * 
		 * 内容初始化
		 * 
		 */
		private function initContent():void
		{
			ed::selectedItem = lastSelectedItem = null;
			background.graphics.clear();
			container.removeAllElements();
			editing.removeAllElements();
			itemsMap.clear();
		}
		
		/**
		 * 
		 * 更新视图。
		 * 
		 */
		
		public function update():void
		{
			initContent();
			
			if (sheet)
			{
				width  = sheet.width;
				height = sheet.height;
				
				if (!(!sheet.background))
				{
					Debugger.log(sheet.background);
					backgroundImg.source = sheet.background;
					container.addElementAt(backgroundImg, 0);
				}
				
				background.graphics.beginFill(ColorUtil.colorString2uint(sheet.backgroundColor));
				background.graphics.drawRect(0, 0, width, height);
				background.graphics.endFill();
				for each (var item:Component in sheet.componentsArr) updateComponent(item, 1);
				
				if (config.selectedComponent) selectedItem = itemsMap[config.selectedComponent.id];
			}
		}
		
		
		/**
		 * 
		 * 添加元素视图。
		 * 
		 */
		
		public function addSheetElement($element:Component):void
		{
			
		}
		
		
		/**
		 * 
		 * 删除元素视图。
		 * 
		 */
		
		public function delSheetElement($element:Component):void
		{
			
		}
		
		
		/**
		 * 
		 * 修改元素视图。
		 * 
		 */
		
		public function modSheetElement($element:Component):void
		{
		}
		
		/**
		 * 
		 * 更新元素。
		 * 0 : 修改
		 * 1 : 添加
		 * 2 : 删除
		 * 
		 */
		
		public function updateComponent($component:Component, $type:uint = 0):CanvasItem
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
						item.component = $component;
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
			
			addEventListener(DragEvent.DRAG_ENTER, type_dragEnterHandler);
			addEventListener(DragEvent.DRAG_DROP , type_dragDropHandler);
			
			addEventListener(MouseEvent.MOUSE_DOWN, item_mouseDownHandler);
			addEventListener(MouseEvent.CLICK, item_clickHandler);
			addEventListener(MouseEvent.DOUBLE_CLICK, item_doubleClickHandler);
		}
		
		
		/**
		 * @private
		 */
		private function type_dragEnterHandler($e:DragEvent):void
		{
			if ($e.dragSource.hasFormat("componentType"))
				DragManager.acceptDragDrop($e.currentTarget as UIComponent);
		}
		
		/**
		 * @private
		 */
		private function type_dragDropHandler($e:DragEvent):void
		{
			var type:ComponentType = $e.dragSource.dataForFormat("componentType") as ComponentType;
			CommandUtil.addComponent(sheet, type, numComponents, 
				ComponentUtil.reviseComponent(mouseX, width - 45),
				ComponentUtil.reviseComponent(mouseY, height - 30));
		}
		
		/**
		 * @private
		 */
		private function item_mouseDownHandler($e:MouseEvent):void
		{
			moving = false;
			down = new Point(mouseX, mouseY);
			var item:CanvasItem = ComponentUtil.convertCanvasItem($e.target);
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
				CommandUtil.edtComponent(dragging.component, {
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
				var item:CanvasItem = ComponentUtil.convertCanvasItem($e.target);
				if (item)
				{
					config.selectedSheet = null;
					config.selectedComponent = item ? item.component : null;
				}
				else config.selectedComponent = null;
			}
		}
		
		/**
		 * @private
		 */
		private function item_doubleClickHandler($e:MouseEvent):void
		{
			var item:CanvasItem = ComponentUtil.convertCanvasItem($e.target);
			if (item)
			{
				if (AppUtil.isEditMode())
				{
					var rectangle:Rectangle = CanvasUtil.getMaxmizeRect(
						CanvasUtil.getRect(item), 
						CanvasUtil.getExceptRects(itemsMap, item), 
						new Rectangle(0, 0, width, height));
					CommandUtil.edtComponent(item.component, {
						x: rectangle.x,
						y: rectangle.y,
						width : rectangle.width,
						height: rectangle.height
					});
				}
				else if (AppUtil.isFillMode())
				{
					CommandUtil.fillComponent(item.component.id, item.component.componentTypeCode);
					Debugger.log("填充内容：组件ID = " + item.component.id + "，组件编码 = " + item.component.componentTypeCode);
				}
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
					container.addElementAt(lastSelectedItem, 
						MathUtil.clamp(lastSelectedItem.order, container.containsElement(backgroundImg)
							? 1 : 0, numElements));
				if (selectedItem) editing.addElement(selectedItem);
			}
		}
		
		
		/**
		 * 
		 * 选中的组件视图。
		 * 
		 */
		
		public function get selectedComponent():Component
		{
			return ed::selectedComponent;
		}
		
		/**
		 * @private
		 */
		public function set selectedComponent($value:Component):void
		{
			if ($value!= selectedComponent)
			{
				ed::selectedComponent = $value;
				selectedItem = selectedComponent ? itemsMap[selectedComponent.id] : null;
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
		
		
		/**
		 * 
		 * 返回所有组件
		 * 
		 */
		public function get itemsMap():Map
		{
			return ed::itemsMap;
		}
		
		/**
		 * @private
		 */
		private var backgroundImg:Image = new Image;
		
		
		/**
		 * @private
		 */
		private var lastSelectedItem:CanvasItem;
		
		/**
		 * @private
		 */
		public var container:Group = new Group;
		
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
		ed var sheet:Sheet;
		
		/**
		 * @private
		 */
		ed var selectedItem:CanvasItem;
		
		/**
		 * @private
		 */
		ed var selectedComponent:Component;
		
	}
}