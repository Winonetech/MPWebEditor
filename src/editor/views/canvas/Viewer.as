package editor.views.canvas
{
	
	/**
	 * 
	 * 画布视图。
	 * 
	 */
	
	
	import caurina.transitions.Tweener;
	
	import cn.mvc.utils.MathUtil;
	
	import editor.core.MDConfig;
	import editor.core.ed;
	import editor.views.CanvasContent;
	import editor.views.Debugger;
	
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import mx.controls.HRule;
	import mx.core.IVisualElement;
	import mx.core.UIComponent;
	
	import spark.components.Group;
	import spark.primitives.Line;
	
	
	[Event(name="contentUpdateLayout", type="editor.events.ViewerEvent")]
	
	
	[Bindable]
	public class Viewer extends Group
	{
		
		/**
		 * 
		 * 构造函数。
		 * 
		 */
		
		public function Viewer()
		{
			super();
		}
		
		
		/**
		 * 
		 * 重置缩放与位置。
		 * 
		 */
		
		public function reset($tween:Boolean = false):void
		{
			aimScale = isNaN(resetScale) ? 1 : resetScale;
			aimX = isNaN(resetX)
				?(width - scaledWidth) * .5
				:-resetX * aimScale + width * .5;
			aimY = isNaN(resetY)
				?(height - scaledHeight) * .5
				:-resetY * aimScale + height * .5;
			
			restrictScale();
			restrictXY();
			
			Tweener.removeTweens(this);
			
			if ($tween)
			{
				updateTween();
			}
			else
			{
				contentScale = aimScale;
				contentX = aimX;
				contentY = aimY;
			}
		}
		
		
		/**
		 * 
		 * 移动
		 * 
		 */
		
		public function moveTo(x:Number, y:Number, $tween:Boolean = false):void
		{
			aimX = x;
			aimY = y;
			
			restrictXY();
			
			if ($tween)
			{
				updateTween();
			}
			else
			{
				Tweener.removeTweens(this);
				
				contentX = aimX;
				contentY = aimY;
			}
		}
		
		
		/**
		 * 
		 * 缩放
		 * 
		 */
		
		public function scaleTo(scale:Number, $tween:Boolean = false, $center:Point = null):void
		{
			aimScale = scale;
			
			$center = $center || new Point(width * .5, height * .5);
			
			restrictScale($center.x, $center.y);
			
			if ($tween)
			{
				updateTween();
			}
			else
			{
				Tweener.removeTweens(this);
				
				contentScale = aimScale;
				contentX = aimX;
				contentY = aimY;
			}
		}
		
		
		public function update():void
		{
			updateShowGrid();
			
			caculateScale();
			
			resetScale = minScale;
			
			reset();
		}
		
		
		/**
		 * 
		 * 计算缩放最大最小值。
		 * 
		 */
		
		protected function caculateScale():void
		{
			var ow:Number = originWidth;
			var oh:Number = originHeight;
			var ww:Number = width;
			var wh:Number = height;
			
			maxScale = 1;
			minScale = (ow == 0 || oh == 0 || ww == 0 || wh == 0) 
				? 1 :(ow / oh < ww / wh ? wh / oh : ww / ow);
		}
		
		
		/**
		 * @inheritDoc
		 */
		
		override protected function createChildren():void
		{
			super.createChildren();
			
			addEventListener(MouseEvent.MOUSE_DOWN, mouseDown);
			addEventListener(MouseEvent.MOUSE_WHEEL, mouseWheel);
			
			addElement(back = new UIComponent);
			addElement(container = new Group);
			addElement(cover = new UIComponent);
			container.addElement(grid = new Grid);			
			container.mask = cover;
			
			updateShowGrid();
			
			resizeWindow();
		}
		
		
		/**
		 * @inheritDoc
		 */
		
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			
			resizeWindow();
		}
		
		
		/**
		 * @private
		 */
		private function resizeWindow():void
		{
			if (lastWidth != width || lastHeight != height)
			{
				lastWidth  = width;
				lastHeight = height;
				back.graphics.clear();
				back.graphics.beginFill(0, .05);
				back.graphics.drawRect(0, 0, width, height);
				back.graphics.endFill();
				
				cover.graphics.clear();
				cover.graphics.beginFill(0);
				cover.graphics.drawRect(0, 0, width, height);
				cover.graphics.endFill();
				
				
				if (content)
				{
					updateShowGrid();
					
					caculateScale();
					
					restrictScale();
					restrictXY();
					
					contentScale = isNaN(aimScale) ? 1 : aimScale;
					contentX = isNaN(aimX) ? 0 : aimX;
					contentY = isNaN(aimY) ? 0 : aimY;
				}
			}
		}
		
		
		//----------------------
		// 内容缩放移动限制检测
		//----------------------
		
		/**
		 * @private
		 */
		private function restrictScale($x:Number = 0, $y:Number = 0):void
		{
			aimScale = MathUtil.clamp(aimScale, minScale, maxScale);
			if (aimScale!= contentScale)
			{
				//the rate of scale
				var s:Number = aimScale / contentScale;
				//the aim position after scale
				aimX = $x - ($x - contentX) * s;
				aimY = $y - ($y - contentY) * s;
				if (aimScale < contentScale) restrictXY();
			}
		}
		
		/**
		 * @private
		 */
		private function restrictXY():void
		{
			aimX = scaledWidth  < width  ? (width  - scaledWidth ) * .5 : MathUtil.clamp(aimX, minX, maxX);
			aimY = scaledHeight < height ? (height - scaledHeight) * .5 : MathUtil.clamp(aimY, minY, maxY);
		}
		
		/**
		 * @private
		 */
		private function updateTween():void
		{
			Tweener.removeTweens(this);
			Tweener.addTween(this, {
				contentScale:aimScale, 
				contentX:aimX, 
				contentY:aimY, 
				time:1
			});
		}
		
		/**
		 * @private
		 */
		private function updateShowGrid():void
		{
			if (grid) 
			{
				grid.visible = showGrid;
				if (content)
				{
					grid.width  = originWidth;
					grid.height = originHeight;
				}
			}
		}
		
		/**
		 * @private
		 */
		private function updateDragOnly():void
		{
			if (container)
			{
				MDConfig.instance.selectedComponent = null;
				if (MDConfig.instance.isLayoutOpened) MDConfig.instance.selectedSheet = null;
				container.mouseChildren = !dragOnly;
			}
		}
		
		
		/**
		 * @private
		 */
		private function updateContent():void
		{
			if (container && lastContent &&  
				container.containsElement(lastContent))
				
				container.removeElement(lastContent);
			
			if (content)
			{
				updateShowGrid();
				
				container.addElementAt(content, 0);
				caculateScale();
				
				resetScale = minScale;
				
				reset();
			}
		}
		
		/**
		 * @private
		 */
		private function updateContentScale():void
		{
			if (container) container.scaleX = container.scaleY = contentScale;
			if (grid) grid.scale = contentScale;
		}
		
		/**
		 * @private
		 */
		private function updateContentX():void
		{
			if (container) container.x = Math.floor(100 * contentX) * .01;
		}
		
		/**
		 * @private
		 */
		private function updateContentY():void
		{
			if (container) container.y = Math.floor(100 * contentY) * .01;
		}
		
		
		/**
		 * @private
		 */
		private function mouseDown(e:MouseEvent):void
		{
			if (content) 
			{
				lastX = mouseX;
				lastY = mouseY;
				plusX = aimX = contentX;
				plusY = aimY = contentY;
				aimScale = contentScale;
				Tweener.removeTweens(this);
				stage.addEventListener(MouseEvent.MOUSE_MOVE, mouseMove);
				stage.addEventListener(MouseEvent.MOUSE_UP  , mouseUp);
			}
		}
		
		/**
		 * @private
		 */
		private function mouseMove(e:MouseEvent):void
		{
			aimX = mouseX - lastX + plusX;
			aimY = mouseY - lastY + plusY;
			restrictXY();
			updateTween();
		}
		
		/**
		 * @private
		 */
		private function mouseUp(e:MouseEvent):void
		{
			restrictXY();
			updateTween();
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, mouseMove);
			stage.removeEventListener(MouseEvent.MOUSE_UP, mouseUp);
		}
		
		/**
		 * @private
		 */
		private function mouseWheel(e:MouseEvent):void
		{
			if (content)
			{
				aimScale *= e.delta > 0 ? 1.05 : .95;
				restrictScale(mouseX, mouseY);
				updateTween();
			}
		}
		
		
		/**
		 * 
		 * 是否显示网格。
		 * 
		 */
		
		public function get showGrid():Boolean
		{
			return ed::showGrid as Boolean;
		}
		
		/**
		 * @private
		 */
		public function set showGrid($value:Boolean):void
		{
			ed::showGrid = $value;
			
			updateShowGrid();
		}
		
		
		/**
		 * 
		 *  是否可拖动 
		 * 
		 */
		public function get dragOnly():Boolean
		{
			return ed::dragOnly as Boolean;
		}
		
		/**
		 * @private
		 */
		public function set dragOnly($value:Boolean):void
		{
			ed::dragOnly = $value;
			
			updateDragOnly();
		}
		
		
		/**
		 * 
		 *是否开启对齐模式 
		 * 
		 */
		public function get alignMode():Boolean
		{
			return ed::alignMode as Boolean;
		}
		
		/**
		 * 
		 *@private
		 *  
		 */
		public function set alignMode($value:Boolean):void
		{
			ed::alignMode = $value;
		}
		
		
		/**
		 * 
		 * 最小缩放
		 * 
		 */
		
		public function get minScale():Number
		{
			return ed::minScale;
		}
		
		/**
		 * @private
		 */
		public function set minScale(value:Number):void
		{
			ed::minScale = Math.min(value, maxScale);
		}
		
		
		/**
		 * 
		 * 最大缩放
		 * 
		 */
		
		public function get maxScale():Number
		{
			return ed::maxScale;
		}
		
		/**
		 * @private
		 */
		public function set maxScale(value:Number):void
		{
			ed::maxScale = Math.max(value, minScale);
		}
		
		
		/**
		 * 
		 * 内容  即是CanvasContent的尺寸
		 * 
		 */
		
		public function get content():IVisualElement
		{
			return ed::content;
		}
		
		/**
		 * @private
		 */
		public function set content(value:IVisualElement):void
		{
			lastContent = content;
			ed::content = value;
			
			updateContent();
		}
		
		
		/**
		 * 
		 * 内容缩放
		 * 
		 */
		
		public function get contentScale():Number
		{
			return ed::contentScale;
		}
		
		/**
		 * @private
		 */
		public function set contentScale($value:Number):void
		{
			ed::contentScale = $value;
			
			updateContentScale();
		}
		
		
		/**
		 * 
		 * 内容X坐标
		 * 
		 */
		
		public function get contentX():Number
		{
			return ed::contentX;
		}
		
		/**
		 * @private
		 */
		public function set contentX(value:Number):void
		{
			ed::contentX = value;
			
			updateContentX();
		}
		
		
		/**
		 * 
		 * 内容Y坐标
		 * 
		 */
		
		public function get contentY():Number
		{
			return ed::contentY;
		}
		
		/**
		 * @private
		 */
		public function set contentY(value:Number):void
		{
			ed::contentY = value;
			
			updateContentY();
		}
		
		
		/**
		 * 
		 * 内容原始宽度
		 * 
		 */
		
		public function get originWidth():Number
		{
			return content ? content.width : 0;
		}
		
		
		/**
		 * 
		 * 内容原始高度
		 * 
		 */
		
		public function get originHeight():Number
		{
			return content ? content.height : 0;
		}
		
		
		/**
		 * 
		 * 内容缩放后宽度
		 * 
		 */
		
		public function get scaledWidth():Number
		{
			return originWidth * aimScale;
		}
		
		
		/**
		 * 
		 * 内容缩放后高度
		 * 
		 */
		
		public function get scaledHeight():Number
		{
			return originHeight * aimScale;
		}
		
		
		/**
		 * @private
		 */
		private function get cenX():Number
		{
			return (width * .5 - contentX) / contentScale;
		}
		
		/**
		 * @private
		 */
		private function get cenY():Number
		{
			return (height * .5 - contentY) / contentScale;
		}
		
		/**
		 * @private
		 */
		private function get minX():Number
		{
			return width - scaledWidth;
		}
		
		/**
		 * @private
		 */
		private function get maxX():Number
		{
			return 0;
		}
		
		/**
		 * @private
		 */
		private function get minY():Number
		{
			return height - scaledHeight;
		}
		
		/**
		 * @private
		 */
		private function get maxY():Number
		{
			return 0;
		}
		
		
		/**
		 * 
		 * 重置时移动至的X坐标
		 * 
		 */
		
		public var resetScale:Number = 1;
		
		
		/**
		 * 
		 * 重置时移动至的X坐标
		 * 
		 */
		
		public var resetX:Number = 0;
		
		
		/**
		 * 
		 * 重置时移动至的Y坐标
		 * 
		 */
		
		public var resetY:Number = 0;
		
		
		//------------------------------------------------------------
		// 当前移动或缩放时移动的目标值
		//------------------------------------------------------------
		
		/**
		 * @private
		 */
		private var aimX:Number;
		
		/**
		 * @private
		 */
		private var aimY:Number;
		
		
		//------------------------------------------------------------
		// 当前移动或缩放时缩放的目标值，该值在计算坐标限制时有效
		//------------------------------------------------------------
		
		/**
		 * @private
		 */
		private var aimScale:Number;
		
		
		//------------------------------------------------------------
		// 鼠标移动使用的临时变量
		// 鼠标按下时容器的mouseX mouseY
		//------------------------------------------------------------
		
		
		/**
		 * @private
		 */
		private var plusX:Number;
		
		/**
		 * @private
		 */
		private var plusY:Number;
		
		
		//------------------------------------------------------------
		// 鼠标按下时this的mouseX mouseY
		//------------------------------------------------------------
		
		/**
		 * @private
		 */
		private var lastX:Number;
		
		/**
		 * @private
		 */
		private var lastY:Number;
		
		
		//------------------------------------------------------------
		// 上一次的宽高
		//------------------------------------------------------------
		
		/**
		 * @private
		 */
		private var lastWidth:Number;
		
		/**
		 * @private
		 */
		private var lastHeight:Number;
		
		
		//------------------------------------------------------------
		//其他变量
		//------------------------------------------------------------
		
		/**
		 * @private
		 */
		private var container:Group;
		

		
		/**
		 * @private
		 */
		private var lastContent:IVisualElement;
		
		/**
		 * @private
		 */
		private var grid:Grid;
		
	
		
		/**
		 * @private
		 */
		private var back:UIComponent;
		
		/**
		 * @private
		 */
		private var cover:UIComponent;
		
		
		/**
		 * @private
		 */
		ed var content:IVisualElement;
		
		/**
		 * @private
		 */
		ed var minScale:Number = 1;
		
		/**
		 * @private
		 */
		ed var maxScale:Number = 1;
		
		/**
		 * @private
		 */
		ed var contentScale:Number = 1;
		
		/**
		 * @private
		 */
		ed var contentX:Number = 0;
		
		/**
		 * @private
		 */
		ed var contentY:Number = 0;
		
		/**
		 * @private
		 */
		ed var showGrid:Boolean = true;
		
		/**
		 * @private
		 */
		ed var dragOnly:Boolean = false;
		
		/**
		 *@private 
		 */
		ed var alignMode:Boolean = false;
		
	}
}