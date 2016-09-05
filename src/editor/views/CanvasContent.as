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
	import cn.mvc.utils.RectangleUtil;
	
	import editor.core.MDVars;
	import editor.core.ed;
	import editor.utils.CommandUtil;
	import editor.utils.ComponentUtil;
	import editor.views.canvas.Viewer;
	import editor.views.components.CanvasItem;
	import editor.vos.Component;
	import editor.vos.ComponentType;
	import editor.vos.Sheet;
	
	import flash.display.FrameLabel;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.engine.ContentElement;
	
	import mx.controls.HRule;
	import mx.controls.VRule;
	import mx.core.UIComponent;
	import mx.events.DragEvent;
	import mx.managers.DragManager;
	
	import spark.components.Group;
	
	import w11k.flash.AngularJSAdapter;
	
	
	public final class CanvasContent extends _InternalView
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
		 * 更新视图。
		 * 
		 */
		
		public function update():void
		{
			ed::selectedItem = lastSelectedItem = null;
			
			background.graphics.clear();
			
			container.removeAllElements();
			editing.removeAllElements();
			
			_dic.clear();
			
			if (sheet)
			{
				width  = sheet.width;
				height = sheet.height;
				
				background.graphics.beginFill(ColorUtil.colorString2uint(sheet.backgroundColor));
				background.graphics.drawRect(0, 0, width, height);
				background.graphics.endFill();
				
				for each (var item:Component in sheet.componentsArr) updateComponent(item, 1);
				
				if (config.selectedComponent) selectedItem = dic[config.selectedComponent.id];
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
		 * 
		 */
		
		public function updateComponent($component:Component, $type:uint = 0):CanvasItem
		{
			switch ($type)
			{
				case 0:
					if (_dic[$component.id])
					{
						var item:CanvasItem = _dic[$component.id];
						item.update();
					}
					break;
				case 1:
					if(!_dic[$component.id])
					{
						item = new CanvasItem;
						item.component = $component;
						container.addElement(item);
						_dic[$component.id] = item;
					}
					break;
				case 2:
					if (_dic[$component.id])
					{
						item = _dic[$component.id];
						
						if (selectedItem == item)
							selectedItem = null;
						
						if (editing.containsElement(item))
							editing.removeElement(item);
						else if (container.containsElement(item))
							container.removeElement(item);
						
						delete _dic[$component.id];
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
			if ($e.target is CanvasItem)
			{
				if (config.mode == "edit") $e.stopImmediatePropagation();
				dragging = $e.target as CanvasItem;
				stat.x = dragging.x;
				stat.y = dragging.y;
				if(config.alignMode)
				{
					controlLine(dragging);
				}
				stage.addEventListener(MouseEvent.MOUSE_MOVE, item_mouseMoveHandler);
				stage.addEventListener(MouseEvent.MOUSE_UP, item_mouseUpHandler);
			}
		}
		
		
		
		/**
		 * 
		 * 获取辅助线属性。
		 * @param $recMove:CanvasItem : 所需获取辅助线属性的元素。
		 * 
		 */
		public function showWhere($recMove:CanvasItem, $forbid:* = "all"):Object
		{
			if ($recMove)
			{
				if ($forbid is Array) var flag:Boolean = true;
				var pointR:Point = $recMove.center;
				var compare:Function = function(a:Rectangle, b:Rectangle):int
				{
					var pointA:Point = RectangleUtil.getCenter(a);
					var pointB:Point = RectangleUtil.getCenter(b);
					var temp:Number = Point.distance(pointA, pointR) - Point.distance(pointB, pointR);
					return temp > 0 ? 1 : (temp < 0 ? -1 : 0);
				};
				var obj:Object = {"Ver":null, "Hor":null};
				
				var newRects:Vector.<Rectangle> = getComponentRects($recMove);
				
				var scale:Number = MDVars.instance.canvas.viewer.contentScale;
				
				newRects.sort(compare);
				
				var item:Rectangle;
				//遍历X方向
				for each (item in newRects)
				{
					if (item)
					{
						if (flag) $forbid = "right";
						if (($forbid == "left" || $forbid == "all") && (MathUtil.isBetween(item.left - 5 / scale, $recMove.x, item.left + 5 / scale) ||
							MathUtil.isBetween(item.right - 5 / scale, $recMove.x, item.right + 5 / scale)))
						{
							obj["Ver"] = MathUtil.near(item.right, $recMove.x, item.left);
							break;
						}
						else if (($forbid == "right" || $forbid == "all") && (MathUtil.isBetween(item.left - 5 / scale, $recMove.x + $recMove.width, item.left + 5 / scale) || 
							MathUtil.isBetween(item.right - 5 / scale, $recMove.x + $recMove.width, item.right + 5 / scale)))
						{
							obj["Ver"] = MathUtil.near(item.right, $recMove.x + $recMove.width, item.left);
							break;
						}
					}// if (item)
				}// for each
				//遍历Y方向
				for each (item in newRects)
				{
					if (item)
					{
						if (flag) $forbid = "bottom";
						if (($forbid == "bottom" || $forbid == "all") && (MathUtil.isBetween(item.top - 5 / scale, $recMove.y + $recMove.height, item.top + 5 / scale) || 
							MathUtil.isBetween(item.bottom - 5 / scale, $recMove.y + $recMove.height, item.bottom + 5 / scale)))
						{
							obj["Hor"] = MathUtil.near(item.bottom, $recMove.y + $recMove.height, item.top);
							break;
						}
						else if (($forbid == "top" || $forbid == "all") && (MathUtil.isBetween(item.top - 5 / scale, $recMove.y, item.top + 5 / scale) || 
								MathUtil.isBetween(item.bottom - 5 / scale, $recMove.y, item.bottom + 5 / scale)))
							{
								obj["Hor"] = MathUtil.near(item.bottom, $recMove.y, item.top);
								break;
							}
					}// if (item)
				}
			}
			return obj;
		}
		
		
		
		/**
		 * 
		 * @private
		 * 
		 */
		private function controlLine($data:Object):void
		{
			for (var state:String in $data)
			{
				var $rule:*;
				var lineColor:uint = 0x00FFFFFF - ColorUtil.colorString2uint(config.editingSheet.backgroundColor);
				if ($data[state] != null)
				{
					if (state == "Ver")
					{
						$rule = vlrule;
						$rule.x = $data[state];
						$rule.height = 2000;
						$rule.setStyle("strokeWidth", 2);
						$rule.setStyle("shadowColor", lineColor);
						$rule.setStyle("strokeColor", lineColor);
						ruleContainer.addElement($rule);
					}
					else if (state == "Hor")
					{
						$rule = htrule;
						$rule.y = $data[state];
						$rule.width = 2000;
						$rule.setStyle("strokeWidth", 2);
						$rule.setStyle("shadowColor", lineColor);
						$rule.setStyle("strokeColor", lineColor);
						ruleContainer.addElement($rule);
					}
				}
				else
				{
					cleanLine(state);
				}
			}
		}
		
		
		/**
		 * 
		 * 清除辅助线。
		 * @param $state:String 所需清除的辅助线位置。默认为"all"即全部删除。
		 * 
		 */
		public function cleanLine($state:String = "all"):void
		{
				switch($state)
				{
					case "all" : ;
					case "Hor":
					{
						if (ruleContainer.containsElement(htrule))
							ruleContainer.removeElement(htrule);
						if ($state != "all") break;
					}
					case "Ver":
					{
						if (ruleContainer.containsElement(vlrule)) 
							ruleContainer.removeElement(vlrule);
						if ($state != "all") break;
					}
				}
		}
		
		/**
		 * 
		 * 展示辅助线。
		 * @param $currentComponent : 需要被展示辅助线的组件
		 * @param $forbid:限制参数  : 当为String时，只允许获取该参数对应边的参数。<br>
		 *     当为一个Array时表示只允许right和bottom。其默认值为all表示无限制全部允许获取。<br>
		 *     可能的值为“left”, “right”, "bottom", "top", "all" 和 任意一个数组类型。
		 * 
		 */
		public function showLine($currentComponent:CanvasItem, $forbid:* = "all"):void
		{
			var obj:Object = showWhere($currentComponent, $forbid);
			controlLine(obj);
		}
		
		/**
		 * 
		 * 返回满足吸附条件的点/Object。
		 * @param $currentComponent : 需要被合并的组件
		 * @param $point : 能否被吸附的点
		 * @param $isMoving : 返回point还是Object
		 * 
		 */
		public function autoCombine($currentComponent:CanvasItem, $point:Point, $isMoving:Boolean = true, $forbid:String = "all"):*
		{
			var scale:Number = MDVars.instance.canvas.viewer.contentScale;
			
			var obj:Object = showWhere($currentComponent, $forbid);
			var tempX:Number;
			var tempW:Number;
			var tempY:Number;
			var tempH:Number;
			if (obj["Ver"] != null)
			{
				if (obj["Ver"] > $currentComponent.center.x)
				{
					if ($isMoving)
					{
						tempX = MathUtil.isBetween(obj["Ver"] - 5 / scale, $point.x + $currentComponent.width, obj["Ver"] + 5 / scale)
							? obj["Ver"] - $currentComponent.width : $point.x;
					}
					else
					{
						tempW = MathUtil.isBetween(obj["Ver"] - 5 / scale, $point.x + $currentComponent.x, obj["Ver"] + 5 / scale)
							? obj["Ver"] - $currentComponent.x : $point.x;
					}
					
				}
				else //线在左边
				{
					tempX = MathUtil.isBetween(obj["Ver"] - 5 / scale, $point.x, obj["Ver"] + 5 / scale)
						? obj["Ver"] : $point.x;
					tempW = $point.x;
				}
			}
			else //不在吸附范围内
			{
				tempX = tempW = $point.x;
				trace("Ver not in")
			}
			
			if (obj["Hor"] != null) 
			{
				if (obj["Hor"] > $currentComponent.center.y)
				{
					if ($isMoving)
					{
						tempY = MathUtil.isBetween(obj["Hor"] - 5 / scale, $point.y + $currentComponent.height, obj["Hor"] + 5 / scale)
							? obj["Hor"] - $currentComponent.height : $point.y;
					}
					else
					{
						tempH = MathUtil.isBetween(obj["Hor"] - 5 / scale, $point.y + $currentComponent.y, obj["Hor"] + 5 / scale)
							? obj["Hor"] - $currentComponent.y : $point.y;
					}
					
				}
				else //线在上边
				{
					tempY = MathUtil.isBetween(obj["Hor"] - 5 / scale, $point.y, obj["Hor"] + 5 / scale)
						? obj["Hor"] : $point.y;
					tempH = $point.y;
				}
				
			}
			else
			{
				tempY = tempH = $point.y;
			}
			return $isMoving ? new Point(tempX, tempY) : {"point":new Point(tempX, tempY), "tempW":tempW, "tempH":tempH};
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
						tempX = autoCombine(dragging, new Point(tempX, tempY)).x;
						tempY = autoCombine(dragging, new Point(tempX, tempY)).y;
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
			cleanLine();
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
			cleanLine();
		}
		
		/**
		 * @private
		 */
		private function item_clickHandler($e:MouseEvent):void
		{
			if(!moving) 
			{
				var item:CanvasItem = $e.target as CanvasItem;
				config.selectedSheet = null;
				config.selectedComponent = item ? item.component : null;
			}
		}
		
		/**
		 * @private
		 */
		private function item_doubleClickHandler($e:MouseEvent):void
		{
			if ($e.target is CanvasItem)
			{
				var item:CanvasItem = $e.target as CanvasItem;
				if (config.mode == "edit")
				{
					var rectangle:Rectangle = ComponentUtil.getMaxmizeRect(item.rect, getComponentRects(item), rect);
					CommandUtil.edtComponent(item.component, {
						x: rectangle.x,
						y: rectangle.y,
						width : rectangle.width,
						height: rectangle.height
					});
				}
				else if (config.mode == "fill")
				{
					CommandUtil.fillComponent(item.component.id, item.component.componentTypeCode);
					Debugger.log("填充内容：组件ID = " + item.component.id + "，组件编码 = " + item.component.componentTypeCode);
				}
			}
		}
		
		
		/**
		 * 
		 * 获取除该元素外其他子元素占位集合。
		 * 
		 */
		
		public function getComponentRects($component:CanvasItem = null):Vector.<Rectangle>
		{
			var vec:Vector.<Rectangle> = new Vector.<Rectangle>;
			for each (var item:CanvasItem in _dic) 
				if (item != $component) vec.push(item.rect);
			return vec;
		}
		
		
		/**
		 * 
		 * 获取画布矩形占位。
		 * 
		 */
		
		public function get rect():Rectangle
		{
			return new Rectangle(0, 0, width, height);
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
					container.addElementAt(lastSelectedItem, MathUtil.clamp(lastSelectedItem.order, 0, numElements));
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
				selectedItem = selectedComponent ? _dic[selectedComponent.id] : null;
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
		public function get dic():Map
		{
			return _dic;
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
		private var vlrule:VRule = new VRule;
		
		
		/**
		 * @private
		 */
		private var htrule:HRule = new HRule;
		
		
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
		private var _dic:Map = new Map;
		
		private var ruleContainer:Group = new Group;
		
		
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