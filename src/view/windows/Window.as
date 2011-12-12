package view.windows
{
	import flash.events.Event;
	import flash.geom.Point;
	
	import lui.LUIWidget;
	
	import view.PopupManager;
	
	
	public class Window extends LUIWidget
	{
		public function Window()
		{
			super();
		}		
		
		protected function onParentResize():void
		{
			if (_isCentered)
			{
				PopupManager.centerPopUp(this);
			}
		}
		
		override public function resize():void
		{
			onParentResize();
		}		
		
		private var _isCentered:Boolean = false;
		protected function set isCentered(value:Boolean):void
		{
			_isCentered = value;
			onParentResize();
		}
		protected function get isCentered():Boolean
		{
			return _isCentered;
		}
		
		protected var _modal:Boolean = false;
		public function get modal():Boolean
		{
			return _modal;
		}
		
		protected var _isOpen:Boolean = false;
		public function get isOpen():Boolean
		{
			return _isOpen;
		}
		
		protected var _position:Point;
		public function setPosition(position:Point):void
		{
			_position = position;	
		}
		
		public function open():void
		{
			_isOpen = true;
			PopupManager.addPopUp(this, _modal, _position);
			onParentResize();
		}
		
		public function close():void
		{
			if (_isOpen == true)
			{
				_isOpen = false;
				PopupManager.removePopUp(this);
			}
		}
		
		override public function set enabled(value:Boolean):void
		{
			super.enabled = value;
			
			mouseEnabled = value;
			mouseChildren = value;
		}
	}
}