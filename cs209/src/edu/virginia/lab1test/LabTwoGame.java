package edu.virginia.lab1test;

import java.awt.*;
import java.awt.event.KeyEvent;
import java.util.ArrayList;

import edu.virginia.engine.display.AnimatedSprite;
import edu.virginia.engine.display.Game;

/**
 * Example game that utilizes our engine. We can create a simple prototype game with just a couple lines of code
 * although, for now, it won't be a very fun game :)
 * */
public class LabTwoGame extends Game{

	/* Create a sprite object for our game. We'll use mario */
	AnimatedSprite mario = new AnimatedSprite("Mario", "Mario.png");
	//Sprite mario2 = new Sprite("Mario2", "Mario.png");
	
	/**
	 * Constructor. See constructor in Game.java for details on the parameters given
	 * */
	public LabTwoGame() {
		super("Lab Two Test Game", 500, 300);
	}

	@Override
	public void keyReleased(KeyEvent e){
		super.keyReleased(e);
		if (e.getKeyCode() == KeyEvent.VK_RIGHT){
			mario.stopAnimation(0);
		}
		else if (e.getKeyCode() == KeyEvent.VK_LEFT){
			mario.stopAnimation(2);
		}
	}
	/**
	 * Engine will automatically call this update method once per frame and pass to us
	 * the set of keys (as strings) that are currently being pressed down
	 * */
	@Override
	public void update(ArrayList<Integer> pressedKeys){
		super.update(pressedKeys);
		
		/* Make sure mario is not null. Sometimes Swing can auto cause an extra frame to go before everything is initialized */
		// if(mario != null) mario.update(pressedKeys);

		if (pressedKeys.contains(KeyEvent.VK_UP)){
			mario.setPosition(new Point(mario.getPosition().x,
					mario.getPosition().y - 5));
		}
		if (pressedKeys.contains(KeyEvent.VK_DOWN)){
			mario.setPosition(new Point(mario.getPosition().x,
					mario.getPosition().y + 5));
		}
		if (pressedKeys.contains(KeyEvent.VK_RIGHT)){
			mario.setPosition(new Point(mario.getPosition().x + 5,
					mario.getPosition().y));
			mario.animate("right_move");
		}
		if (pressedKeys.contains(KeyEvent.VK_LEFT)){
			mario.setPosition(new Point(mario.getPosition().x - 5,
					mario.getPosition().y));
			mario.animate("left_move");
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
		if (pressedKeys.contains(KeyEvent.VK_O)){
			mario.setAnimationSpeed(mario.getAnimationSpeed()+3);
		}
		if (pressedKeys.contains(KeyEvent.VK_P)){
			if(mario.getAnimationSpeed() - 3 > 0) {
				mario.setAnimationSpeed(mario.getAnimationSpeed()-3);
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
		if(mario != null) mario.draw(g);
		//if(mario2 != null) mario2.draw(g);
	}

	/**
	 * Quick main class that simply creates an instance of our game and starts the timer
	 * that calls update() and draw() every frame
	 * */
	public static void main(String[] args) {
		LabTwoGame game = new LabTwoGame();
		game.start();

	}
}
