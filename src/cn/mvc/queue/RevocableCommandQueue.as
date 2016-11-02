package cn.mvc.queue
{
	
	/**
	 * 
	 * 撤销机制命令队列。
	 * 
	 * @author vision
	 * @langversion 3.0
	 * @playerversion Flash 9, AIR 1.1
	 * @productversion vision 1.0
	 * 
	 */
	
	
	import cn.mvc.commands.RevocableCommand;
	import cn.mvc.core.Command;
	import cn.mvc.core.vs;
	import cn.mvc.events.CommandEvent;
	import cn.mvc.events.RevocableCommandEvent;
	import cn.mvc.utils.ArrayUtil;
	
	import editor.core.MDVars;
	
	
	/**
	 * 
	 * 撤销开始时派发此事件。
	 * 
	 */
	
	[Event(name="undoStart", type="cn.mvc.events.RevocableCommandEvent")]
	
	
	/**
	 * 
	 * 撤销结束时派发此事件。
	 * 
	 */
	
	[Event(name="undoEnd", type="cn.mvc.events.RevocableCommandEvent")]
	
	
	/**
	 * 
	 * 重做开始时派发此事件。
	 * 
	 */
	
	[Event(name="redoStart", type="cn.mvc.events.RevocableCommandEvent")]
	
	
	/**
	 * 
	 * 重做结束时派发此事件。
	 * 
	 */
	
	[Event(name="redoEnd", type="cn.mvc.events.RevocableCommandEvent")]
	
	
	public final class RevocableCommandQueue extends SequenceQueue
	{
		
		/**
		 * 
		 * 构造函数。
		 * 
		 */
		
		public function RevocableCommandQueue()
		{
			super();
			
			initialize();
		}
		
		
		/**
		 * @private
		 */
		private function initialize():void
		{
			commandsUndo = new Vector.<RevocableCommand>;
			commandsRedo = new Vector.<RevocableCommand>;
		}
		
		
		/**
		 * 
		 * 撤销上一个命令。
		 * 
		 */
		
		public function undo():void
		{
			if(!executing && undoable)
			{
				vs::executing = true;
				var command:RevocableCommand = ArrayUtil.shift(commandsUndo);
				command.addEventListener(CommandEvent.COMMAND_START, command_undoStartHandler);
				command.addEventListener(CommandEvent.COMMAND_END, command_undoEndHandler);
				command.undo();
			}
		}
		
		
		/**
		 * 
		 * 重做上一个撤销的命令。
		 * 
		 */
		
		public function redo():void
		{
			if(!executing && redoable)
			{
				vs::executing = true;
				var command:RevocableCommand = commandsRedo.pop();
				command.addEventListener(CommandEvent.COMMAND_START, command_redoStartHandler);
				command.addEventListener(CommandEvent.COMMAND_END, command_redoEndHandler);
				command.redo();
			}
		}
		
		
		/**
		 * @inheritDoc
		 */
		
		override protected function executeCommand():void
		{
			if (commandsIdle.length)
			{
				//闲置队列中还有命令，检测Executor能否接受新命令执行。
				if (executor.acceptable)
				{
					//可接受新命令，抽取并执行。
					var command:Command = ArrayUtil.shift(commandsIdle);
					//判断是否为可撤销命令
					var revoca:RevocableCommand = command as RevocableCommand;
					if (revoca && revoca.revocable)
					{
						//添加事件回调。
						command.addEventListener(CommandEvent.COMMAND_END, command_executeHandler);
						//清空重做队列。
						commandsRedo.length = 0;
					}
					executor.execute(command);
				}
			}
			else
			{
				if(!executor.num)
				{
					//队列中的命令已执行完毕，判断当前是否还有任务在执行。
					vs::executing = false;
					queueEnd();
				}
			}
		}
		
		
		/**
		 * @private
		 */
		private function pushCommandToUndos($command:RevocableCommand):void
		{
			if (maxHistoryLength && commandsUndo.length >= maxHistoryLength) commandsUndo.pop();
			ArrayUtil.unshift(commandsUndo, $command);
		}
		
		/**
		 * @private
		 */
		private function pushCommandToRedos($command:RevocableCommand):void
		{
			ArrayUtil.push(commandsRedo, $command);
		}
		
		
		/**
		 * @private
		 */
		private function command_executeHandler($e:CommandEvent):void
		{
			var command:RevocableCommand = $e.command as RevocableCommand;
			command.removeEventListener(CommandEvent.COMMAND_END, command_executeHandler);
			//命令执行完毕，加入撤销队列。
			pushCommandToUndos(command);
			MDVars.instance.editorView.toolBar.uptBtnBcgColor();
		}
		
		/**
		 * @private
		 */
		private function command_undoStartHandler($e:CommandEvent):void
		{
			var command:RevocableCommand = $e.command as RevocableCommand;
			command.removeEventListener(CommandEvent.COMMAND_START, command_undoStartHandler);
			dispatchEvent(new RevocableCommandEvent(RevocableCommandEvent.UNDO_START, command));
		}
		
		/**
		 * @private
		 */
		private function command_undoEndHandler($e:CommandEvent):void
		{
			vs::executing = false;
			var command:RevocableCommand = $e.command as RevocableCommand;
			command.removeEventListener(CommandEvent.COMMAND_END, command_undoEndHandler);
			//命令撤销完毕，加入可重做队列。
			pushCommandToRedos(command as RevocableCommand);
			dispatchEvent(new RevocableCommandEvent(RevocableCommandEvent.UNDO_END, command));
			MDVars.instance.editorView.toolBar.uptBtnBcgColor();
		}
		
		/**
		 * @private
		 */
		private function command_redoStartHandler($e:CommandEvent):void
		{
			var command:RevocableCommand = $e.command as RevocableCommand;
			command.removeEventListener(CommandEvent.COMMAND_START, command_redoStartHandler);
			dispatchEvent(new RevocableCommandEvent(RevocableCommandEvent.REDO_START, command));
		}
		
		/**
		 * @private
		 */
		private function command_redoEndHandler($e:CommandEvent):void
		{
			vs::executing = false;
			var command:RevocableCommand = $e.command as RevocableCommand;
			command.removeEventListener(CommandEvent.COMMAND_END, command_redoEndHandler);
			//命令重做完毕，加入撤销队列。
			pushCommandToUndos(command);
			dispatchEvent(new RevocableCommandEvent(RevocableCommandEvent.UNDO_END, command));
			MDVars.instance.editorView.toolBar.uptBtnBcgColor();
		}
		
		
		/**
		 * 
		 * 可撤销队列历史长度。
		 * 
		 * @default 50
		 * 
		 */
		
		public function get maxHistoryLength():uint
		{
			return vs::maxHistoryLength;
		}
		
		/**
		 * @private
		 */
		public function set maxHistoryLength($value:uint):void
		{
			vs::maxHistoryLength = $value;
			//如果当前撤销队列数组的长度大于historyLength，则对撤销队列数组进行截断。
			if (maxHistoryLength && commandsUndo.length > maxHistoryLength) commandsUndo.length = maxHistoryLength;
		}
		
		
		/**
		 * 
		 * 撤销历史队列长度。
		 * 
		 */
		
		public function get undoHistoryLength():uint
		{
			return commandsUndo.length;
		}
		
		
		/**
		 * 
		 * 重做历史队列长度。
		 * 
		 */
		
		public function get redoHistoryLength():uint
		{
			return commandsRedo.length;
		}
		
		
		/**
		 * 
		 * 队列能否继续执行撤销。
		 * 
		 */
		
		public function get undoable():Boolean
		{
			return commandsUndo.length > 0;
		}
		
		
		/**
		 * 
		 * 队列能否继续执行重做。
		 * 
		 */
		
		public function get redoable():Boolean
		{
			return commandsRedo.length > 0;
		}
		
		
		/**
		 * 可撤销命令队列。
		 * @private
		 */
		public var commandsUndo:Vector.<RevocableCommand>;
		
		/**
		 * 可重做命令队列。
		 * @private
		 */
		public var commandsRedo:Vector.<RevocableCommand>;
		
		
		/**
		 * @private
		 */
		vs var maxHistoryLength:uint = 50;
		
	}
}