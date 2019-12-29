package edu.virginia.lab1test;

import edu.virginia.engine.display.DisplayObject;
import edu.virginia.engine.display.Game;
import edu.virginia.engine.display.SoundManager;

import java.awt.*;
import java.awt.event.KeyEvent;
import java.awt.geom.Ellipse2D;
import java.awt.geom.Rectangle2D;
import java.util.ArrayList;

/**
 * Example game that utilizes our engine. We can create a simple prototype game with just a couple lines of code
 * although, for now, it won't be a very fun game :)
 * */
public class LabFiveGame extends Game{

	/* Create a sprite object for our game. We'll use mario */
	DisplayObject mario = new DisplayObject("Mario", "Mario.png");
	DisplayObject goomba1 = new DisplayObject("Goomba1", "goomba.png");
	Boolean g1direction = true;
	DisplayObject goomba2 = new DisplayObject("Goomba2", "goomba.png");
	Boolean g2direction = true;
	DisplayObject goomba3 = new DisplayObject("Goomba3", "goomba.png");
	Boolean g3direction = true;
	DisplayObject goomba4 = new DisplayObject("Goomba4", "goomba.png");
	Boolean g4direction = true;
	DisplayObject star = new DisplayObject("Star", "star.png");
	Boolean gameOver = false;
	int points = 100;
	DisplayObject floor = new DisplayObject("floor", "floor.png");
	DisplayObject ball = new DisplayObject("ball", "ball.jpeg");
	ArrayList<DisplayObject> gameObjects = new ArrayList<DisplayObject>();
	boolean losable = true;

	double gravityAmount = 0.8;

	SoundManager sounds = new SoundManager();

	/**
	 * Constructor. See constructor in Game.java for details on the parameters given
	 * */
	public LabFiveGame() {
		super("Lab Five Test Game", 1000, 600);
		Ellipse2D marioHitbox = new Ellipse2D.Double(0, 0, 96, 128);
		Ellipse2D goombaHitbox = new Ellipse2D.Double(0, 0, 90, 90);
		Ellipse2D starHitbox = new Ellipse2D.Double(0, 0, 70, 70);
		Ellipse2D ballHitbox = new Ellipse2D.Double(0, 0, 50, 50);
		Rectangle2D floorHitbox = new Rectangle2D.Double(0, 0, 1000, 100);

		floor.addHitboxShape(floorHitbox);
		floor.setPosition(new Point(0,550));
		ball.addHitboxShape(ballHitbox);
		ball.setPosition(new Point(600,100));
		ball.setPhysics(true);
		mario.addHitboxShape(marioHitbox);
		mario.setPosition(new Point(10, 250));
		mario.setScaleX(0.6);
		mario.setScaleY(0.6);
		mario.setPhysics(true);
		goomba1.addHitboxShape(goombaHitbox);
		goomba1.setPosition(new Point(200, 500));
		goomba1.setScaleX(0.6);
		goomba1.setScaleY(0.6);
		goomba2.addHitboxShape(goombaHitbox);
		goomba2.setPosition(new Point(450, 50));
		goomba2.setScaleX(0.6);
		goomba2.setScaleY(0.6);
		goomba3.addHitboxShape(goombaHitbox);
		goomba3.setPosition(new Point(900, 220));
		goomba3.setScaleX(0.6);
		goomba3.setScaleY(0.6);
		goomba3.setPhysics(true);
		goomba4.addHitboxShape(goombaHitbox);
		goomba4.setPosition(new Point(850, 500));
		goomba4.setScaleX(0.6);
		goomba4.setScaleY(0.6);
		star.addHitboxShape(starHitbox);
		star.setPosition(new Point(825, 130));
		sounds.LoadMusic("bgmusic", "synthfinalprojectlowerquality.wav");
		sounds.LoadSoundEffect("collision", "airhorn.wav");
		sounds.LoadSoundEffect("victory", "tada.wav");
		sounds.PlayMusic("bgmusic");
		gameObjects.add(mario);
		gameObjects.add(star);
		gameObjects.add(goomba1);
		gameObjects.add(goomba2);
		gameObjects.add(goomba3);
		gameObjects.add(goomba4);
		gameObjects.add(floor);
		gameObjects.add(ball);
	}

