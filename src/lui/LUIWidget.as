package lui
{
	import flash.display.Sprite;
	import flash.events.Event;
	
	public class LUIWidget extends Sprite
	{
		public function LUIWidget()
		{
		}
		
		protected var _width:int;
		override public function get width():Number
		{
			return _width;
		}
		override public function set width(value:Number):void
		{
			if (_width == value)
			{
				return;
			}
			
			_width = value;
			resize();
		}
		
		protected var _height:int;
		override public function get height():Number
		{
			return _height;
		}
		override public function set height(value:Number):void
		{
			if (_height == value)
			{
				return;
			}
			
			_height = value;
			resize();
		}
		
		
		public function setSize(width:int, height:int):void
		{
			_width  = width;
			_height = height;
			
			resize();
		}
		
		public function resize():void
		{
			
		}
		
		protected var _autoSize:Boolean = true;
		public function set autoSize(value:Boolean):void
		{
			_autoSize = value;
			resize();
		}
		public function get autoSize():Boolean
		{
			return _autoSize;
		}
		
		private var _enabled:Boolean = true;
		public function get enabled():Boolean
		{
			return _enabled;
		}
		public function set enabled(value:Boolean):void
		{
			_enabled = value;
		}
		
		protected final function addStageAdditionListeners():void
		{
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
		}
		
		private function onAddedToStage(event:Event):void
		{
			processAddition();
		}
		
		private function onRemovedFromStage(event:Event):void
		{
			processRemoving();
		}
		
		protected function processAddition():void
		{
			// may be override
		}
		
		protected function processRemoving():void
		{
			// may be override
		}
	}
}