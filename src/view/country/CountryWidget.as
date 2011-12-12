package view.country
{
	import as3isolib.display.IsoSprite;
	import as3isolib.display.IsoView;
	import as3isolib.display.scene.IsoGrid;
	import as3isolib.display.scene.IsoScene;
	import as3isolib.geom.Pt;
	
	import controller.GameController;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.ColorMatrixFilter;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.ui.Mouse;
	import flash.ui.MouseCursor;
	import flash.utils.Dictionary;
	
	import lui.LUIWidget;
	
	import model.UserData;
	import model.event.UserDataEvent;
	import model.items.Plant;
	
	import view.MainStage;
	import view.renderers.CountryRenderer;
	import view.renderers.PlantRenderer;

	public class CountryWidget extends LUIWidget
	{
		private var CELL_SIZE:int = 50;
		
		private var _bg:CountryRenderer;
		private var _isoGrid:IsoGrid;
		private var _isoScene:IsoScene;
		private var _isoView:IsoView;
		private var _container:Sprite = new Sprite();
		private var _userData:UserData = GameController.instance.userData;
		private var _plantRenderers:Dictionary = new Dictionary();
		private var _isoSprites:Dictionary = new Dictionary();
		private var _mouseXOld:int;
		private var _mouseYOld:int;
		private const DELTA:int = 15;
		private var _recDrag:Rectangle;
		
		public function CountryWidget()
		{
			addChild(_container);
					
			_bg = new CountryRenderer();
			_bg.addEventListener(Event.COMPLETE, onBgLoad);
			_container.addChild(_bg);
			
			//for grid
			_isoGrid = new IsoGrid()
			_isoGrid.showOrigin = true;
			_isoGrid.setGridSize(13,13,1);
			_isoGrid.cellSize = CELL_SIZE;
						
			//for scene
			_isoScene = new IsoScene();
			_isoScene.layoutEnabled = true;
			_isoScene.addChild(_isoGrid);
			_isoScene.render();

			//for view
			_isoView = new IsoView();
			_isoView.addScene(_isoScene);
			
			_isoView.visible = false;
			_container.addChild(_isoView);
			
			addListenersContainer();
			
			GameController.instance.addEventListener(UserDataEvent.UPDATE_USER_DATA, onUpdate);
			GameController.instance.addEventListener(UserDataEvent.PICK_UP_PLANT, onPickUpPlant);
			GameController.instance.addEventListener(UserDataEvent.BEGIN_CROP_PLANT, onCropPlant);
		}
		
		private function addListenersContainer():void
		{
			_container.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			_container.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			_container.addEventListener(MouseEvent.ROLL_OUT, onMouseUp);
		}	
		
		private function removeListenersContainer():void
		{
			_container.removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			_container.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			_container.removeEventListener(MouseEvent.ROLL_OUT, onMouseUp);
		}
		
		private function onMouseDown(event:MouseEvent):void
		{		
			_mouseXOld = mouseX;
			_mouseYOld = mouseY;
			_container.addEventListener(Event.ENTER_FRAME, onEnterFrameDrag);
		}
		
		private function onEnterFrameDrag(event:Event):void
		{
			if (Math.abs(_mouseXOld - mouseX) > DELTA || 
				Math.abs(_mouseYOld - mouseY) > DELTA)
			{
				startDragContainer();
			}
		}
		
		private function startDragContainer():void
		{			
			_container.removeEventListener(Event.ENTER_FRAME, onEnterFrameDrag);
			Mouse.cursor = MouseCursor.HAND;
			_container.mouseChildren = false;
			_container.startDrag(false, _recDrag);
		}
		
		private function onMouseUp(event:MouseEvent):void
		{
			_container.removeEventListener(Event.ENTER_FRAME, onEnterFrameDrag);
			Mouse.cursor = MouseCursor.AUTO;
			_container.mouseChildren = true;
			
			_container.stopDrag();
		}
		
		private function onBgLoad(event:Event):void
		{
			setSize(_bg.width, _bg.height);
			var left:int = MainStage.WIDTH - _container.width;
			left = left > 0 ? (MainStage.WIDTH - _container.width) / 2 : left;
			var right:int = MainStage.WIDTH - _container.width < 0 ? Math.abs(left) : 0;
			var top:int = MainStage.HEIGHT - _container.height;
			top = top > 0 ? (MainStage.HEIGHT - _container.height) / 2 : top;
			var bottom:int = MainStage.HEIGHT - _container.height < 0 ? Math.abs(top) : 0;
			_recDrag = new Rectangle(left, top,	right, bottom);
			_isoView.setSize(_width, _height);
			_isoView.centerOnPt(new Pt(370, 330, 0));
			_isoView.visible = true;			
		}
		
		private function onPickUpPlant(event:UserDataEvent):void
		{
			var plant:Plant = event.data as Plant;
			var plantRenderer:PlantRenderer = _plantRenderers[plant];
			var isoSprite:IsoSprite = _isoSprites[plant];
			_isoScene.removeChild(isoSprite);
			delete _plantRenderers[plant];
			delete _isoSprites[plant];
			update();
		}
		
		private var _cropRenderer:PlantRenderer;
		private function onCropPlant(event:UserDataEvent):void
		{
			var plant:Plant = event.data as Plant;
			_cropRenderer = new PlantRenderer();
			_cropRenderer.isNeedOffset = true;
			_cropRenderer.data = plant;
			addChild(_cropRenderer);
			
			removeListenersContainer();
			_container.mouseChildren = false;
			
			addEventListener(Event.ENTER_FRAME, onBeginCropPlantEnterFrame);
			addEventListener(MouseEvent.CLICK, onCropClick);
		}
		
		private function onBeginCropPlantEnterFrame(event:Event):void
		{
			_cropRenderer.x = mouseX;
			_cropRenderer.y = mouseY;
			checkCropRenderers();
		}
		
		private var _cropPt:Pt;
		private function checkCropRenderers():Boolean
		{
			_cropPt = _isoView.localToIso(new Point(_isoView.mouseX, _isoView.mouseY));
			_cropPt.x = Math.round(_cropPt.x / CELL_SIZE);
			_cropPt.y = Math.round(_cropPt.y / CELL_SIZE);
			if (_userData.getPlantUnderPoint(new Point(_cropPt.x, _cropPt.y)) != null)
			{
				_cropRenderer.filters = [new ColorMatrixFilter([
					1.3, 0, 0, 0, 0,
					0, 0, 0, 0, 0,
					0, 0, 0, 0, 0,
					0, 0, 0, 1, 0
				])];
				return false;
			}
			else if (!(_cropPt.x >= 0 && _cropPt.x <= 13 && _cropPt.y >= 0 && _cropPt.y <= 13))
			{
				_cropRenderer.filters = [new ColorMatrixFilter([
					1.3, 0, 0, 0, 0,
					0, 0, 0, 0, 0,
					0, 0, 0, 0, 0,
					0, 0, 0, 1, 0
				])];
				return false;
			}
			else
			{
				_cropRenderer.filters = null;
				return true;
			}
		}
		
		private function onCropClick(event:MouseEvent):void
		{
			removeEventListener(Event.ENTER_FRAME, onBeginCropPlantEnterFrame);
			removeEventListener(MouseEvent.CLICK, onCropClick);
			removeChild(_cropRenderer);
			addListenersContainer();
			_container.mouseChildren = true;
			if (checkCropRenderers())
			{
				var plant:Plant = _cropRenderer.data as Plant;
				plant.tileX = _cropPt.x;
				plant.tileY = _cropPt.y;
				GameController.instance.endCropPlant(plant);
			}			
		}
		
		private function onUpdate(event:UserDataEvent):void
		{
			var plantRenderer:PlantRenderer;
			var isoSprite:IsoSprite;
			for each(var plant:Plant in _userData.plants)
			{
				plantRenderer = _plantRenderers[plant];
				if (plantRenderer == null)
				{
					plantRenderer = new PlantRenderer();
					plantRenderer.isNeedOffset = true;
					plantRenderer.data = plant;
					plantRenderer.buttonMode = true;
					plantRenderer.isNeedListeners = true;
					_plantRenderers[plant] = plantRenderer;
				}
				plantRenderer.update();
				
				isoSprite = _isoSprites[plant];
				if (isoSprite == null)
				{
					isoSprite = new IsoSprite();
					isoSprite.setSize(CELL_SIZE, CELL_SIZE, CELL_SIZE);
					isoSprite.sprites = [plantRenderer];
					_isoSprites[plant] = isoSprite;
					_isoScene.addChild(isoSprite);
				}				
				isoSprite.moveTo(plant.tileX * CELL_SIZE, plant.tileY * CELL_SIZE, 0);								
			}
			update();
		}
		
		public function update():void
		{
			_isoScene.render();
		}
	}
}