package {
	import flash.display.*;
	import flash.events.*
		import fl.motion.*;

	public class Main extends MovieClip {


		var row: int = 0;
		var col: int = 0;
		var scale: Number = 0.2;
		var tileSize: int = 100;
		var speed: Number = 10;
		var operationsQueue: Array = [];
		var animPlaying: Boolean = false;
		var map: Array = [
			[1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1],
			[1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1],
			[1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1],
			[1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1],
			[1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1],
			[1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1],
			[1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1],
			[1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1],
			[1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1],
			[1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1],
			[1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1],
			[1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1],
			[1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1],
			[1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1],
			[1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1],
			[1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1],
			[1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1],
			[1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1],
			[1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1],
			[1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1],
			[1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1]
		];
		var b: Block;

		var button: Block = new Block();

		public function Main() {
			// constructor code
			for (row = 0; row < map.length; row++) 
			{
				for (col = 0; col < map[0].length; col++) {
					if (map[row][col] == 1) {
						b = new Block();
						addChild(b);
						b.width = b.height = tileSize * scale;
						b.x = col * tileSize * scale;
						b.y = row * tileSize * scale;
						b.name = row + "_" + col;
						b.addEventListener(MouseEvent.MOUSE_OVER, onClick);

						var c: Color = new Color();
						c.setTint(0xFFFFFF * Math.random(), Math.random());
						b.transform.colorTransform = c;

					}
				}
			}
			stage.addChild(button);
			button.x = stage.stageWidth - button.width;
			button.addEventListener(MouseEvent.CLICK, btnClick);
		}


		function btnClick(e: MouseEvent): void {
			button.removeEventListener(MouseEvent.CLICK, btnClick);
			drop();
		}


		function onClick(e: MouseEvent): void {
			if (!animPlaying) {
				var row: int = mouseY / (tileSize * scale);
				var col: int = mouseX / (tileSize * scale);
				var b: Block = Block(getChildByName(row + "_" + col));
				if (b) {
					b.removeEventListener(MouseEvent.MOUSE_OVER, onClick);
					removeChild(b);

					map[row][col] = 0;
					trace("removing ", row, col);
				}

			}
		}


		function drop(): void {
			animPlaying = true;
			operationsQueue = [];

			//go from bottom to top and drop cubes
			for (col = 0; col < map[0].length; col++) {
				var floor: int = -1;
				for (row = map.length - 1; row >= 0; row--) {
					if (map[row][col] == 0) {
						if (row > floor) {
							floor = row;
						}
					} else {
						b = Block(getChildByName(row + "_" + col));
						if (b == null) {
							trace(row + "_" + col, map[row][col]);
						}
						if (row < floor) {
							map[row][col] = 0;
							map[floor][col] = 1;
							b.name = floor + "_" + col;
							operationsQueue.push({
								entity: b,
								dest: floor * tileSize * scale
							})
							floor--;
						}
					}
				}
				//if there are new blocks to spwan
				//place them above screen at (i - floor - 1)
				if (floor >= 0) {
					for (var i: int = floor; i >= 0; i--) {
						b = new Block();
						var c: Color = new Color();
						c.setTint(0xFFFFFF * Math.random(), Math.random());
						b.transform.colorTransform = c;
						b.addEventListener(MouseEvent.MOUSE_OVER, onClick);
						addChild(b);


						b.width = b.height = tileSize * scale;


						b.x = col * tileSize * scale;
						b.y = (i - floor - 1) * tileSize * scale;
						b.name = i + "_" + col;
						operationsQueue.push({
							entity: b,
							dest: i * tileSize * scale
						})
						map[i][col] = 1;
					}
				}
			}

			stage.addEventListener(Event.ENTER_FRAME, update);
		}


		function update(e: Event): void {
			var numComplete: int = 0;
			for (var i: int = 0; i < operationsQueue.length; i++) {
				if (operationsQueue[i].entity.y < operationsQueue[i].dest) {
					operationsQueue[i].entity.y += speed;
				} else {
					operationsQueue[i].entity.y = operationsQueue[i].dest;
					operationsQueue[i].complete = true;
					numComplete++;
				}
			}
			if (numComplete == operationsQueue.length) {
				button.addEventListener(MouseEvent.CLICK, btnClick);
				stage.removeEventListener(Event.ENTER_FRAME, update);
				animPlaying = false;
				trace("done");
			}

		}

	}
}