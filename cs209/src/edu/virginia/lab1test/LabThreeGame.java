package edu.virginia.lab1test;

import edu.virginia.engine.display.AnimatedSprite;
import edu.virginia.engine.display.DisplayObject;
import edu.virginia.engine.display.DisplayObjectContainer;
import edu.virginia.engine.display.Game;
import edu.virginia.engine.display.SoundManager;

import java.awt.*;
import java.awt.event.KeyEvent;
import java.util.ArrayList;

/**
 * Example game that utilizes our engine. We can create a simple prototype game with just a couple lines of code
 * although, for now, it won't be a very fun game :)
 * */
public class LabThreeGame extends Game{

	/* Create a sprite object for our game. We'll use mario */
	DisplayObjectContainer sun = new DisplayObjectContainer("Sun", "sun.png");

	DisplayObjectContainer planet1 = new DisplayObjectContainer("Planet1", "planet.png");
	DisplayObjectContainer planet2 = new DisplayObjectContainer("Planet2", "planet.png");

	DisplayObject moon1 = new DisplayObject("Moon1", "moon.png");
	DisplayObject moon2 = new DisplayObject("Moon2", "moon.png");
	DisplayObject moon3 = new DisplayObject("Moon3", "moon.png");

	SoundManager sounds = new SoundManager();


	/**
	 * Constructor. See constructor in Game.java for details on the parameters given
	 * */
	public LabThreeGame() {
		super("Lab Three Test Game", 500, 500);
		sun.addChild(planet1);
		sun.addChild(planet2);
		planet1.addChild(moon1);
		planet2.addChild(moon2);
		planet2.addChild(moon3);
		sun.setPosition(new Point(190, 190));
		planet1.setPosition(new Point(200, 200));
		planet2.setPosition(new Point(-150, -20));
		moon1.setPosition(new Point(60, 68));
		moon2.setPosition(new Point(-20, 60));
		moon3.setPosition(new Point(-30, -38));
		sounds.LoadMusic("bgmusic", "C:\\Users\\sschw\\Desktop\\CfL_Lab1\\resources\\synthfinalprojectlowerquality.wav");
		sounds.PlayMusic("bgmusic");
	}

	/**
	 * Engine will automatically call this update method once per frame and pass to us
	 * the set of keys (as strings) that are currently being pressed down
	 * */
	@Override
	public void update(ArrayList<Integer> pressedKeys){
		super.update(pressedKeys);

		if(sun != null){
			Point sun_center = new Point(new Point((int) (sun.getUnscaledWidth() * sun.getScaleX() / 2),
					(int) (sun.getUnscaledHeight() * sun.getScaleY() / 2)));
			Point p1_center = new Point(new Point((planet1.getUnscaledWidth() / 2),
					(planet1.getUnscaledHeight() / 2)));
			Point p2_center = new Point(new Point((planet2.getUnscaledWidth() / 2),
					(planet2.getUnscaledHeight() / 2)));

			sun.setPivotPoint(sun_center);

			planet1.setPivotPoint(planet1.globalToLocal(sun.localToGlobal(sun_center)));
			planet2.setPivotPoint(planet2.globalToLocal(sun.localToGlobal(sun_center)));

			moon1.setPivotPoint(moon1.globalToLocal(planet1.localToGlobal(p1_center)));
			moon2.setPivotPoint(moon2.globalToLocal(planet2.localToGlobal(p2_center)));
			moon3.setPivotPoint(moon3.globalToLocal(planet2.localToGlobal(p2_center)));

			planet1.setRotation(planet1.getRotation() + 1);
			planet2.setRotation(planet2.getRotation() - 2);
			moon1.setRotation(moon1.getRotation() + 5);
			moon2.setRotation(moon2.getRotation() - 5);
			moon3.setRotation(moon3.getRotation() - 10);

			if (pressedKeys.contains(KeyEvent.VK_UP)){
				sun.setPosition(new Point(sun.getPosition().x,
						sun.getPosition().y + 5));
			}
			if (pressedKeys.contains(KeyEvent.VK_DOWN)){
				sun.setPosition(new Point(sun.getPosition().x,
						sun.getPosition().y - 5));
			}
			if (pressedKeys.contains(KeyEvent.VK_RIGHT)){
				sun.setPosition(new Point(sun.getPosition().x - 5,
						sun.getPosition().y));
			}
			if (pressedKeys.contains(KeyEvent.VK_LEFT)){
				sun.setPosition(new Point(sun.getPosition().x + 5,
						sun.getPosition().y));
			}
			if (pressedKeys.contains(KeyEvent.VK_Q)){
				sun.setScaleX(sun.getScaleX() + .01);
				sun.setScaleY(sun.getScaleY() + .01);
			}
			if (pressedKeys.contains(KeyEvent.VK_W)){
				sun.setScaleX(sun.getScaleX() - .01);
				sun.setScaleY(sun.getScaleY() - .01);
			}
			if (pressedKeys.contains(KeyEvent.VK_A)){
				sun.setRotation(sun.getRotation() + 2.5);
			}
			if (pressedKeys.contains(KeyEvent.VK_S)){
				sun.setRotation(sun.getRotation() - 2.5);
			}
		}
		/* Make sure mario is not null. Sometimes Swing can auto cause an extra frame to go before everything is initialized */
		// if(mario != null) mario.update(pressedKeys);
	}
	
	/**
	 * Engine automatically invokes draw() every frame as well. If we want to make sure mario gets drawn to
	 * the screen, we need to make sure to override this method and call mario's draw method.
	 * */
	@Override
	public void draw(Graphics g){
		super.draw(g);
		
		/* Same, just check for null in case a frame gets thrown in before Mario is initialized */
		if(sun != null) sun.draw(g);

	}

	/**
	 * Quick main class that simply creates an instance of our game and starts the timer
	 * that calls update() and draw() every frame
	 * */
	public static void main(String[] args) {
		LabThreeGame game = new LabThreeGame();
		game.start();

	}
}
