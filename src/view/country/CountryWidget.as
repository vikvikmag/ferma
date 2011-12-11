package view.country
{
	import as3isolib.display.IsoSprite;
	import as3isolib.display.IsoView;
	import as3isolib.display.primitive.IsoBox;
	import as3isolib.display.scene.IsoGrid;
	import as3isolib.display.scene.IsoScene;
	import as3isolib.geom.Pt;
	
	import controller.GameController;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.utils.Dictionary;
	
	import lui.LUIWidget;
	
	import model.UserData;
	import model.event.UserDataEvent;
	import model.items.Plant;
	
	import view.renderers.CountryRenderer;
	import view.renderers.PlantRenderer;

	public class CountryWidget extends LUIWidget
	{
		private var CELL_SIZE:int = 50;
		
		private var _bg:CountryRenderer;
		private var _isoGrid:IsoGrid;
		private var _isoScene:IsoScene;
		private var _box:IsoBox;
		private var _isoView:IsoView;
		private var _container:Sprite = new Sprite();
		private var _userData:UserData = GameController.instance.userData;
		private var _plantRenderers:Dictionary = new Dictionary();
		
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
			_isoScene.addChild(_isoGrid);
			_isoScene.render();

			//for view
			_isoView = new IsoView();
			_isoView.addScene(_isoScene);
			
			_isoView.visible = false;
			_container.addChild(_isoView);
			
			_container.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			_container.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			_container.addEventListener(MouseEvent.ROLL_OUT, onMouseUp);
			
			GameController.instance.addEventListener(UserDataEvent.UPDATE_USER_DATA, onUpdate);
		}
		
		private function onMouseDown(event:MouseEvent):void
		{
			_container.startDrag();
		}
		
		private function onMouseUp(event:MouseEvent):void
		{
			_container.stopDrag();
		}
		
		private function onBgLoad(event:Event):void
		{
			setSize(_bg.width, _bg.height);
			_isoView.setSize(_width, _height);
			_isoView.centerOnPt(new Pt(370, 330, 0));
			_isoView.visible = true;			
		}
		
		private function onUpdate(event:UserDataEvent):void
		{
			var plantRenderer:PlantRenderer;
			var isoSprite:IsoSprite;
			for each(var plant:Plant in _userData.plants)
			{
				plantRenderer = new PlantRenderer();
				plantRenderer.isNeedOffset = true;
				plantRenderer.data = plant;
				plantRenderer.buttonMode = true;
				plantRenderer.isNeedListeners = true;
				_plantRenderers[plant] = plantRenderer;
				isoSprite = new IsoSprite();
				isoSprite.sprites = [plantRenderer];
				isoSprite.moveTo(plant.tileX * CELL_SIZE, plant.tileY * CELL_SIZE, 0);
				_isoScene.addChild(isoSprite);
			}
			update();
		}
		
		public function update():void
		{
			_isoScene.render();
		}
	}
}