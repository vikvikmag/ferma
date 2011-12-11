package view.renderers
{
	import com.greensock.events.LoaderEvent;
	
	import flash.display.Bitmap;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.geom.Point;
	
	import lui.LUIWidget;
	
	import model.items.ImageProperty;
	import model.items.Plant;
	
	import myLib.controls.Button;
	
	import resources.ImageResource;
	
	import view.PopupManager;

	public class PlantRenderer extends LUIWidget
	{
		private var _imageResource:ImageResource;
		private var _data:Object;
		private var _iconPlant:Bitmap;
		private var _iconContainer:LUIWidget = new LUIWidget();
		private var _btnContainer:LUIWidget = new LUIWidget();
		private var _level:int;
		private var _isNeedOffset:Boolean = false;
		private var _isNeedListeners:Boolean = false;
		private var _pickUpBtn:Button;
		private var _cancel:Button;
		
		public function PlantRenderer()
		{
			addChild(_iconContainer);
			addChild(_btnContainer);
		}
		
		public function set isNeedOffset(value:Boolean):void
		{
			_isNeedOffset = value;
		}
		
		public function get isNeedOffset():Boolean
		{
			return _isNeedOffset;
		}
		
		public function set isNeedListeners(value:Boolean):void
		{
			_isNeedListeners = value;
			if (_isNeedListeners)
			{
				addListeners();
				creatBtns();				
			}
			else
			{
				removeListeners();
			}
		}
		
		/**
		 * 	Создает дополнительные кнопки. "Собрать урожай"
		 */ 
		private function creatBtns():void
		{
			_pickUpBtn = new Button();
			_pickUpBtn.text = "Собрать урожай";
			_cancel = new Button();
			_cancel.text = "Отмена";
			_cancel.addEventListener(MouseEvent.CLICK, onCancelClick);
		}
		
		public function get isNeedListeners():Boolean
		{
			return _isNeedListeners;
		}
		
		private function addListeners():void
		{
			addEventListener(MouseEvent.ROLL_OVER, onRollOverRenderer);
			addEventListener(MouseEvent.ROLL_OUT, onRollOutRenderer);
			addEventListener(MouseEvent.CLICK, onClickRenderer);
		}
		
		private function removeListeners():void
		{
			removeEventListener(MouseEvent.ROLL_OVER, onRollOverRenderer);
			removeEventListener(MouseEvent.ROLL_OUT, onRollOutRenderer);
			removeEventListener(MouseEvent.CLICK, onClickRenderer);
		}
		
		private function onRollOverRenderer(event:MouseEvent):void
		{
			filters = [new GlowFilter(0xffffff, 0.7, 15, 15)];
		}
		
		private function onRollOutRenderer(event:MouseEvent):void
		{
			filters = null;
		}
		
		private function onClickRenderer(event:MouseEvent):void
		{
			var point:Point = localToGlobal(new Point(x,y)); 
			_pickUpBtn.x = point.x;
			_pickUpBtn.y = point.y;
			_cancel.x = point.x;
			_cancel.y = point.y + _pickUpBtn.height + 5;
			
			_btnContainer.addChild(_pickUpBtn);
			_btnContainer.addChild(_cancel);
			//PopupManager.addPopUp(_pickUpBtn);
			//PopupManager.addPopUp(_cancel, false);
		}
		
		private function onCancelClick(event:MouseEvent):void
		{
			_btnContainer.removeChild(_pickUpBtn);
			_btnContainer.removeChild(_cancel);
			//PopupManager.removePopUp(_pickUpBtn);
			//PopupManager.removePopUp(_cancel);
		}
		
		public function set data(value:Object):void
		{
			if (_data == value)
			{	
				return;	
			}
			_data = value;
			_level = (_data as Plant).level;
			_imageResource = new ImageResource((_data as Plant).type + String(_level));
			_imageResource.setListeners(onComplete);
		}
		
		public function get data():Object
		{
			return _data;
		}
		
		private function onComplete(event:LoaderEvent):void
		{
			if (_iconPlant != null && _iconContainer.contains(_iconPlant))
			{
				_iconContainer.removeChild(_iconPlant);
			}
			_iconPlant = _imageResource.bitmap;
			_iconContainer.addChild(_iconPlant);
			resize();
			dispatchEvent(new Event(Event.COMPLETE));
		}
		
		public function update():void
		{
			if (_data != null && _level != (_data as Plant).level)
			{
				_imageResource = new ImageResource((_data as Plant).type + String(_level));
				_imageResource.setListeners(onComplete);
			}
		}		
		
		override public function resize():void
		{
			_iconContainer.width = _btnContainer.width = _width = _iconPlant.width;
			_iconContainer.height = _btnContainer.height = _height = _iconPlant.height;
			if (_isNeedOffset)
			{
				var imageProp:ImageProperty = (data as Plant).imageProperty;
				_iconContainer.x = -imageProp.cx;
				_iconContainer.y = -imageProp.cy;
			}
			else
			{
				_iconContainer.x = 0;
				_iconContainer.y = 0;
			}
		}
	}
}