	/**
	 * Engine will automatically call this update method once per frame and pass to us
	 * the set of keys (as strings) that are currently being pressed down
	 * */
	@Override
	public void update(ArrayList<Integer> pressedKeys) {
		super.update(pressedKeys);

		if(mario != null && goomba1 != null && goomba2 != null && goomba3 != null && goomba4 != null && !gameOver){
			for(DisplayObject object: gameObjects){
				if(object.getPhysics()){
					object.setPosition(new Point(object.getPosition().x, object.getPosition().y + (int) gravityAmount));
					if(object.collidesWith(floor)){
						object.setPosition(new Point(object.getPosition().x, object.getPosition().y - (int) gravityAmount));
					}
				}
			}
			if(losable && (mario.collidesWith(goomba1) || mario.collidesWith(goomba2) || mario.collidesWith(goomba3) || mario.collidesWith(goomba4))){
				points -= 1;
				sounds.PlaySoundEffect("collision");
				try {
					Thread.sleep(250);
				}
				catch(Exception e) {

				}
				mario.setPosition(new Point(10, 250));
				mario.setScaleX(0.6);
				mario.setScaleY(0.6);
				mario.setRotation(0);
				mario.setPivotPoint(new Point(0, 0));
				goomba1.setPosition(new Point(200, 500));
				goomba2.setPosition(new Point(450, 50));
				goomba3.setPosition(new Point(900, 220));
				goomba4.setPosition(new Point(850, 500));
				ball.setPosition(new Point(600,100));
			}
			if(mario.collidesWith(star)){
				sounds.PlaySoundEffect("victory");
				gameOver = true;
			}
			if(g1direction){
				goomba1.setPosition(new Point(goomba1.getPosition().x,
						goomba1.getPosition().y - 5));
				if(goomba1.getPosition().y < 20){
					g1direction = false;
				}
			} else {
				goomba1.setPosition(new Point(goomba1.getPosition().x,
						goomba1.getPosition().y + 5));
				if(goomba1.getPosition().y > 480){
					g1direction = true;
				}
			}
			if(g2direction){
				goomba2.setPosition(new Point(goomba2.getPosition().x - 2,
						goomba2.getPosition().y + 5));
				if(goomba2.getPosition().y > 400){
					g2direction = false;
				}
			} else {
				goomba2.setPosition(new Point(goomba2.getPosition().x + 2,
						goomba2.getPosition().y - 5));
				if(goomba2.getPosition().y < 20){
					g2direction = true;
				}
			}
			if(goomba3.getPosition().y < mario.getPosition().y - 3){
				goomba3.setPosition(new Point(goomba3.getPosition().x,
						goomba3.getPosition().y + 2));
			} else if (goomba3.getPosition().y > mario.getPosition().y + 3) {
				goomba3.setPosition(new Point(goomba3.getPosition().x,
						goomba3.getPosition().y - 2));
			}
			if(goomba3.getPosition().x < mario.getPosition().x - 3){
				goomba3.setPosition(new Point(goomba3.getPosition().x + 2,
						goomba3.getPosition().y));
				if(goomba3.collidesWith(ball)){
					goomba3.setPosition(new Point(goomba3.getPosition().x - 10, goomba3.getPosition().y));
					ball.setPosition(new Point(ball.getPosition().x + 10, ball.getPosition().y));
					if(ball.collidesWith(mario)){
						mario.setPosition(new Point(mario.getPosition().x + (int)(10 * (1 / mario.getScaleX())), mario.getPosition().y));
					}
				}
			} else if (goomba3.getPosition().x > mario.getPosition().x + 3){
				goomba3.setPosition(new Point(goomba3.getPosition().x - 2,
						goomba3.getPosition().y ));
				if(goomba3.collidesWith(ball)){
					goomba3.setPosition(new Point(goomba3.getPosition().x + 10, goomba3.getPosition().y));
					ball.setPosition(new Point(ball.getPosition().x - (int)(10 * (1 / mario.getScaleX())), ball.getPosition().y));
					if(ball.collidesWith(mario)){
						mario.setPosition(new Point(mario.getPosition().x - (int)(10 * (1 / mario.getScaleX())), mario.getPosition().y));
					}
				}
			}
			if(g4direction){
				goomba4.setPosition(new Point(goomba4.getPosition().x - 5,
						goomba4.getPosition().y - 2));
				if(goomba4.getPosition().x < 50){
					g4direction = false;
				}
			} else {
				goomba4.setPosition(new Point(goomba4.getPosition().x + 5,
						goomba4.getPosition().y + 2));
				if(goomba4.getPosition().x > 850){
					g4direction = true;
				}
			}

			if (pressedKeys.contains(KeyEvent.VK_UP) && mario.getPosition().y > 0){
				mario.setPosition(new Point(mario.getPosition().x,
						mario.getPosition().y - 5));
				if(mario.collidesWith(ball)){
					mario.setPosition(new Point(mario.getPosition().x, mario.getPosition().y + 5));
					ball.setPosition(new Point(ball.getPosition().x, ball.getPosition().y - 10));
				}
			}
			if (pressedKeys.contains(KeyEvent.VK_DOWN) && mario.getPosition().y < 500){
				mario.setPosition(new Point(mario.getPosition().x,
						mario.getPosition().y + 5));
				if(mario.collidesWith(ball)){
					mario.setPosition(new Point(mario.getPosition().x, mario.getPosition().y - 5));
					ball.setPosition(new Point(ball.getPosition().x, ball.getPosition().y + 10));
				}
			}
			if (pressedKeys.contains(KeyEvent.VK_RIGHT) && mario.getPosition().x < 950){
				mario.setPosition(new Point(mario.getPosition().x + 5,
						mario.getPosition().y));
				if(mario.collidesWith(ball)){
					mario.setPosition(new Point(mario.getPosition().x - (int)(10 * mario.getScaleX()), mario.getPosition().y));
					ball.setPosition(new Point(ball.getPosition().x + (int)(10 * mario.getScaleX() + 1), ball.getPosition().y));
					if(goomba3.collidesWith(ball)){
						goomba3.setPosition(new Point(goomba3.getPosition().x - (int)(10 * mario.getScaleX()), goomba3.getPosition().y));
					}
				}
			}
			if (pressedKeys.contains(KeyEvent.VK_LEFT) && mario.getPosition().x > 0){
				mario.setPosition(new Point(mario.getPosition().x - 5,
						mario.getPosition().y));
				if(mario.collidesWith(ball)){
					mario.setPosition(new Point(mario.getPosition().x + (int)(10 * mario.getScaleX()), mario.getPosition().y));
					ball.setPosition(new Point(ball.getPosition().x - (int)(10 * mario.getScaleX() - 1), ball.getPosition().y));
					if(goomba3.collidesWith(ball)){
						goomba3.setPosition(new Point(goomba3.getPosition().x + (int)(10 * mario.getScaleX()), goomba3.getPosition().y));
					}
				}
			}
			if (pressedKeys.contains(KeyEvent.VK_V)){
				if(mario.getVisibility()){
					mario.setVisibility(false);
				} else {
					mario.setVisibility(true);
				}
			}
			if (pressedKeys.contains(KeyEvent.VK_I)){
				mario.setPivotPoint(new Point(mario.getPivotPoint().x,
						mario.getPivotPoint().y - 5));
			}
			if (pressedKeys.contains(KeyEvent.VK_K)){
				mario.setPivotPoint(new Point(mario.getPivotPoint().x,
						mario.getPivotPoint().y + 5));
			}
			if (pressedKeys.contains(KeyEvent.VK_J)){
				mario.setPivotPoint(new Point(mario.getPivotPoint().x - 5,
						mario.getPivotPoint().y));
			}
			if (pressedKeys.contains(KeyEvent.VK_L)){
				mario.setPivotPoint(new Point(mario.getPivotPoint().x + 5,
						mario.getPivotPoint().y));
			}
			if (pressedKeys.contains(KeyEvent.VK_W)){
				mario.setRotation(mario.getRotation() + 1);
			}
			if (pressedKeys.contains(KeyEvent.VK_Q)){
				mario.setRotation(mario.getRotation() - 1);
			}
			if (pressedKeys.contains(KeyEvent.VK_A)){
				mario.setScaleX(mario.getScaleX() + .01);
				mario.setScaleY(mario.getScaleY() + .01);
			}
			if (pressedKeys.contains(KeyEvent.VK_S)){
				mario.setScaleX(mario.getScaleX() - .01);
				mario.setScaleY(mario.getScaleY() - .01);
			}
			if (pressedKeys.contains(KeyEvent.VK_Z)){
				float new_alpha = mario.getAlpha() - .01f;
				if(new_alpha >= 0.0f) {
					mario.setAlpha(new_alpha);
				}
			}
			if (pressedKeys.contains(KeyEvent.VK_X)){
				float new_alpha = mario.getAlpha() + .01f;
				if(new_alpha <= 1.0f) {
					mario.setAlpha(new_alpha);
				}
			}
			if (pressedKeys.contains(KeyEvent.VK_G)){
				gravityAmount += 0.1;
			}
			if (pressedKeys.contains(KeyEvent.VK_H)){
				if(gravityAmount > 0){
					gravityAmount -= 0.1;
				}
			}
			if (pressedKeys.contains(KeyEvent.VK_1)){
				losable = false;
			}
			if (pressedKeys.contains(KeyEvent.VK_2)){
				losable = true;
			}
		}
	}
	
	/**
	 * Engine automatically invokes draw() every frame as well. If we want to make sure mario gets drawn to
	 * the screen, we need to make sure to override this method and call mario's draw method.
	 * */
	@Override
	public void draw(Graphics g){
		super.draw(g);
		
		/* Same, just check for null in case a frame gets thrown in before Mario is initialized */
		if(floor != null) floor.draw(g);
		if(ball != null) ball.draw(g);
		if(mario != null) mario.draw(g);
		if(goomba1 != null) goomba1.draw(g);
		if(goomba2 != null) goomba2.draw(g);
		if(goomba3 != null) goomba3.draw(g);
		if(goomba4 != null) goomba4.draw(g);
		if(star != null) star.draw(g);
		g.drawString(String.valueOf(points) + " points", 10, 20);
		if(gameOver){
			g.setFont(new Font("TimesRoman", Font.PLAIN, 35));
			g.drawString("You win!", 450, 275);
		}
	}

	/**
	 * Quick main class that simply creates an instance of our game and starts the timer
	 * that calls update() and draw() every frame
	 * */
	public static void main(String[] args) {
		LabFiveGame game = new LabFiveGame();
		game.start();

	}
}
